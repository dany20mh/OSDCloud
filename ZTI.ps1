<#
 # Description : Script to Run Cloud Image
 # Created : 05/10/2021 by Danial
 #>

# Starting the Imaging
Write-Host "=========================================================================" -ForegroundColor Cyan
Write-Host "===================== Cloud Image Deployment Script =====================" -ForegroundColor Cyan
Write-Host "=========================================================================" -ForegroundColor Cyan
Write-Host "========================== Starting Imaging ZTI =========================" -ForegroundColor Cyan
Write-Host "================== Edition - 21H2 == Build - 19044.1766 =================" -ForegroundColor Cyan
Write-Host "=========================================================================" -ForegroundColor Cyan
Start-Sleep -Seconds 5

# Updating Module
Install-Module OSD -Force
Import-Module OSD -Force

# Start-OSDCloud -Product NODRIVER -OSLanguage en-us -OSBuild 21H2 -OSEdition Enterprise -ZTI
Start-OSDCloud -Product NODRIVER -ZTI -ImageFileUrl "https://ccgsoftdist.s3.amazonaws.com/Kaseya/Windows10/install_21H2_2022_06_19044_1766_2.esd"

# Set Drive Lable Name
Set-Volume -DriveLetter C -NewFileSystemLabel "Windows"

# Restart from WinPE
Write-Host -ForegroundColor Cyan "Restarting in 10 seconds!"
Start-Sleep -Seconds 10

wpeutil reboot
