import-module activedirectory
$TDate = Get-Date
$CurrentDate = $TDate.ToString('MM-dd-yyyy_hh-mm-ss')
$UserName = "$env:USERNAME"
$ReportsLoc = "C:\Users\$UserName\Reports"
$Users = Get-Content $ReportsLoc\import.csv            
            
foreach($User in $Users) 
{            
            
Get-ADUser -filter {name -like $User} -Properties Name,GivenName,Surname,UserPrincipalName,SamAccountName | Select Name,GivenName,Surname,UserPrincipalName,SamAccountName | Export-CSV $ReportsLoc_CheckUsers-$CurrentDate.csv -NoTypeInformation -Append
            
}
