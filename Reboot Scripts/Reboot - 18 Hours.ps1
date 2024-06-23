shutdown -f -r -t 64800
Write-Host "This machine will reboot at"(get-date).AddHours(18)