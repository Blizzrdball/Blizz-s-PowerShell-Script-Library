#SFC /Scannow
	Write-Host "Running SFC /scannow...";
	sfc /scannow
	findstr /c:"[SR]" %windir%\Logs\CBS\CBS.log >"C:\sfclogs.txt"
	Write-Host "SFC scan completed! Check sfclogs.txt on C:\ for results."
	Write-Host ""

#Disk Check (chkdsk substitute)
	Write-Host "Checking for drive errors..."
	$errors = Repair-Volume -DriveLetter c -scan
	If($errors -ne "NoErrorsFound") {
			Write-Host "Errors were found; listing errors and flagging disk for reboot..."
			Repair-Volume -DriveLetter c -OfflineScanAndFix
			Write-Warning $errors;
			Write-Host "Disk has been marked for repair on next reboot."
			Write-Host ""
		} else {
			Write-Host "No drive errors were found!"
			Write-Host ""
				}

#DISM Check
	Write-Host "Running DISM check..."
	DISM /Online /Cleanup-Image /CheckHealth /Quiet /NoRestart
	Write-Host "DISM check completed!"
	Write-Host ""
	
#Export Event Viewer logs to C:\
	Write-Host "Exporting Event Viewer logs to C:\temp..."
	del "C:\temp\SystemLogs.evtx" | Out-Null
	del "C:\temp\AppLogs.evtx" | Out-Null
	mkdir "C:\Temp" -Force | Out-Null
	wevtutil epl System "C:\temp\SystemLogs.evtx" | Out-Null
	wevtutil epl Application "C:\temp\AppLogs.evtx" | Out-Null
	Write-Host "Event Viewer logs have been exported! Please check logs manually."
	Write-Host ""
	
#Windows Updates
	Write-Host "Running Windows Updates..."
	## ------------------------------------------------------------------
	## PowerShell Script To Automate Windows Update
	## Script should be executed with "Administrator" Privilege
	## ------------------------------------------------------------------
	
	$ErrorActionPreference = "SilentlyContinue"
	If ($Error) {
		$Error.Clear()
	}
	$Today = Get-Date
	
	$UpdateCollection = New-Object -ComObject Microsoft.Update.UpdateColl
	$Searcher = New-Object -ComObject Microsoft.Update.Searcher
	$Session = New-Object -ComObject Microsoft.Update.Session
	
	Write-Host
	Write-Host "`t Initialising and Checking for Applicable Updates. Please wait ..." -ForeGroundColor "Yellow"
	$Result = $Searcher.Search("IsInstalled=0 and Type='Software' and IsHidden=0")
	
	If ($Result.Updates.Count -EQ 0) {
		Write-Host "`t There are no applicable updates for this computer."
	}
	Else {
		$ReportFile = $Env:ComputerName + "_Report.txt"
		If (Test-Path $ReportFile) {
			Remove-Item $ReportFile
		}
		New-Item $ReportFile -Type File -Force -Value "Windows Update Report For Computer: $Env:ComputerName`r`n" | Out-Null
		Add-Content $ReportFile "Report Created On: $Today`r"
		Add-Content $ReportFile "==============================================================================`r`n"
		Write-Host "`t Preparing List of Applicable Updates For This Computer ..." -ForeGroundColor "Yellow"
		Add-Content $ReportFile "List of Applicable Updates For This Computer`r"
		Add-Content $ReportFile "------------------------------------------------`r"
		For ($Counter = 0; $Counter -LT $Result.Updates.Count; $Counter++) {
			$DisplayCount = $Counter + 1
	    		$Update = $Result.Updates.Item($Counter)
			$UpdateTitle = $Update.Title
			Add-Content $ReportFile "`t $DisplayCount -- $UpdateTitle"
		}
		$Counter = 0
		$DisplayCount = 0
		Add-Content $ReportFile "`r`n"
		Write-Host "`t Initialising Download of Applicable Updates ..." -ForegroundColor "Yellow"
		Add-Content $ReportFile "Initialising Download of Applicable Updates"
		Add-Content $ReportFile "------------------------------------------------`r"
		$Downloader = $Session.CreateUpdateDownloader()
		$UpdatesList = $Result.Updates
		For ($Counter = 0; $Counter -LT $Result.Updates.Count; $Counter++) {
			$UpdateCollection.Add($UpdatesList.Item($Counter)) | Out-Null
			$ShowThis = $UpdatesList.Item($Counter).Title
			$DisplayCount = $Counter + 1
			Add-Content $ReportFile "`t $DisplayCount -- Downloading Update $ShowThis `r"
			$Downloader.Updates = $UpdateCollection
			$Track = $Downloader.Download()
			If (($Track.HResult -EQ 0) -AND ($Track.ResultCode -EQ 2)) {
				Add-Content $ReportFile "`t Download Status: SUCCESS"
			}
			Else {
				Add-Content $ReportFile "`t Download Status: FAILED With Error -- $Error()"
				$Error.Clear()
				Add-content $ReportFile "`r"
			}	
		}
		$Counter = 0
		$DisplayCount = 0
		Write-Host "`t Starting Installation of Downloaded Updates ..." -ForegroundColor "Yellow"
		Add-Content $ReportFile "`r`n"
		Add-Content $ReportFile "Installation of Downloaded Updates"
		Add-Content $ReportFile "------------------------------------------------`r"
		$Installer = New-Object -ComObject Microsoft.Update.Installer
		For ($Counter = 0; $Counter -LT $UpdateCollection.Count; $Counter++) {
			$Track = $Null
			$DisplayCount = $Counter + 1
			$WriteThis = $UpdateCollection.Item($Counter).Title
			Add-Content $ReportFile "`t $DisplayCount -- Installing Update: $WriteThis"
			$Installer.Updates = $UpdateCollection
			Try {
				$Track = $Installer.Install()
				Add-Content $ReportFile "`t Update Installation Status: SUCCESS"
			}
			Catch {
				[System.Exception]
				Add-Content $ReportFile "`t Update Installation Status: FAILED With Error -- $Error()"
				$Error.Clear()
				Add-content $ReportFile "`r"
			}	
		}
	}
	Write-Host "Windows Updates have completed and will be applied on the next reboot."
	Write-Host ""
	
#Trend Micro Check
	Write-Host "Checking for Trend Micro installation..."
	$installed = gwmi Win32_Product -filter "name like 'Trend Micro%' AND vendor like 'Trend Micro%'"

	If(-Not $installed) {
		Write-Host "Trend Micro NOT is installed. Install from the WFBS web portal...";
		Write-Host ""
	} else {
		Write-Host "Trend Micro is installed. Starting services..."
		net start TMCCSF
		net start tmlisten
		net start ntrtscan
		net start TRMBMServer
		Write-Host "Trend Micro is running properly!"
		Write-Host ""
		}
		
#CrashPlan Backup Check
	Write-Host "Checking for CrashPlan installation..."
	$installed = gwmi Win32_Product -filter "name like 'Code42%' AND vendor like 'Code42%'"

	If(-Not $installed) {
		Write-Host "CrashPlan isn't installed on this computer. Install it!";
		Write-Host ""
	} else {
		Write-Host "CrashPlan appears to be installed. Starting service now."
		net start crashplanservice
		Write-Host "Backups appear to be running correctly! Double check in the web portal."
		Write-Host ""
		}
		
#Java Update
	Write-Host "Checking for Java updates..."
	$installed = gwmi Win32_Product -filter "name like 'Java%' AND vendor like 'Oracle%'"

	If(-Not $installed) {
		Write-Host "Java is not installed. Checking ahead...";
	} else {
		Write-Host "Java is installed! Updating now..."
		cd "C:\temp"
		.\JavaSetup8u211.exe INSTALL_SILENT=1 AUTO_UPDATE=0 REBOOT=0 SPONSORS=0 REMOVEOUTOFDATEJRES=1
		}
		
##Java Secondary Check
	$installed = gwmi Win32_Product -filter "name like 'Java 8 Update 211' AND vendor like 'Oracle%'"

	If(-Not $installed) {
		Write-Host "Java is not installed or the previous update failed if ran. Update manually if an update attempted to run.";
		Write-Host ""
	} else {
		Write-Host "Java has been successfully updated!"
		Write-Host ""
		}
		
#Adobe Update
	$installed = gwmi Win32_Product -filter "name like 'Adobe Acrobat Reader%' AND vendor like 'Adobe%'"
	$adobeversion = Get-WmiObject -Class win32_product -filter "Name Like '%Reader%'"

	If(-Not $installed) {
		Write-Host "Adobe Reader is not installed. Skipping ahead...";
		Write-Host ""
	} else {
		Write-Host "$adobeversion is installed. Update manually. DO NOT UPDATE IF UPDATES ARE PUSHED BY GPO!"
		Write-Host ""
		}

#Flash Player Removal
	Write-Host "Checking for Flash Player installation..."
	$installed = ((gp HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*).DisplayName -Match "Flash").Length -gt 0
	
	If(-Not $installed) {
		Write-Host "Flash Player is not installed. Skipping ahead...";
	} else {
		Write-Host "Flash Player is installed! Uninstalling now..."
		cd "C:\temp"
		.\uninstall_flash_player.exe -uninstall
		Write-Host "Flash Player has been successfully uninstalled! Checking again...";
		}
		
##Flash Player Secondary Check
	$installed = ((gp HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*).DisplayName -Match "Flash").Length -gt 0

	If(-Not $installed) {
	Write-Host "Flash Player is not installed. Skipping ahead...";
	Write-Host ""
	} else {
	Write-Host "Flash Player removal appears to have failed. Please remove this manually.";
	Write-Host ""
		}
		
#Shockwave Removal
	Write-Host "Checking for Shockwave installation..."
	$installed = gwmi Win32_Product -filter "name like 'Adobe Shockwave%' AND vendor like 'Adobe%'"

	If(-Not $installed) {
		Write-Host "Shockwave is not installed. Skipping ahead..."
		Write-Host ""
	} else {
		Write-Host "Shockwave is installed. Removing now...";
		wmic product where "Name LIKE '%%shockwave%%'" call uninstall /nointeractive
		Write-Host "Shockwave has been successfully removed!";
		Write-Host ""
		}
		
#Quicktime Removal
	Write-Host "Checking for Quicktime installation..."
	$installed = gwmi Win32_Product -filter "name like 'Quicktime%' AND vendor like 'Apple%'"

	If(-Not $installed) {
		Write-Host "Quicktime is not installed. Skipping ahead..."
		Write-Host ""
	} else {
		Write-Host "Quicktime is installed. Removing now...";
		WMIC product where "Name LIKE 'quicktime%%'" call uninstall /nointeractive
		Write-Host "Quicktime has been successfully removed!";
		Write-Host ""
		}
		
#CCleaner x86 Removal
	Write-Host "Checking for 32-bit CCleaner installation..."
	$installed = ((gp HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*).DisplayName -Match "CCleaner").Length -gt 0

	If(-Not $installed) {
		Write-Host "CCleaner is not installed. Checking for 64-bit..."
	} else {
		Write-Host ""
		Write-Host "CCleaner is installed. Removing now...";
		cd "C:\Program Files\CCleaner\"
		.\uninst.exe /S
		Write-Host "CCleaner has been successfully removed!";
		}
		
#CCleaner x64 Removal
	Write-Host "Checking for 64-bit CCleaner installation..."
	$installed = ((gp HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*).DisplayName -Match "CCleaner").Length -gt 0

	If(-Not $installed) {
		Write-Host "CCleaner is not installed. Skipping ahead..."
		Write-Host ""
	} else {
		Write-Host ""
		Write-Host "CCleaner is installed. Removing now...";
		cd "C:\Program Files\CCleaner\"
		.\uninst.exe /S
		Write-Host "CCleaner has been successfully removed!";
		Write-Host ""
		}
		
#Malwarebytes x86 Removal
	Write-Host "Checking for 32-bit Malwarebytes installation..."
	$installed = ((gp HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*).DisplayName -Match "Malwarebytes").Length -gt 0

	If(-Not $installed) {
		Write-Host "Malwarebytes is not installed. Checking 64-bit..."
	} else {
		Write-Host "Malwarebytes is installed. Removing now...";
		cd "C:\temp"
		.\mb-clean-3.1.0.1035.exe /silent /silentnoreboot
		}

#Malwarebytes x64 Removal
	Write-Host "Checking for 64-bit Malwarebytes installation..."
	$installed = ((gp HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*).DisplayName -Match "Malwarebytes").Length -gt 0

	If(-Not $installed) {
		Write-Host "Malwarebytes is not installed. Skipping ahead..."
	} else {
		Write-Host "Malwarebytes is installed. Removing now...";
		cd "C:\temp"
		.\mb-clean-3.1.0.1035.exe /silent /silentnoreboot
		}
		
##Malwarebytes x86 Secondary Check
	$installed = ((gp HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*).DisplayName -Match "Malwarebytes").Length -gt 0

	If(-Not $installed) {
		Write-Host "Malwarebytes(x86) is not installed. Skipping ahead...";
	} else {
		Write-Host "Malwarebytes(x86) appears to still be installed. Please remove this manually.";
			}

##Malwarebytes x64 Secondary Check
	$installed = ((gp HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*).DisplayName -Match "Malwarebytes").Length -gt 0

	If(-Not $installed) {
		Write-Host "Malwarebytes(x64) is not installed. Skipping ahead...";
		Write-Host ""
	} else {
		Write-Host "Malwarebytes(x64) removal appears to have failed. Please remove this manually.";
		Write-Host ""
			}
		
#Toolbar Removal
	Write-Host "Checking for Internet Explorer Toolbars..."
	$installed = gwmi Win32_Product -filter "name like '%Toolbar%'"

	If(-Not $installed) {
		Write-Host "No toolbars are installed! Skipping ahead..."
	} else {
		Write-Host "Toolbars installed. Removing now...";
		wmic product where "Name LIKE '%%toolbar%%'" call uninstall /nointeractive
		Write-Host "Toolbars have been uninstalled! Checking again..."
		}
		
##Toolbars Secondary Check
		$installed = gwmi Win32_Product -filter "name like '%Toolbar%'"

		If(-Not $installed) {
		Write-Host "No toolbars are installed! Skipping ahead...";
		Write-Host ""
		} else {
		Write-Host "There still appear to be toolbars installed. Please remove them manually.";
		Write-Host ""
			}

#Disk Cleanup
		Write-Host "Running disk cleanup ..."
		function global:Write-Verbose ( [string]$Message ) 
		 
		{ if ( $VerbosePreference -ne 'SilentlyContinue' ) 
		{ Write-Host " $Message" -ForegroundColor 'Yellow' } } 
		 
		$VerbosePreference = "Continue" 
		$DaysToDelete = 1 
		$LogDate = get-date -format "MM-d-yy-HH" 
		$objShell = New-Object -ComObject Shell.Application  
		$objFolder = $objShell.Namespace(0xA) 
		$ErrorActionPreference = "silentlycontinue" 
							 
		Start-Transcript -Path $env:SystemDrive:\Windows\Temp\$LogDate.log -Verbose:$false | Out-Null
		 
		Clear-Host 
		 
		$Before = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq "3" } | Select-Object SystemName, 
		@{ Name = "Drive" ; Expression = { ( $_.DeviceID ) } }, 
		@{ Name = "Size (GB)" ; Expression = {"{0:N1}" -f( $_.Size / 1gb)}}, 
		@{ Name = "FreeSpace (GB)" ; Expression = {"{0:N1}" -f( $_.Freespace / 1gb ) } }, 
		@{ Name = "PercentFree" ; Expression = {"{0:P1}" -f( $_.FreeSpace / $_.Size ) } } | 
		Format-Table -AutoSize | Out-String

		Write-Host "Clearing manufacturer driver folders..."
		Get-ChildItem "$env:SystemDrive\swtools\*" -Recurse -Force -ErrorAction SilentlyContinue |
		remove-Item -Force -Recurse -ErrorAction SilentlyContinue 

		Get-ChildItem "$env:SystemDrive\drivers\*" -Recurse -Force -ErrorAction SilentlyContinue |
		remove-Item -Force -Recurse -ErrorAction SilentlyContinue 

		Get-ChildItem "$env:SystemDrive\swsetup\*" -Recurse -Force -ErrorAction SilentlyContinue |
		remove-Item -Force -Recurse -ErrorAction SilentlyContinue 

		Write-Host "Clearing C:\temp\..."
		Get-ChildItem "$env:SystemDrive:\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue |
		remove-item -force -recurse -ErrorAction SilentlyContinue 

		Write-Host "Clearing C\Windows\temp\..."
		Get-ChildItem "$env:SystemDrive:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue |
		remove-item -force -recurse -ErrorAction SilentlyContinue 

		Write-Host "Clearing temporary user files..."
		Get-ChildItem "$env:SystemDrive:\users\*\AppData\Local\Microsoft\Windows\Temporary Internet Files\*" -Recurse -Force -Verbose -ErrorAction SilentlyContinue |
		remove-item -force -recurse -ErrorAction SilentlyContinue 
		
		Get-ChildItem "$env:SystemDrive:\users\*\AppData\Local\Google\Chrome\User Data\Default\Cache*" -Recurse -Force -Verbose -ErrorAction SilentlyContinue |
		remove-item -force -recurse -ErrorAction SilentlyContinue 
		
		Get-ChildItem "$env:SystemDrive:\users\*\AppData\Local\Mozilla\Firefox\Profiles\*\Cache\*" -Recurse -Force -Verbose -ErrorAction SilentlyContinue |
		remove-item -force -recurse -ErrorAction SilentlyContinue 
		
		Get-ChildItem "$env:SystemDrive:\users\*\AppData\Local\Mozilla\Firefox\Profiles\*\OfflineCache\*" -Recurse -Force -Verbose -ErrorAction SilentlyContinue |
		remove-item -force -recurse -ErrorAction SilentlyContinue 

		Get-ChildItem "$env:SystemDrive:\users\*\AppData\Local\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue |
		remove-item -force -recurse -ErrorAction SilentlyContinue 

		Write-Host "Clearing Recycle Bins..."
		$objFolder.items() | ForEach-Object { Remove-Item $_.path -ErrorAction Ignore -Force -Recurse } 
		Write-Host ""

		## Gathering report data...
		$After =  Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq "3" } | Select-Object SystemName, 
		@{ Name = "Drive" ; Expression = { ( $_.DeviceID ) } }, 
		@{ Name = "Size (GB)" ; Expression = {"{0:N1}" -f( $_.Size / 1gb)}}, 
		@{ Name = "FreeSpace (GB)" ; Expression = {"{0:N1}" -f( $_.Freespace / 1gb ) } }, 
		@{ Name = "PercentFree" ; Expression = {"{0:P1}" -f( $_.FreeSpace / $_.Size ) } } | 
		Format-Table -AutoSize | Out-String 

		Write-Host "Before: $Before" 
		Write-Host "After: $After" 
		Write-Host "Disk cleanup completed!"
		Write-Host ""
		
#OACAdmin Check
	$OSVersion = (gwmi Win32_OperatingSystem).caption

		If($OSVersion -match "Server")
		{
		Write-Host "You are running this script on a server. Skipping OACAdmin checks..."
		} else {
			$userexists = Get-LocalUser -Name "oacadmin"

			If(-Not $userexists) {
				Write-Host "OACAdmin doesn't exist. Creating user...";
				net user oacadmin Bayliner2! /add
				net localgroup administrators /add
				Write-Host "OACAdmin account created! Ensure its password is changed after this script is finished."
				Write-Host ""
			} else {
				Write-Host "OACAdmin exists. Skipping ahead...";
				Write-Host ""
			}
		}

#Server Checkups
	$OSVersion = (gwmi Win32_OperatingSystem).caption

		If($OSVersion -match "Server")
		{
		Write-Host "You're running this check on a server! Running additional checks now..."
		Write-Host ""
		
##Battery Backup Check
			$battery = (gwmi Win32_PnpEntity).caption

			If($battery -match "Battery|APC|UPC")
			{
			Write-Host "This server has a battery backup installed."
			Write-Host ""
			} else {
			Write-Host "This server does not have a battery backup installed."
			Write-Host ""
			}
			
##SimpleHelp GPO Check
			$gpoexist = Get-GPO -All | Where-Object {$_.displayname -like "Simple*"}

			If(-Not $gpoexist) {
			Write-Host "There is no Group Policy for SimpleHelp installations. Create one!"
			Write-Host ""
			} else {
			Write-Host "SimpleHelp Group Policy is in place!"
			Write-Host ""
			}
			
##Trend Micro GPO Check
			$gpoexist = Get-GPO -All | Where-Object {$_.displayname -like "Trend*"}

			If(-Not $gpoexist) {
			Write-Host "There is no Group Policy for Trend Micro installations. Create one!"
			Write-Host ""
			} else {
			Write-Host "Trend Micro Group Policy is in place!"
			Write-Host ""
			}
			
##Adobe GPO Check
			$gpoexist = Get-GPO -All | Where-Object {$_.displayname -like "Adobe*"}

			If(-Not $gpoexist) {
			Write-Host "There is no Group Policy for Adobe Reader."
			Write-Host ""
			} else {
			Write-Host "Adobe Reader Group Policy is in place! Do not try to update from other means!"
			Write-Host ""
			}
			
##Flash Player GPO Check
			$gpoexist = Get-GPO -All | Where-Object {$_.displayname -like "Flash*"}

			If(-Not $gpoexist) {
			Write-Host "There is no Group Policy for Flash Player. This is situational."
			Write-Host ""
			} else {
			Write-Host "Flash Player Group Policy is in place!"
			Write-Host ""
			}
			
##SQL Version Check
			Write-Host "Checking for Microsoft SQL server installation..."
			$installed = gwmi Win32_Product -filter "name like 'Microsoft SQL Server' AND vendor like 'Microsoft%'"
			If(-Not $installed) {
				Write-Host "SQL is not running on this server. Skipping ahead...";
				Write-Host ""
			} else {
				Write-Host "SQL is installed! Checking version..."
				Invoke-Sqlcmd -Query "SELECT @@VERSION;" -QueryTimeout 3
				Write-Host ""
			}

##Exchange CU Check
			Write-Host "Checking for Microsoft Exchange server installation..."
			$installed = gwmi Win32_Product -filter "name like 'Microsoft Exchange Server' AND vendor like 'Microsoft%'"
			If(-Not $installed) {
				Write-Host "Exchange is not running on this server. Skipping ahead...";
				Write-Host ""
				Write-Host "Checkups are complete! Check back on logs from this script and make fixes accordingly.";
			} else {
				Write-Host "Exchange is installed! Checking CU version. Be patient! This can take awhile..."
				Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010 -Verbose:$false | Out-Null
				Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn -Verbose:$false | Out-Null
				Get-ExchangeServer | Format-List AdminDisplayVersion -Verbose:$false
				Write-Host ""
				Write-Host "Checkups are complete! Check back on logs from this script and make fixes accordingly.";
			}
		}