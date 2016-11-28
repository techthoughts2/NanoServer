@ECHO OFF
set SCLOG=%SystemRoot%\setup\scripts\setupcomplete.log
echo "Executing 'netsh advfirewall firewall add rule name='WinRM 5985' protocol=TCP dir=in localport=5985 profile=any action=allow'" >> %SCLOG%
netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dir=in localport=5985 profile=any action=allow >> %SCLOG%
echo "Executing 'netsh advfirewall firewall set rule group='@FirewallAPI.dll,-29252' new enable=Yes'" >> %SCLOG%
netsh advfirewall firewall set rule group="@FirewallAPI.dll,-29252" new enable=Yes >> %SCLOG%
echo "Executing 'tzutil.exe /s 'Central Standard Time''" >> %SCLOG%
tzutil.exe /s "Central Standard Time" >> %SCLOG%
REM ----------------------------------------------------
REM Lines below are added to have SetupComplete.cmd run a custom .ps1 script that you specify
set LOCALAPPDATA=%USERPROFILE%\AppData\Local
PowerShell "Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -Force"
PowerShell ". C:\Windows\Setup\Scripts\NanoSetup.ps1"