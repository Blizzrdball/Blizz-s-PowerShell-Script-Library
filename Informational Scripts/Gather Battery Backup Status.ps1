$battery = (gwmi Win32_PnpEntity).caption

If($battery -match "Battery|APC|UPC")
	{
	Write-Host "This server has a battery backup installed."
	Write-Host ""
	} else {
	Write-Host "This server does not have a battery backup installed."
	Write-Host ""
	}