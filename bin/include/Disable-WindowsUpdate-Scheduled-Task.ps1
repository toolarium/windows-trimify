Write-Output "Disabling Windows Update scheduled task..."
Get-ScheduledTask -TaskPath '\Microsoft\Windows\WindowsUpdate\' | Disable-ScheduledTask

