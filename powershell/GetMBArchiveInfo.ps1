$TDate = Get-Date
$CurrentDate = $TDate.ToString('MM-dd-yyyy_hh-mm-ss')
$UserName = "$env:USERNAME"
$ReportsLoc = "C:\Users\$UserName\Reports"
$TGTUser = read-host "Enter the Users Name"
Get-MailboxFolderStatistics "$TGTUser" -Archive | Export-Csv $ReportsLoc\$TGTUser-$CurrentDate.csv