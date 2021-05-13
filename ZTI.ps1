<#
 # Description : Script to Run Cloud Image
 # Created : 05/10/2021 by Danial
 #>

Write-Host "================================================================" -ForegroundColor Blue
Write-Host "================ Clark Construction Group, LLC =================" -ForegroundColor Blue
Write-Host "================ Cloud Image Deployment Script =================" -ForegroundColor Blue
Write-Host "================================================================" -ForegroundColor Blue

# Starting the Imaging
Write-Host ""
Write-Host "================================================================" -ForegroundColor Blue
Write-Host "===================== Starting Imaging ZTI =====================" -ForegroundColor Blue
Write-Host "============= Edition - 20H2 == Build - 19402.985 ==============" -ForegroundColor Blue
Write-Host "================================================================" -ForegroundColor Blue
Start-Sleep -Seconds 5

# Updating Module
# Install-Module OSD -Force
# Import-Module OSD -Force

# Start-OSDCloud -Product NODRIVER -OSLanguage en-us -OSBuild 20H2 -OSEdition Enterprise -ZTI
Start-OSDCloud -Product NODRIVER -ZTI -ImageFileUrl "https://ccgsoftdist.s3.amazonaws.com/Kaseya/Windows10/install_20H2_2021_05_19042_985.esd"

# Restart from WinPE
Write-Host -ForegroundColor Green "Restarting in 10 seconds!"
Start-Sleep -Seconds 10

wpeutil reboot