# Starting the Imaging
Write-Host -ForegroundColor Green "Starting Clark Imaging ZTI"
Start-Sleep -Seconds 5

# Updating OSD 
Write-Host -ForegroundColor Green "Updating OSD PowerShell Module"
Install-Module OSD -Force
Write-Host -ForegroundColor Green "Importing OSD PowerShell Module"
Import-Module OSD -Force

# Start the Script
Write-Host -ForegroundColor Green "Start Cloud Image..."
Start-OSDCloud -OSLanguage en-us -OSBuild 20H2 -OSEdition Enterprise -ZTI

# Restart from WinPE
Write-Host -ForegroundColor Green "Restarting in 20 seconds!"
Start-Sleep -Seconds 20

wpeutil reboot