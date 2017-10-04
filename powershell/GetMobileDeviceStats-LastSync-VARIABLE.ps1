$Mbx = Get-Mailbox –RecipientTypeDetails UserMailbox –ResultSize Unlimited

$Mobile = $Mbx | %{Get-MobileDeviceStatistics –Mailbox $_.Identity}