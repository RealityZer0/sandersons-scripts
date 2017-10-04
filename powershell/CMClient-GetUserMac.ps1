Import-Module "C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1"
CD SNA:
#Location of CSV file
$TDate = Get-Date
$CurrentDate = $TDate.ToString('MM-dd-yyyy_hh-mm-ss')
$UserName = "$env:USERNAME"
$ReportsLoc = "C:\Users\$UserName\Reports"
$Lists = Import-Csv "$ReportsLoc\MacUsers.csv"
Foreach ($List in $Lists)
{
	$CorpUsers = get-CMUserDeviceAffinity -DeviceName $List.ComputerName
	Foreach ($CorpUser in $CorpUsers)
	{
		$User = $CorpUser.UniqueUserName.trimstart("domain\")
		$newline = "{0},{1}" -f $List.ComputerName,$User
		add-content "$ReportsLoc\MacHostsExport.csv" $newline
	}
}