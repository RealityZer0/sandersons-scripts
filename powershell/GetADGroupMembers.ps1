#Import-Module ActiveDirectory
$TDate = Get-Date
$CurrentDate = $TDate.ToString('MM-dd-yyyy_hh-mm-ss')
$UserName = "$env:USERNAME"
$ReportsLoc = "C:\Users\$UserName\Reports"
$GroupName = "MacAdminADGroup"

$Users = (Get-ADGroupMember -identity "$GroupName" -Recursive).SamAccountName

Foreach ($User in $Users)
{
        
Get-ADUser $User -properties SamAccountName,GivenName,Surname,UserPrincipalName | select  SamAccountName,GivenName,Surname,UserPrincipalName | Export-CSV $ReportsLoc\MacLocalAdmins-$CurrentDate.csv -NoTypeInformation -Append
            
}