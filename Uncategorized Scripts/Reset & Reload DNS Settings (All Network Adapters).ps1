Set-DnsClientServerAddress -InterfaceAlias "*" -ResetServerAddresses
ipconfig /release
ipconfig /renew