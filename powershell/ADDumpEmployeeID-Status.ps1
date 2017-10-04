$TDate = Get-Date
$CurrentDate = $TDate.ToString('MM-dd-yyyy_hh-mm-ss')
Get-ADUser -SearchBase "OU=People,dc=domain,dc=com" -Filter * -Properties SamAccountName,employeeID,UserPrincipalName,extensionAttribute6  | select SamAccountName,employeeID,UserPrincipalName,extensionAttribute6 | Export-Csv C:\Users\USERHERE\Reports\AD-Dump-eID-$CurrentDate.csv