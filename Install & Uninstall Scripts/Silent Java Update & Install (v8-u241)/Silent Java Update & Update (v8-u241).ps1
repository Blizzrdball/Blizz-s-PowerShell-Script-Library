$installed = gwmi Win32_Product -filter "name like 'Java%' AND vendor like 'Oracle%'"

If(-Not $installed) {
	Write-Host "Java is not installed. Skipping ahead...";
} else {
	C:\temp\JavaSetup8u241.exe INSTALL_SILENT=1 AUTO_UPDATE=0 REBOOT=0 SPONSORS=0 REMOVEOUTOFDATEJRES=1
	Write-Host "Java has been successfully updated."
	}