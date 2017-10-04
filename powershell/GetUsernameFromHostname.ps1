Import-Module "C:\Program Files (x86)\ConfigMgr\bin\ConfigurationManager.psd1"
CD SNA:
#Location of CSV file
$TDate = Get-Date
$CurrentDate = $TDate.ToString('MM-dd-yyyy_hh-mm-ss')
$UserName = "$env:USERNAME"
$ReportsLoc = "C:\Users\$UserName\Reports"
$Lists = Import-Csv "$ReportsLoc\MacstatsHosts.csv"
Foreach ($List in $Lists){
$DomainUsers = get-CMUserDeviceAffinity -DeviceName $List.ComputerName
Foreach ($DomainUser in $DomainUsers){
$User = $DomainUser.UniqueUserName.trimstart("domain\")
$newline = "{0},{1}" -f $List.ComputerName,$User
add-content "$ReportsLoc\MacsHostsExport-$CurrentDate.csv" $newline
}
}