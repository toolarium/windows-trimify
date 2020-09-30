#########################################################################
#
# trimmify.ps1
#
# Copyright by toolarium, all rights reserved.
# MIT License: https://mit-license.org
#
#########################################################################


#########################################################################
# Please define the scripts to run
#########################################################################
$WindowsSettings = @(
	#########################################################################
	# Connectivity
	#########################################################################
	#"Disable-WiFi",
	"Disable-Telemetry",
	"Disable-Location-Tracking",
	"Disable-Maps-updates",
	"Disable-Advertising-ID",
	"Disable-Feedback",
	"Disable-Shared-Experiences",
	"Disable-Remote-Assistence",
	#"Disable-Remote-Desktop",
	"Disable-WAP-Service",
	#"Disable-Error-Reporing",


	#########################################################################
	# Security
	#########################################################################
	"Disable-SMB_v1",
	"Disable-VBS",
	##"Restrict-Windows-Update-P2P-Local-Network",
	#"Disable-WindowsUpdate-Scheduled-Task",
	"Enable-Strong-Cryptography",
	##"Disable-Implicit-Administrative-Shares",
	"Disable-Autoplay",
	"Disable-Autorun",
	
	
	#########################################################################
	# 
	#########################################################################
	##"Disable-Windows-Update-Restart",
	#"Disable-Windows-Search-Indexing-Service",
	"Disable-Bing-Search",
	"Disable-Application-suggestions",
	"Disable-Activity-History",
	##"Disable-Background-Application-Access",
	##"Disable-Tailored-Experiences",
	"Disable-Cortana",
	"Disable-Diagnostic-Tracing-Service",
	#"Set-Bios-time-to-UTC",
	#"Disable-Display-Sleep-Mode-Timeouts",

	
	#########################################################################
	# UI Tweaks
	#########################################################################
	#"Set-Darkmode",
	#"Disable-Action-Center",
	"Disable-Sticky-Keys-Prompt",
	##"Show-TaskManager-Details",
	"Show-File-Operations-Detail",
	"Hide-Search-Icon-Taskbar",
	#"Hide-Task-View-Button",
	"Show-Small-Icons-in-Taskbar",
	"Hide-People-Icon-Taskbar",
	"Show-All-Tray-Icons",
	"Disable-Search-App-in-Store",
	"Set-Control-Panel-View-to-Small-Icons",
	"Adjusts-Visual-Effects",
	"Show-Known-File-Extensions",
	"Show-Hidden-Files",
	"Hide-Recently-Shortcuts",
	"Change-Default-Explorer-View",
	#"Show-This-PC-Desktop",
	#"Hide-User-Folder-From-Desktop",
	"Hide-Music-Icons",
	"Hide-Picture-Icons",
	"Hide-Video-Icons",
	"Disable-3D-Objects",
	"Disable-Thumbnails",
	"Disable-Thumbnail-files",
	#"Disable-OneDrvie",
	#"Uninstall-OneDrive",
	#"Uninstall-Windows-Store",
	"Disable-XBox",
	"Disable-Adobe-Flash"
	#"Uninstall-Windows-Media-Player",
	#"Uninstall-Internet-Explorer",
	#"Uninstall-Work-Folders-Client",
	#"Install-Linux-Subsystem",


	#########################################################################
	# Unpinning
	#########################################################################
	#"Unpin-StartMenu",
	#"Unpin-Taskbar"
	#"Uninstall-Default-Software-Packages",
)


#########################################################################
# Constanzs
#########################################################################
$lineHeader=".:"
$line="----------------------------------------------------------------------------------------"
$baseUrl="https://raw.githubusercontent.com/toolarium/windows-trimify/master/bin/include"



#########################################################################
# Test-Administrator
#########################################################################
function Test-Administrator {  
    [OutputType([bool])]
    param()
    process {
        [Security.Principal.WindowsPrincipal]$user = [Security.Principal.WindowsIdentity]::GetCurrent();
        return $user.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator);
    }
}


#########################################################################
# New-TemporaryDirectory
#########################################################################
function New-TemporaryDirectory {
  $tempDirectoryBase = [System.IO.Path]::GetTempPath();
  $newTempDirPath = [String]::Empty;
  
  do {
    [string] $name = [System.Guid]::NewGuid();
    $newTempDirPath = (Join-Path $tempDirectoryBase $name);
  } while (Test-Path $newTempDirPath);

  New-Item -ItemType Directory -Path $newTempDirPath;
  #return $newTempDirPath;
}


#########################################################################
# Main
#########################################################################
Write-Host "$line"
Write-Host "$lineHeader Windows trimify"
Write-Host "$line"
if(-not (Test-Administrator)) {
    Write-Error "This script must be executed as Administrator.";
    exit 1;
}

Write-Host "$lineHeader Defined packages: $WindowsSettings"
Read-Host -Prompt "Press any key to continue (Ctrl-C to abort)"

$tempFolderName = New-TemporaryDirectory
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"; 

Write-Host "$lineHeader Download depdendencies..."
foreach ($windowsSetting in $WindowsSettings) {	
	$filename = "$windowsSetting.ps1"
	$url = "$baseUrl/$filename"
	
	#Write-Host "$lineHeader Download $url"
	Invoke-WebRequest -Uri "$url" -OutFile "$tempFolderName\$filename" 

    if (Test-Path "$tempFolderName\$filename") {
		# ok
    } else {
		Write-Host "$lineHeader Could not read $url"
    }
}

#Write-Host "$lineHeader Execute depdendencies..."
foreach ($windowsSetting in $WindowsSettings) {	
	$filename = "$windowsSetting.ps1"

    if (Test-Path "$tempFolderName\$filename") {
		Write-Host "$lineHeader Execute $windowsSetting..."
    }
}

Write-Host "$line"
Write-Host "Cleanup temp path $tempFolderName"
Get-ChildItem -Path "$tempFolderName" -Recurse | Remove-Item -force -recurse
Remove-Item -LiteralPath "$tempFolderName" -Force -Recurse
Write-Host "$line"

#########################################################################
# EOF
#########################################################################