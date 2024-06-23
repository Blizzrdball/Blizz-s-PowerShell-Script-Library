Get-EventLog -LogName Application -Source Wininit |
    Where-Object { $_.Message -like '*checking file system*' } |
    Sort-Object TimeGenerated -Descending |
    Select-Object -First 1 -Expand Message