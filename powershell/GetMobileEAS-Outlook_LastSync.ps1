$TDate = Get-Date
$CurrentDate = $TDate.ToString('MM-dd-yyyy_hh-mm-ss')
$UserName = "$env:USERNAME"
$ReportsLoc = "C:\Users\$UserName\Reports"
Get-MobileDevice -ResultSize Unlimited | Get-MobileDeviceStatistics | select Identity,DeviceModel,DeviceFriendlyName,DeviceUserAgent,LastSuccessSync | Export-Csv $ReportsLoc\ALL-EAS-Export-$CurrentDate.csv