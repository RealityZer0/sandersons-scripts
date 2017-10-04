Import-Module ActiveDirectory
$TDate = Get-Date
$CurrentDate = $TDate.ToString('MM-dd-yyyy_hh-mm-ss')
$UserName = "$env:USERNAME"
$ReportsLoc = "C:\Users\$UserName\Reports"
$MacADGroup = "MacADGroupHere"
$Userinfo = Import-Csv "$ReportsLoc\macusers.csv"
Foreach ($user in $Userinfo)
{
$lastuser = $user.Username
If(!($lastuser -eq $null))
{
$lastuser
Add-ADGroupMember -Identity $MacADGroup -Members $lastuser}
}