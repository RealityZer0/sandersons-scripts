Import-Module "C:\Program Files (x86)\ConfigMgr\bin\ConfigurationManager.psd1"
CD SNA:
$TDate = Get-Date
$CurrentDate = $TDate.ToString('MM-dd-yyyy_hh-mm-ss')
$UserName = "$env:USERNAME"
$ReportsLoc = "C:\Users\$UserName\Reports"
$DeviceNames = Import-Csv "$ReportsLoc\TGTDevices.csv'
Foreach ($DeviceName in $DeviceNames)
{
$Devices = Get-CMUserDeviceaffinity -DeviceName $DeviceName.ComputerName
Foreach ($Device in $Devices)
{
$UserName = ($Device.UniqueUserName).ToLower()
$User = $USerName.Replace("domain\", "")
$newline = "{0},{1}" -f $DeviceName,$User
$DeviceName.ComputerName
$UserName
If(!($User -eq $null))
{
add-content "$ReportsLoc\TGTDevices-out-$CurrentDate.csv" $newline
}
}
}