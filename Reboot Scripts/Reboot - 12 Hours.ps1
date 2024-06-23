shutdown -f -r -t 43200
Write-Host "This machine will reboot at"(get-date).AddHours(12)