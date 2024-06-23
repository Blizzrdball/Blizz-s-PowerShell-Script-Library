shutdown -f -r -t 32400
Write-Host "This machine will reboot at"(get-date).AddHours(9)