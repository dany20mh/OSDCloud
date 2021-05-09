# Starting the Imaging
Write-Host -ForegroundColor Green "Starting Clark Imaging ZTI"
Start-Sleep -Seconds 5

# Updating Module
Install-Module OSD -Force
Import-Module OSD -Force

# Start the Script
Write-Host -ForegroundColor Green "Start Cloud Image..."
Start-OSDCloud -Product NODRIVER -OSLanguage en-us -OSBuild 20H2 -OSEdition Enterprise -ZTI

# Restart from WinPE
Write-Host -ForegroundColor Green "Restarting in 20 seconds!"
Start-Sleep -Seconds 20

wpeutil reboot