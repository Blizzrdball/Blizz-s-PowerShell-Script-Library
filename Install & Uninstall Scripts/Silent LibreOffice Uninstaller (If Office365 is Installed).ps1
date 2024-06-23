$installed = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | where {$_.displayname -like "*Office 365*"} | Select-Object DisplayName, DisplayVersion 
    If(-Not $installed) {
    Write-Host "LibreOffice is not installed on this computer. Closing script."
    exit
        } else {
    Write-Host "Microsoft Office is installed on this PC! Removing LibreOffice..."
    gwmi Win32_Product -filter "name like 'Libre%'" | % { $_.Uninstall() } | Out-Null
    Remove-Item -Path "C:\Users\*\Desktop\LibreOffice Excel.lnk" -Force
    Remove-Item -Path "C:\Users\*\Desktop\LibreOffice PowerPoint.lnk" -Force
    Remove-Item -Path "C:\Users\*\Desktop\LibreOffice Word.lnk" -Force
    Write-Host "Uninstalled LibreOffice successfully!"
    Write-Host ""
        }