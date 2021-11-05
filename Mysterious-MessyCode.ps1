 $Appname = Read-Host "Search for Installed App"
 $Uninstallers = Get-ChildItem HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*,HKLM:\Software\WoW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*;
 ($Uninstallers|% {$a=$_;
Get-ItemProperty -name UninstallString -Path "$($a.name.replace('HKEY_LOCAL_MACHINE','HKLM:'))" -ErrorAction SilentlyContinue|? {(Get-ItemProperty -name DisplayName -ErrorAction SilentlyContinue -Path $a.name.replace('HKEY_LOCAL_MACHINE','HKLM:')).DisplayName -like "*$Appname*"}}).UninstallString -replace '"',"" |Invoke-Item
