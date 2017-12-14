munki-additions
===================


General Information
-------------------

This project can create two types of deployment "packages" depending on the deployment need.  Please see usage for specific information regarding these methods.  This repo is also a `submodule` dependency of the [munki-custom-mpkg](http://git.corp.attinteractive.com/corpsys/munki-custom-mpkg) repo.

Usage
-----

munki-additions includes two methods of “packaging” which correspond to two methods of deployment:

#### Deployment via an existing munki repo &#8594; describes <html><sup>1</sup></html> in tree below
A script which builds a .dmg and corresponding .pkginfo file.  The .dmg contains a .pkg created by a luggage makefile and contains all custom munki scripts and conditions scripts (contained in `./usr`).  The .pkginfo file is created by a call to `/usr/local/munki/makepkginfo` and includes an 'installs' array representing the items installed by the package.  Both .dmg and .pkginfo file are placed in `./output` and allow for easy inclusion into a munki repo for distribution to clients.

Note:
This method issues `make dmg TYPE=BASE` from inside the `luggage-make` directory.  This 'TYPE' does not include any client configuration information.  Essentially, it exists for updating existing clients only and not for an initial install of the munkitools package.

#### Deployment via the munki mpkg distribution build &#8594; describes <html><sup>2</sup></html> in tree below
This is the luggage assets directory which creates a Mac OS X .pkg (or .dmg) that when created by issuing `make pkg TYPE=FULL` is to be included with the munkitools mpkg distribution build.  It is essentially the same package created as the one above with the inclusion of client configuration information.  Items included in the `luggage-make` directory **are** configurable but require knowledge of `make` and specific [luggage terminology](https://github.com/unixorn/luggage/wiki/).


<pre>
$ tree munki-additions
munki-additions
├── ATTi-make_additions_dmg.sh<sup>1</sup>
├── README.md
├── luggage-make<sup>2</sup>
│   ├── Makefile
│   ├── postflight
│   ├── preflight
│   └── preflight_base
└── usr<sup>3</sup>
    └── local
        └── munki
            ├── conditions
            │   ├── fetch_ad_facts.sh
            │   ├── fetch_ad_groups.sh
            │   ├── gethardware_ports.sh
            │   └── getnetworkinfo.py
            ├── getmanifest
            ├── manifest_profiler
            ├── manifest_stamper
            ├── postflight
            ├── preflight
            ├── report_broken_client
            └── stage_only
5 directories, 17 files
</pre>

>The actual scripts that are included in the luggage package can be seen at <sup>3</sup>.  The directory structure mimics that of the actual munki directory - /usr/local/munki

_Luggage usage is outside the scope of this README.  Overall documentation is [here](https://github.com/unixorn/luggage/wiki/) and some examples are [here](https://github.com/unixorn/luggage-examples)._

Description of client-side scripts
----------------------------------

#### /usr/local/munki
* **getmanifest** - Pulls a fresh base manifest from the munki repo. (currently an NFS automount)
* **manifest_profiler** - Using group membership queries for the current user and computer, determine if any "stamps" should be applied, followed by handing them off to the below item.
* **manifest_stamper** - Compares stamp(s) to base manifest, determines what additions are needed and applies them.
* **postflight** - Communicates final managedsoftwareupdate run (command-line or GUI) to [MunkiReport] [2] server.
* **preflight** - Communicates initialization of managedsoftwareupdate run (command-line or GUI) to [MunkiReport] [2] server.  Kicks off `getmanifest` and `manifest_profiler`.
* **report_broken_client** - Reports a client issue to [MunkiReport] [2] server.

#### /usr/local/munki/conditions
* **fetch_ad_facts.sh** - Basic information about the client's AD bind including current site, domain, DC, Centrify zone, and Centrify version
* **fetch_ad_groups.sh** - Enumerates groups that the current user is in and the current computer
* **gethardware_ports.sh** - Current active hardware ports (Bluetooth, Wi-Fi, Ethernet, VPN profile, etc.)
* **getnetworkinfo.py** - Primary network interface name (ex. utun0, en1, etc.) and its IPv4 address.

Dependancies (for building using the described "packaging" methods)
------------

* **packagemaker CLI** (included with Xcode)
* **[The Luggage] [3]**

[1]: http://code.google.com/p/munki/       "Munki"
[2]: http://code.google.com/p/munkireport/  "MunkiReport"
[3]: https://github.com/unixorn/luggage    "The Luggage"
[4]: http://git.corp.attinteractive.com/corpsys/munki-additions	"munki-additions"