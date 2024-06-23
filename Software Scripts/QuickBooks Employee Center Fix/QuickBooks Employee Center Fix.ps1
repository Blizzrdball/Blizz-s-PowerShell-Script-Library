Write-Host "Moving fixed template..."
Move-Item -Path "C:\temp\QB_Payroll_Link.XLT" -Destination "C:\Program Files (x86)\Intuit\QuickBooks 2019\Components\Templates" -Force
Write-Host "Template file has been successfully replaced!"