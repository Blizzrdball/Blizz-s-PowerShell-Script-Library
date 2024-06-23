#Define Variables
$path = "C:\*\TeamViewer"

#Silently Run Uninstaller
Write-Host "Running Uninstaller..."
Start-Process "$path\uninstall.exe" -ArgumentList "/S /norestart"

#Remove Registry Keys
Write-Host "Removing Registry Keys..."
reg delete HKLM\SOFTWARE\TeamViewer /f
reg delete HKLM\SOFTWARE\WOW6432Node\TeamViewer /f
reg delete HKU\.DEFAULT\Software\Wow6432Node\TeamViewer /f
reg delete HKU\.DEFAULT\Software\TeamViewer /f
reg delete HKU\S-1-5-18\Software\TeamViewer /f
reg delete HKU\S-1-5-18\Software\Wow6432Node\TeamViewer /f
reg delete HKU\S-1-5-18\Software\TeamViewer /f
Write-Host "Registry keys have been successfully removed!"