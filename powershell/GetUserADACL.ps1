Import-Module ActiveDirectory
$TDate = Get-Date
$CurrentDate = $TDate.ToString('MM-dd-yyyy_hh-mm-ss')
$UserName = "$env:USERNAME"
$ReportsLoc = "C:\Users\$UserName\Reports"
$TGTUser = read-host "Enter the Users Name"

(Get-ACL "AD:$((Get-ADUser "$TGTUser").distinguishedname)").access | Export-Csv "$ReportsLoc\$TGTUser-ACLs-$CurrentDate.csv" -NoTypeInformation -Append