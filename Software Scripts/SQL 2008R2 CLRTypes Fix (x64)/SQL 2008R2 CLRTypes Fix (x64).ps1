Start-Process "1_SQLSysClrTypes2008R2x64.msi" -ArgumentList "-quiet -norestart"
Start-Process "2_sqlncli2008R2x64.msi" -ArgumentList "-quiet -norestart"
Start-Process "3_SMO2008R2x64.msi" -ArgumentList "-quiet -norestart"