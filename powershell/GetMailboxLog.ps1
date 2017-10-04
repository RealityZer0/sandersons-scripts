$TDate = Get-Date
$CurrentDate = $TDate.ToString('MM-dd-yyyy_hh-mm-ss')
$UserName = "$env:USERNAME"
$ReportsLoc = "C:\Users\$UserName\Reports"
$TGTUser = read-host "Enter the Users Name"
Get-MobileDeviceStatistics -Mailbox "$TGTUser"-GetMailboxLog:$true -NotificationEmailAddresses admin.here@domain.com