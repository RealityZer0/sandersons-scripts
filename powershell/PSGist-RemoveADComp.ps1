$TGTComp = read-host "Enter the computer name"
$LocalAdmin = "LocalAdminAccount"
$WorkGroup = "WorkGroupHere"
Remove-Computer -ComputerName $TGTComp -Confirm -LocalCredential $LocalAdmin -WorkgroupName $WorkGroup