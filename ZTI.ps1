# Starting the Imaging
Write-Host -ForegroundColor Green "Starting Clark Imaging ZTI"
Start-Sleep -Seconds 5

# Updating Module
# Install-Module OSD -Force
# Import-Module OSD -Force

# Start the Script
Write-Host -ForegroundColor Green "Start Cloud Image..."
#Start-OSDCloud -Product NODRIVER -OSLanguage en-us -OSBuild 20H2 -OSEdition Enterprise -ZTI
Start-OSDCloud -Product NODRIVER -ZTI -ImageFileUrl "https://ccgsoftdist.s3.amazonaws.com/Kaseya/Windows10/install_20H2_2021_04_19042_928.esd"

# Restart from WinPE
Write-Host -ForegroundColor Green "Restarting in 10 seconds!"
Start-Sleep -Seconds 10

wpeutil reboot