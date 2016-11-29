#this NanoSetup script will be executed on startup by SetupComplete.cmd and is capable
#of customizing a Nano Server post deployment to achieve tasks that could not be completed
#in the image creation process.
#this script will demo how to:
    #set the IP address on an UP adapter
    #Set DNS server
    #Disable IPv6 on all adapters
    #Disable all unused adapters
    #join a domain
    #reboot

#required for some cmdlets to work properly
set LOCALAPPDATA=%USERPROFILE%\AppData\Local

#declare IP variables
$IP = "172.16.96.28"
$MaskBits = 24 # This means subnet mask = 255.255.255.0
$Gateway = "172.16.96.1"
$IPType = "IPv4"

#get an adapter that is up to apply IP information to
#note this is just for example and grabbing the first up adapter may not be appropriate for your environment
$upIndex = Get-NetAdapter | ? { $_.Status -eq "Up" } | Select-Object -First 1 | Select-Object -ExpandProperty ifIndex

#clear any existing IP configuration
Remove-NetIPAddress -InterfaceIndex $upIndex -AddressFamily $IPType -Confirm:$false

#set specifiec IP address
Get-NetAdapter -InterfaceIndex $upIndex | `
New-NetIPAddress -AddressFamily $IPType `
				 -IPAddress $ip `
				 -PrefixLength $MaskBits `
				 -DefaultGateway $Gateway

#set DNS for up adapter
Set-DnsClientServerAddress -InterfaceIndex $upIndex -ServerAddresses ("172.16.96.5", "172.16.96.6")

#disable ipv6 on all adapters
Get-NetAdapterBinding -ComponentID 'ms_tcpip6' | disable-NetAdapterBinding -ComponentID ms_tcpip6 -PassThru

#disable all unused adapters
Get-NetAdapter | ? { $_.status -eq "Disconnected" } | Disable-NetAdapter -Confirm:$false

#join the domain
djoin /requestodj /loadfile c:\temp\odjblob /windowspath c:\windows /localos

#reboot
shutdown /r /t 5