# Disable thumbnails, show only file extension icons
Write-Output "Disabling thumbnails..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "IconsOnly" -Type DWord -Value 1
