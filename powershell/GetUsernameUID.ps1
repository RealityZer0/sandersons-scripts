import-module activedirectory
$TDate = Get-Date
$CurrentDate = $TDate.ToString('MM-dd-yyyy_hh-mm-ss')
$Users = Get-Content C:\Users\USERHERE\Reports\teamviewer_users.csv            
            
foreach($User in $Users) {            
            
Get-ADUser $User -properties Name,GivenName,Surname,UserPrincipalName,SamAccountName,Department,Description | select  Name,GivenName,Surname,UserPrincipalName,SamAccountName,Department,Description | Export-CSV C:\Users\USERHERE\Reports\tvusers-$CurrentDate.csv -NoTypeInformation -Append
            
}
