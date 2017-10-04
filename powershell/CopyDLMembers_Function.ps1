#example: CopyDLMembers -SourceDL "oldDL" -TargetDL "newDL"
function CopyDLMembers
{

[CmdletBinding()]
param
(
[Parameter(Mandatory=$True,Position=1)]
[string]$SourceDL,
[Parameter(Mandatory=$True)]
[string]$TargetDL
)

$source = Get-DistributionGroupMember -Identity  $SourceDL
foreach ($i in $source) {Add-DistributionGroupMember -Identity $TargetDL -Member $i.name}
Get-DistributionGroupMember -Identity $targetDL

}

