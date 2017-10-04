##connect to exchange##
$TGTAdmin = "YourAdminAccountHere"
$Credentials = Get-Credential -credential "domain\$TGTAdmin"
$ExSession = New-PSSession –ConfigurationName Microsoft.Exchange –ConnectionUri 'http://exch-cas-srvr/powershell/?SerializationLevel=Full' -Credential $Credentials –Authentication Kerberos
Import-PSSession $ExSession
import-module activedirectory

$a = (Get-Host).UI.RawUI
$a.WindowTitle = "(PRODUCTION) EXCHANGE"
#$a.BackgroundColor = "DarkRed"
#$a.ForegroundColor = "Darkyellow"
$FormatEnumerationLimit =-1
