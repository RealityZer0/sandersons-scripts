import-module activedirectory
$TDate = Get-Date
$CurrentDate = $CurrentDate.ToString('MM-dd-yyyy_hh-mm-ss')
$UserName = "$env:USERNAME"
$ReportsLoc = "C:\Users\$UserName\Reports"
$Users = Get-Content "$ReportsLoc"\macstats-unique-users.csv            
            
foreach($User in $Users) {            
            
Get-ADUser $User -properties Name,GivenName,Surname,UserPrincipalName,SamAccountName,extensionAttribute2 | select  Name,GivenName,Surname,UserPrincipalName,SamAccountName,extensionAttribute2 | Export-CSV "$ReportsLoc"\CheckUsers-EUI-$CurrentDate.csv -NoTypeInformation -Append
            
}
