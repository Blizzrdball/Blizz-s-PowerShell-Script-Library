$gpoexist = Get-GPO -All | Where-Object {$_.displayname -like "Trend*"}

If(-Not $gpoexist) {
        Write-Host "There is no Group Policy for Trend Micro installations. Create one!"
        Write-Host ""
    } else {
		Write-Host "Trend Micro Group Policy is in place!"
		Write-Host ""
		    }