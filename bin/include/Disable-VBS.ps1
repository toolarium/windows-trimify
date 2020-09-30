# Disable Windows Script Host (execution of *.vbs scripts and alike)
Write-Output "Disabling Windows Script Host..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Script Host\Settings" -Name "Enabled" -Type DWord -Value 0
