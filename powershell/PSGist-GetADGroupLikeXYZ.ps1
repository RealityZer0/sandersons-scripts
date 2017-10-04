$TGTGroup = read-host "Enter the Active Directory Group:"
Get-ADGroup -Filter {name -like "$TGTGroup*"} -Properties Description | Select Name,Description