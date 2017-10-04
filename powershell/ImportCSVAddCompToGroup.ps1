Import-Module ActiveDirectory
$TDate = Get-Date
$CurrentDate = $TDate.ToString('MM-dd-yyyy_hh-mm-ss')
$UserName = "$env:USERNAME"
$ReportsLoc = "C:\Users\$UserName\Reports"
$ADGroup = "GroupRollout"
$CompInfo = Import-Csv "$ReportsLoc\Rollout\RolloutGroups-Phase1.csv'
Foreach ($comp in $CompInfo)
{
$lastcomp = $comp.Hostname
$lastcomp
Get-ADComputer $lastcomp | Add-ADPrincipalGroupMembership -MemberOf $ADGroup
}