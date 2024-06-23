Write-Host "Removing LibreOffice..."
gwmi Win32_Product -filter "name like 'Libre%'" | % { $_.Uninstall() } | Out-Null
Write-Host "Uninstalled LibreOffice successfully!"
Write-Host ""