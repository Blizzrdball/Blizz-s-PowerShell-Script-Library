Slmgr /upk
Dism /online /set-edition:ServerStandard /ProductKey:N69G4-B89J2-4G8F4-WWYCC-J464C /AcceptEula
Write-Host "Rebooting server now... Use slmgr /ipk and /ato after reboot to apply the license key!"
shutdown -f -r -t 0