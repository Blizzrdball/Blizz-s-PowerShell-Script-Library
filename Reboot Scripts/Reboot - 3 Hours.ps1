shutdown -f -r -t 10800
Write-Host "This machine will reboot at"(get-date).AddHours(3)