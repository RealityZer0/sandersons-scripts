$TDate = Get-Date
$CurrentDate = $TDate.ToString('MM-dd-yyyy_hh-mm-ss')
$UserName = "$env:USERNAME"
$ReportsLoc = "C:\Users\$UserName\Reports"
Get-MobileDevice -Filter {DeviceType -eq "Outlook"} | Get-MobileDeviceStatistics |select UserDisplayName,DeviceType,DeviceUserAgent,DeviceModel,DeviceAccessState | export-csv $ReportsLoc-MobileOutlookUsers-$CurrentDate.csv
Get-MobileDevice -Filter {ClientType -eq "MOWA"} | select UserDisplayName,DeviceType,DeviceUserAgent,DeviceModel,DeviceAccessState | export-csv $ReportsLoc\MobileOWAUsers-$CurrentDate.csv