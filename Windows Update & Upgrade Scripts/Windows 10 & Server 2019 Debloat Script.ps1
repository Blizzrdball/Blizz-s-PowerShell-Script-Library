#Stops and disabled data collection diagnostic services
Write-Host "Stopping and disabling DiagTrack, Collector, and Push services..."
Set-Service DiagTrack -StartupType Disabled
Set-Service diagnosticshub.standardcollector.service -StartupType Disabled
Set-Service dmwappushservice -StartupType Disabled
Stop-Service DiagTrack -Force -Confirm:$false
Stop-Service diagnosticshub.standardcollector.service -Force -Confirm:$false
Stop-Service dmwappushservice -Force -Confirm:$false
Write-Host "Services have successfully been stopped and disabled!"
Write-Host ""

#Removes Microsoft Customer Experience, Office Telemetry, and Data Collector scheduled tasks
Write-Host "Removing all Telemetry and Microsoft Customer Experience scheduled tasks..."
Unregister-ScheduledTask -TaskName "SmartScreenSpecific" -Confirm:$false
Unregister-ScheduledTask -TaskName "Microsoft Compatibility Appraiser" -Confirm:$false
Unregister-ScheduledTask -TaskName "ProgramDataUpdater" -Confirm:$false
Unregister-ScheduledTask -TaskName "StartupAppTask" -Confirm:$false
Unregister-ScheduledTask -TaskName "Consolidator" -Confirm:$false
Unregister-ScheduledTask -TaskName "KernelCeipTask" -Confirm:$false
Unregister-ScheduledTask -TaskName "UsbCeip" -Confirm:$false
Unregister-ScheduledTask -TaskName "Uploader" -Confirm:$false
Unregister-ScheduledTask -TaskName "FamilySafetyUpload" -Confirm:$false
Unregister-ScheduledTask -TaskName "OfficeTelemetryAgentLogOn" -Confirm:$false
Unregister-ScheduledTask -TaskName "OfficeTelemetryAgentFallBack" -Confirm:$false
Unregister-ScheduledTask -TaskName "Proxy" -Confirm:$false
Unregister-ScheduledTask -TaskName "CreateObjectTask" -Confirm:$false
Unregister-ScheduledTask -TaskName "Microsoft-Windows-DiskDiagnosticDataCollector" -Confirm:$false
Unregister-ScheduledTask -TaskName "QueueReporting" -Confirm:$false
#Unregister-ScheduledTask -TaskName "Automatic App Update" -Confirm:$false
Write-Host "Scheduled tasks have been successfully removed!"
Write-Host ""

#Removes all Nvidia Telemetry scheduled tasks
Write-Host "Removing Nvidia Telemetry scheduled tasks..."
Unregister-ScheduledTask -TaskName "*NvTm*" -Confirm:$false
Write-Host "Nvidia Telemetry tasks have been removed!"
Write-Host ""

#Adds and edits all telemetry and advertising related registry keys to be disabled
Write-Host "Adding registry keys to disable all telemetry and advertising protocols..."
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v PreventDeviceMetadataFromNetwork /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\SQMLogger" /v "Start" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v EnableWebContentEvaluation /t REG_DWORD /d 0 /f
reg add "HKCU\Control Panel\International\User Profile" /v HttpAcceptLanguageOptOut /t REG_DWORD /d 1 /f
reg add "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" /v value /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /v value /t REG_DWORD /d 0 /f
New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name Enabled -Value 0 -Force
New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost\EnableWebContentEvaluation" -Name Enabled -Value 0 -Force
New-ItemProperty -Path "HKCU:\Control Panel\International\User Profile" -Name HttpAcceptLanguageOptOut -Value 1 -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Name PeriodInNanoSeconds -Value 0 -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Name NumberOfSIUFInPeriod -Value 0 -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" -Name AutoConnectAllowedOEM -Value 0 -Force
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Spynet" -Name SpyNetReporting -Value 0 -Force
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Spynet" -Name SubmitSamplesConsent -Value 2 -Force
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\MRT" -Name DontReportInfectionInformation -Value 1 -Force
Write-Host "Registry keys have been set!"
Write-Host ""

#Disabled Windows Delivery Optimizaion (Disables P2P Windows Updates)
#Write-Host "Disabling P2P services for Windows Update..."
#reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DODownloadMode /t REG_DWORD /d 0 /f
#Write-Host "P2P has been disabled!"
#Write-Host ""

#Add registry key to break Nvidia Telemetry Services
Write-Host "Adding registry keys to break Nvidia Telemetry..."
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\NvTelemetryContainer.exe" /v Debugger /t REG_SZ /d "%windir%\System32\taskkill.exe" /f
reg add "HKCU\Software\NVIDIA Corporation\NVControlPanel2\Client" /v "OptInOrOutPreference" /t /REG_DWORD /d 0 /f
Write-Host "Nvidia Telemetry has been broken!"
Write-Host ""

#Adds and disables all registry keys related to automatically installing Windows Apps
#Write-Host "Disabling auto-installed Windows Apps..."
#Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "FeatureManagementEnabled" 0
#Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "OemPreInstalledAppsEnabled" 0
#Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "PreInstalledAppsEnabled" 0
#Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SilentInstalledAppsEnabled" 0
#Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "ContentDeliveryAllowed" 0
#Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "PreInstalledAppsEverEnabled" 0
#Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContentEnabled" 0
#Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338388Enabled" 0
#Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338389Enabled" 0
#Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-314559Enabled" 0
#Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338387Enabled" 0
#Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338393Enabled" 0
#Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SystemPaneSuggestionsEnabled" 0
#Write-Host "Registry keys have been properly added!"
#Write-Host ""

#Adds registry keys to disable location tracking
#Write-Host "Adding registry keys to disable location tracking..."
#New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Force
#Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Type String -Value "Allow"
#Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 1
#Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Type DWord -Value 1
#Write-Host "Location tracking has been disabled!"
#Write-Host ""

#Creates a dummy file to stop Autologger from running
Write-Host "Creating AutoLogger dummy file..."
New-Item "%ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl" -ItemType File -Force
Write-Host "Dummy file created!"
Write-Host ""

#Remove Pre-installed Windows Apps
Write-Host "Removing Pre-installed Windows Apps..."
#Get-AppxPackage *3DBuilder* | Remove-AppxPackage
#Get-AppxPackage *3DViewer* | Remove-AppxPackage
Get-AppxPackage *bing* | Remove-AppxPackage
Get-AppxPackage *CommsPhone* | Remove-AppxPackage
Get-AppxPackage *ConnectivityStore* | Remove-AppxPackage
#Get-AppxPackage *Microsoft.Messaging* | Remove-AppxPackage
Get-AppxPackage *MicrosoftOfficeHub* | Remove-AppxPackage
Get-AppxPackage *MixedReality* | Remove-AppxPackage
#Get-AppxPackage *people* | Remove-AppxPackage
#Get-AppxPackage *Print3D* | Remove-AppxPackage
Get-AppxPackage *SkypeApp* | Remove-AppxPackage
Get-AppxPackage *solit* | Remove-AppxPackage
Get-AppxPackage *Sway* | Remove-AppxPackage
#Get-AppxPackage *Wallet* | Remove-AppxPackage
#Get-AppxPackage *WindowsCamera* | Remove-AppxPackage
Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage
Get-AppxPackage *WindowsPhone* | Remove-AppxPackage
Get-AppxPackage *WindowsReadingList* | Remove-AppxPackage
Get-AppxPackage *YourPhone* | Remove-AppxPackage
Write-Host "Windows Apps have been removed!"
Write-Host ""

#Remove Third Party Apps
Write-Host "Removing third party Windows Apps..."
Get-AppxPackage *Collage* | Remove-AppxPackage
Get-AppxPackage *CyberLink* | Remove-AppxPackage
Get-AppxPackage *Disney* | Remove-AppxPackage
Get-AppxPackage *Drawboard PDF* | Remove-AppxPackage
#Get-AppxPackage *Duolingo* | Remove-AppxPackage
Get-AppxPackage *Eclipse* | Remove-AppxPackage
Get-AppxPackage *Facebook* | Remove-AppxPackage
Get-AppxPackage *FarmVille* | Remove-AppxPackage
#Get-AppxPackage *Fitbit* | Remove-AppxPackage
Get-AppxPackage *flaregamesGmbH* | Remove-AppxPackage
Get-AppxPackage *GAMELOFTSA* | Remove-AppxPackage
Get-AppxPackage *Getstarted* | Remove-AppxPackage
Get-AppxPackage *Keeper* | Remove-AppxPackage
Get-AppxPackage *king.com* | Remove-AppxPackage
#Get-AppxPackage *LinkedIn* | Remove-AppxPackage
#Get-AppxPackage *Netflix* | Remove-AppxPackage
Get-AppxPackage *NORDCURRENT* | Remove-AppxPackage
Get-AppxPackage *NYTCrossword* | Remove-AppxPackage
Get-AppxPackage *OneConnect* | Remove-AppxPackage
#Get-AppxPackage *OneNote* | Remove-AppxPackage
#Get-AppxPackage *Pandora* | Remove-AppxPackage
#Get-AppxPackage *PhotoStudio* | Remove-AppxPackage
Get-AppxPackage *Playtika* | Remove-AppxPackage
Get-AppxPackage *Plex* | Remove-AppxPackage
Get-AppxPackage *Polarr* | Remove-AppxPackage
Get-AppxPackage *Radio* | Remove-AppxPackage
Get-AppxPackage *Shazam* | Remove-AppxPackage
#Get-AppxPackage *Spotify* | Remove-AppxPackage
#Get-AppxPackage *Twitter* | Remove-AppxPackage
Get-AppxPackage *WinZip* | Remove-AppxPackage
Get-AppxPackage *Wunderlist* | Remove-AppxPackage
Get-AppxPackage *XINGAG* | Remove-AppxPackage
Write-Host "All third party apps have been removed!"
Write-Host ""