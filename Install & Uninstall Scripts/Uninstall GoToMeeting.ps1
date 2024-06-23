#Defining Variables
$path = "C:\Users\*\AppData\Local\GoToMeeting\*"

#Uninstalling GoToMeeting
Start-Process -FilePath $path\G2MUninstall.exe -ArgumentList "/uninstall /silent"

#Removing Leftover Directories
Remove-Item -Path "C:\Users\*\AppData\Local\GoToMeeting" -Force -Recurse
Remove-Item -Path "C:\Users\*\Appdata\Local\GoTo Opener" -Force -Recurse