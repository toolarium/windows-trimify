# Uninstall Work Folders Client - Not applicable to Server
Write-Output "Uninstalling Work Folders Client..."
Disable-WindowsOptionalFeature -Online -FeatureName "WorkFolders-Client" -NoRestart -WarningAction SilentlyContinue | Out-Null
