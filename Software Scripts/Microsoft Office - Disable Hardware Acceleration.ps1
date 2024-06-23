New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Office\14.0\Common" -Name "Graphics"
New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Office\15.0\Common" -Name "Graphics"
New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Office\16.0\Common" -Name "Graphics"

New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Office\14.0\Common\Graphics" -Name "DisableHardWareAcceleration" -PropertyType DWord -Value 0
New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Office\15.0\Common\Graphics" -Name "DisableHardWareAcceleration" -PropertyType DWord -Value 0
New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Office\16.0\Common\Graphics" -Name "DisableHardWareAcceleration" -PropertyType DWord -Value 0