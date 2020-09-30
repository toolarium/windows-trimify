Write-Output "Disabling SMB 1.0 protocol..."
Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force
