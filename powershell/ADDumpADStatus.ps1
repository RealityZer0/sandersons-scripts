$TDate = Get-Date
$CurrentDate = $TDate.ToString('MM-dd-yyyy_hh-mm-ss')
Get-ADUser -SearchBase "OU=People,dc=domain,dc=com" -Filter * -Properties Name,SamAccountName,UserPrincipalName,extensionAttribute6 | select Name,SamAccountName,UserPrincipalName,extensionAttribute6 | Export-Csv C:\Users\USERHERE\Documents\Reports\AD-Dump-Active-$CurrentDate.csv