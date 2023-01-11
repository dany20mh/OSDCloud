<#
 # Description : Script to Run Cloud Image
 # Created : 05/10/2021 by Danial
 #>

# Starting the Imaging
Write-Host "=========================================================================" -ForegroundColor Cyan
Write-Host "===================== Cloud Image Deployment Script =====================" -ForegroundColor Cyan
Write-Host "=========================================================================" -ForegroundColor Cyan
Write-Host "========================== Starting Imaging ZTI =========================" -ForegroundColor Cyan
Write-Host "================== Edition - 22H2 == Build - 22621.963 ==================" -ForegroundColor Cyan
Write-Host "=========================================================================" -ForegroundColor Cyan
Start-Sleep -Seconds 5

# Updating Module
Install-Module OSD -Force
Import-Module OSD -Force

# Select Deployment Method
$actionChoice = [System.Management.Automation.Host.ChoiceDescription[]](@(
    (New-Object System.Management.Automation.Host.ChoiceDescription("&Hybrid", "Hybrid Joined Machine"))
    (New-Object System.Management.Automation.Host.ChoiceDescription("&AAD", "AzureAD Joined Machine")),
    (New-Object System.Management.Automation.Host.ChoiceDescription("&Travel", "AzureAD Joined Machine for Travel"))
    (New-Object System.Management.Automation.Host.ChoiceDescription("&Donation PC*", "Regular image for Donation PC - COMING SOON!!!"))
))

$action = $Host.Ui.PromptForChoice("Deployment Method", "Select a Deployment method to perform imaging", $actionChoice, 0)

If ( $action -eq 0 ) {
    Write-Host "=========================================================================" -ForegroundColor Cyan
    Write-Host "========================== Hybrid Deployment ============================" -ForegroundColor Cyan
    Write-Host "=========================================================================" -ForegroundColor Cyan
} 

If ( $action -eq 1 ) {
    Write-Host "=========================================================================" -ForegroundColor Cyan
    Write-Host "========================= AzureAD Deployment ============================" -ForegroundColor Cyan
    Write-Host "=========================================================================" -ForegroundColor Cyan
    Invoke-WebRequest -Uri "https://clarkconstruction.box.com/shared/static/fli8o80p0wccwj688zhmixgjzk15wzom.json" -OutFile X:\OSDCloud\Autopilot\Profiles\AutopilotProfile.json
} 

If ( $action -eq 2 ) {
    Write-Host "=========================================================================" -ForegroundColor Cyan
    Write-Host "========================= Travel PC Deployment ==========================" -ForegroundColor Cyan
    Write-Host "=========================================================================" -ForegroundColor Cyan
    Invoke-WebRequest -Uri "https://clarkconstruction.box.com/shared/static/uzfltkr8mllyd4t7xld64fqendtbgt6j.json" -OutFile X:\OSDCloud\Autopilot\Profiles\AutopilotProfile.json
} 

# Start-OSDCloud -Product NODRIVER -OSLanguage en-us -OSBuild 21H2 -OSEdition Enterprise -ZTI
Start-OSDCloud -Product NODRIVER -ZTI -ImageFileUrl "https://ccgsoftdist.s3.amazonaws.com/Kaseya/Windows10/install_22H2_2023_01_22621_1105.esd"

# Set Drive Lable Name
Set-Volume -DriveLetter C -NewFileSystemLabel "Windows"

# Restart from WinPE
Write-Host -ForegroundColor Cyan "Restarting in 10 seconds!"
Start-Sleep -Seconds 10

wpeutil reboot
