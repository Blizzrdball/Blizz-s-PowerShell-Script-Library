Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\Sinkhole-DNS.ps1 -InputFile domains.txt -IncludeWildCard -RemoveLeadingWWW