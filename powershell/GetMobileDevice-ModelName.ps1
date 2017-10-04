$TDate = Get-Date
$CurrentDate = $TDate.ToString('MM-dd-yyyy_hh-mm-ss')
$UserName = "$env:USERNAME"
$ReportsLoc = "C:\Users\$UserName\Reports"
Get-MobileDevice -OrganizationalUnit People | select-object DeviceModel,FriendlyName,DeviceOS,UserDisplayName | Export-Csv $ReportsLoc\EAS_Count-$CurrentDate.csv