#Disk Check (chkdsk substitute)
	Write-Host "Checking for drive errors..."
		$OSVersion = (gwmi Win32_OperatingSystem).caption

		If($OSVersion -match "Windows 10")
		{

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
			} else {
						Write-Host "Setting chkdsk on next reboot..."
						echo y|chkdsk c: /f  /x -Verbose:$false | Out-Null
						Write-Host "Chkdsk will run on next reboot!"
						Write-Host ""
						}