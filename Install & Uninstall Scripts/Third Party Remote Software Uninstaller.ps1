#Uninstall GoToMeeting
    #Defining Variables
    $path = "C:\Users\*\AppData\Local\GoToMeeting\*"

    #Uninstalling GoToMeeting
    Start-Process -FilePath $path\G2MUninstall.exe -ArgumentList "/uninstall /silent"

    #Removing Leftover Directories
    Remove-Item -Path "C:\Users\*\AppData\Local\GoToMeeting" -Force -Recurse
    Remove-Item -Path "C:\Users\*\Appdata\Local\GoTo Opener" -Force -Recurse

#Uninstall GoToMyPC
    Get-Package -Name "GoToMyPC" | Uninstall-Package

#Uninstall Join.Me
    $UID = Get-WmiObject -Class win32_product -Filter "Name like '%join%'"
    $UID.Uninstall()

#Uninstall TeamViewer
    #Define Variables
    $path = "C:\*\TeamViewer"

    #Silently Run Uninstaller
    Write-Host "Running Uninstaller..."
    Start-Process "$path\uninstall.exe" -ArgumentList "/S /norestart"

    #Remove Registry Keys
    Write-Host "Removing Registry Keys..."
    reg delete HKLM\SOFTWARE\TeamViewer /f
    reg delete HKLM\SOFTWARE\WOW6432Node\TeamViewer /f
    reg delete HKU\.DEFAULT\Software\Wow6432Node\TeamViewer /f
    reg delete HKU\.DEFAULT\Software\TeamViewer /f
    reg delete HKU\S-1-5-18\Software\TeamViewer /f
    reg delete HKU\S-1-5-18\Software\Wow6432Node\TeamViewer /f
    reg delete HKU\S-1-5-18\Software\TeamViewer /f
    Write-Host "Registry keys have been successfully removed!"