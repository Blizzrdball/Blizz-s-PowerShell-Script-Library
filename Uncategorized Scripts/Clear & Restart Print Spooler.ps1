net stop spooler
Remove-Item -Path "C:\Windows\system32\spool\PRINTERS" -Recurse -Force
net start spooler