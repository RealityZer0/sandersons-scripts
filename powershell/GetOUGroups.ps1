$TDate = Get-Date
$CurrentDate = $TDate.ToString('MM-dd-yyyy_hh-mm-ss')
$UserName = "$env:USERNAME"
$ReportsLoc = "C:\Users\$UserName\Reports"
$TGTOU = "ou=Mac,ou=SCCM Software,ou=groups,dc=domain,dc=com"
$MacGroup=Get-ADGroup -SearchBase "$TGTOU" -filter *
$MacGroupNames=$MacGroup.name
$MacGroupNames

Foreach($MacGroupName in $MacGroupNames)
{
Get-ADGroupMember $MacGroupName | name | Export-Csv -Path "$ReportsLoc\$TGTOU_Groups_$CurrentDate.csv" -NoTypeInformation -Append
} 
