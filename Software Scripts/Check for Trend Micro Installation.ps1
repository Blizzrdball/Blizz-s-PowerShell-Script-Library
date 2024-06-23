$installed = gwmi Win32_Product -filter "name like 'Trend Micro%' AND vendor like 'Trend Micro%'"

If(-Not $installed) {
	Write-Host "Trend Micro NOT is installed. Install from the WFBS web portal...";
} else {
	Write-Host "'$installed' is installed."
	}