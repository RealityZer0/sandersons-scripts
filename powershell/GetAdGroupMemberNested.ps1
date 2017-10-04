$CurrentDate = Get-Date
$CurrentDate = $CurrentDate.ToString('MM-dd-yyyy_hh-mm-ss')
$ReportsLoc = "C:\Users\$UserName\Reports"
$TGTGroup = read-host "Enter the Active Directory group name:"
Get-ADGroupMember $TGTGroup -Recursive | select-object Name | Export-CSV -Path $ReportsLoc\$TGTGroup-Members_$CurrentDate.csv -Append