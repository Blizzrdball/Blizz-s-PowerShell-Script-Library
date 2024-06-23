shutdown -f -r -t 21600
Write-Host "This machine will reboot at"(get-date).AddHours(6)