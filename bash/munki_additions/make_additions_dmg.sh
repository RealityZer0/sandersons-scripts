#!/bin/sh

#	2012-07-03
#	Heig Gregorian <hgregorian>
#	Mac OS X Systems Administrator
#   Revisions necessary. Scott Anderson 10/26/15 version 3.3.0
#	Script for creating a munki pkg distribution (with configuration pkg) dmg

fname="MunkiAdditions"
script_path="$( cd "$( dirname "$0" )" && pwd )"
additions_dir=""$script_path"/munki-client-scripts"
output_dir=""$script_path"/output"
repo_dir="munki-framework"
dmg_output_dir="$output_dir/pkgs/$repo_dir"
pkginfo_output_dir="$output_dir/pkgsinfo/$repo_dir"
luggage_dir="$script_path/luggage-make"

repo_url="$(defaults read ~/Library/Preferences/com.googlecode.munki.munkiimport repo_url 2>/dev/null)"
repo_path="$(defaults read ~/Library/Preferences/com.googlecode.munki.munkiimport repo_path 2>/dev/null)"

repoAvail()
{
	if [ -z "$repo_path" ]; then
		echo "Repo path not specified."
		return 1
	fi

	if [ ! -e "$repo_path" ]; then
		mountRepoCLI
	fi

	if [ ! -d "$repo_path" ]; then
		return 1
	fi

	subdir_array=(catalogs manifests pkgs pkgsinfo)
	for subdir in ${subdir_array[@]}; do
		if [ ! -e "$repo_path/$subdir" ]; then
			return 1
		fi
	done

	return 0
}

mountRepoCLI()
{
	if [ -z "$repo_url" ] || [ -z "$repo_path" ]; then
		echo "Repo not defined..."
		return 1
	fi

	repo_url_prefix="${repo_url%:*}"

	mkdir "${repo_path}"
	printf 'Attempting to mount fileshare %s:\n' ${repo_url}
	if [ "$repo_url_prefix" == "afp" ]; then
		/sbin/mount_afp -i "${repo_url}" "${repo_path}"
	elif [ "$repo_url_prefix" == "smb" ]; then
		/sbin/mount_smbfs "${repo_url:4}" "${repo_path}"
	elif [ "$repo_url_prefix" == "nfs" ]; then
		/sbin/mount_nfs "${repo_url:6}" "${repo_path}"
	else
		echo "Unsupported filesystem URL!"
	fi
}

unmountRepoCLI()
{
	if [ ! -e "$repo_path" ]; then
		return
	else
		/sbin/umount "${repo_path}"
	fi
}

askQuestion () {
	response=
	while ! [[ $response =~ ^([yY]|[nN])$ ]]; do
		read -r -p "${1:-Are you sure? [Y/n]} " response
		case $response in
			[yY])
				return
				;;
			[nN])
				return 1
				;;
			*)
				;;
	    esac
	done
}

# Setup output directories
rm -rf "$output_dir"
if [ ! -d "$dmg_output_dir" ]; then
	mkdir -p "$dmg_output_dir"
fi

if [ ! -d "$pkginfo_output_dir" ]; then
	mkdir -p "$pkginfo_output_dir"
fi

build_installs_optargs()
{
	target_dir="$1"
	for file in `ls $target_dir`; do
		if [ -f "$target_dir/$file" ]; then
			mpi_installs_optargs+=("-f $target_dir/$file")
		fi
	done
}

if [ ! -e "$luggage_dir/Makefile" ]; then
	echo "Makefile not found in \"$luggage_dir\""
	exit 1
fi

if ! version="$(awk -F "=" '/^PACKAGE_VERSION/{print $NF}' "$luggage_dir/Makefile" 2>/dev/null)"; then
	echo "PACKAGE_VERSION not found in Makefile!"
	exit 1
fi

pushd $luggage_dir >/dev/null

if ! make dmg TYPE=FULL | tee /tmp/"$fname"-luggage.out; then
	echo "Luggage failure...unable to create package!"
	exit 1
fi

dmg_path=`awk -F ": " '/^created/{print $NF}' /tmp/"$fname"-luggage.out`
dmg_fname="${dmg_path##*/}"

rm -rf /tmp/"$fname"-luggage.out

popd >/dev/null

mv -f "${dmg_path}" "${dmg_output_dir}"
dmg_path="${dmg_output_dir}/${dmg_fname}"


pkginfo_fname="${dmg_fname%.*}.plist"
pkginfo_path="${pkginfo_output_dir}/${pkginfo_fname}"

echo "Building installs keys..."
build_installs_optargs "$script_path/usr/local/munki"
build_installs_optargs "$script_path/usr/local/munki/conditions"

echo "Creating pkginfo file..."
/usr/local/munki/makepkginfo -c "testing" "${dmg_path}" ${mpi_installs_optargs[@]} | sed "s,$script_path,,g" > "${pkginfo_path}"
defaults write "${pkginfo_path%.*}" unattended_install -bool true
defaults write "${pkginfo_path%.*}" unattended_uninstall -bool true
defaults write "${pkginfo_path%.*}" name "$(awk -F "=" '/^MUNKI_PKG_NAME/{print $NF}' "$luggage_dir/Makefile" 2>/dev/null)"
defaults write "${pkginfo_path%.*}" description "$fname $version - Created: `date "+%Y-%m-%d %H:%M:%S"`"
plutil -convert xml1 "${pkginfo_path}"

mv "${pkginfo_path}" "${pkginfo_path/.plist/.pkginfo}"
pkginfo_path="${pkginfo_path/.plist/.pkginfo}"

sudo chown ${UID} "${dmg_path}"
sudo chown ${UID} "${pkginfo_path}"

pushd "${output_dir}" >/dev/null

echo "Output directory structure:"

if which tree &>/dev/null; then
	tree .
else
	ls -lRf .
fi

if askQuestion "Would you like to copy these assets to the munki repo? (y/n):"; then
	if repoAvail; then
		printf "Copying "${dmg_path##*/}"..."
		if cp "${dmg_path}" "${repo_path}/pkgs/$repo_dir/"; then
			printf "success.\n"
		else
			printf "FAILURE.\n"
			exit 1
		fi

		printf "Copying "${pkginfo_path##*/}"..."
		if cp "${pkginfo_path}" "${repo_path}/pkgsinfo/$repo_dir/"; then
			printf "success.\n"
		else
			printf "FAILURE.\n"
			exit 1
		fi
	else
		echo "Repo could not be mounted...exiting"
		exit 0
	fi

	if askQuestion "Would you like to run makecatalogs? (y/n)"; then
		/usr/local/munki/makecatalogs "${repo_path}"
	fi

	if askQuestion "Would you like to unmount the munki repo? (y/n)"; then
		echo "Unmounting munki repo..."
		unmountRepoCLI
	fi
fi


echo "Done."

exit 0
