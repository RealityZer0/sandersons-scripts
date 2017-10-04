$CurrentDate = Get-Date
$CurrentDate = $CurrentDate.ToString('MM-dd-yyyy_hh-mm-ss')
$ReportsLoc = "C:\Users\$UserName\Reports"
Get-ADObject -LDAPFilter "(&(objectCategory=group)(gidNumber=*))" -Properties gidNumber | Select @{Name="DN";Expression={$_.DistinguishedName}},@{Name="gid";Expression={$_.gidNumber}}| Export-CSV $ReportsLoc\GroupsGIDS_$CurrentDate.csv -NoTypeInformation -Append