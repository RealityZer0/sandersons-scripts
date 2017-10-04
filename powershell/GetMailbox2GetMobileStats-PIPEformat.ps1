##connect to exchange##
$TDate = Get-Date
$CurrentDate = $TDate.ToString('MM-dd-yyyy_hh-mm-ss')
$UserName = "$env:USERNAME"
$ReportsLoc = "C:\Users\$UserName\Reports"
$Credentials = Get-Credential -credential "domain\USERNAMEHERE"
$ExSession = New-PSSession –ConfigurationName Microsoft.Exchange –ConnectionUri ‘http://exch-srvr.domain.com/powershell/?SerializationLevel=Full’ -Credential $Credentials –Authentication Kerberos
Import-PSSession $ExSession
import-module activedirectory

$a = (Get-Host).UI.RawUI
$a.WindowTitle = "(PRODUCTION) YOURDOMAIN EXCHANGE"
#$a.BackgroundColor = "DarkRed"
#$a.ForegroundColor = "Darkyellow"
$FormatEnumerationLimit =-1

Get-CASMailbox -ResultSize unlimited –Filter {HasActiveSyncDevicePartnership -eq $true} | ForEach {Get-MobileDeviceStatistics -Mailbox $_.Identity | Where-Object {$_.LastSuccessSync -le ((Get-Date).AddDays(“-30”))}}| export-csv $ReportsLoc\EASDevicesLastSync-$CurrentDate.csv