#Expect a long query time
$TDate = Get-Date
$CurrentDate = $TDate.ToString('MM-dd-yyyy_hh-mm-ss')
$UserName = "$env:USERNAME"
$ReportsLoc = "C:\Users\$UserName\Reports"
Get-MobileDevice -Result Unlimited | Get-ActiveSyncDeviceStatistics | Where {$_.LastSuccessSync -le (Get-Date).AddDays(“-30”)}