gwmi Win32_Product -filter "name like 'Shockwave%' AND vendor like 'Adobe%'" | % { $_.Uninstall() }