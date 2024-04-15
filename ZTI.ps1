<#
 # Description : Script to Run Cloud Image
 # Created : 05/10/2021 by Danial
 #>

# Making sure the module is up to date
Clear-Host
$version = (Get-Module -ListAvailable OSD) | Sort-Object Version -Descending  | Select-Object Version -First 1
$stringver = $version | Select-Object @{n = 'ModuleVersion'; e = { $_.Version -as [string] } }
$a = $stringver | Select-Object Moduleversion -ExpandProperty Moduleversion
$psgalleryversion = Find-Module -Name OSD | Sort-Object Version -Descending | Select-Object Version -First 1
$onlinever = $psgalleryversion | Select-Object @{n = 'OnlineVersion'; e = { $_.Version -as [string] } }
$b = $onlinever | Select-Object OnlineVersion -ExpandProperty OnlineVersion
 
if ([version]"$a" -ge [version]"$b") {}
else {
    Install-Module -Name OSD -Force
    Import-Module OSD                
}

# Final check for Module 
$version = (Get-Module -ListAvailable OSD) | Sort-Object Version -Descending  | Select-Object Version -First 1
$stringver = $version | Select-Object @{n = 'ModuleVersion'; e = { $_.Version -as [string] } }
$a = $stringver | Select-Object Moduleversion -ExpandProperty Moduleversion

if ([version]"$a" -ge [version]'24.3.10.1') {

    Clear-Host
    # Starting the Imaging
    Write-Host "=========================================================================" -ForegroundColor Cyan
    Write-Host "===================== Cloud Image Deployment Script =====================" -ForegroundColor Cyan
    Write-Host "=========================================================================" -ForegroundColor Cyan
    Write-Host "========================== Starting Imaging ZTI =========================" -ForegroundColor Cyan
    Write-Host "================= Edition - 23H2 == Build - 22631.3447 ==================" -ForegroundColor Cyan
    Write-Host "=========================================================================" -ForegroundColor Cyan
    Start-Sleep -Seconds 5

    # Select Deployment Method
    $actionChoice = [System.Management.Automation.Host.ChoiceDescription[]](@(
    (New-Object System.Management.Automation.Host.ChoiceDescription("&Hybrid", "Hybrid Joined Machine"))
    (New-Object System.Management.Automation.Host.ChoiceDescription("&AAD", "AzureAD Joined Machine")),
    (New-Object System.Management.Automation.Host.ChoiceDescription("&Travel", "AzureAD Joined Machine for Travel"))
    (New-Object System.Management.Automation.Host.ChoiceDescription("&Donation PC", "Regular Image for Donation PC"))
        ))

    $action = $Host.Ui.PromptForChoice("Deployment Method", "Select a Deployment method to perform imaging", $actionChoice, 0)

    $Global:StartOSDCloudGUI = [ordered]@{
        ZTI                  = $true
        HPIADrivers          = $true
        HPIAFirmware         = $true
        HPTPMUpdate          = $true
        HPBIOSUpdate         = $true
        OSName               = 'Windows 11 23H2 x64'
        OSEdition            = 'Pro'
        OSActivation         = 'Retail'
        OSLanguage           = 'en-us'
        updateDiskDrivers    = $true
        updateFirmware       = $true
        updateNetworkDrivers = $true
        updateSCSIDrivers    = $true
        SyncMSUpCatDriverUSB = $true
        WindowsUpdate        = $true
        WindowsUpdateDrivers = $true
    }

    If ( $action -eq 0 ) {
        Write-Host "=========================================================================" -ForegroundColor Cyan
        Write-Host "========================== Hybrid Deployment ============================" -ForegroundColor Cyan
        Write-Host "=========================================================================" -ForegroundColor Cyan
    } 

    If ( $action -eq 1 ) {
        Write-Host "=========================================================================" -ForegroundColor Cyan
        Write-Host "========================= AzureAD Deployment ============================" -ForegroundColor Cyan
        Write-Host "=========================================================================" -ForegroundColor Cyan
        Invoke-WebRequest -Uri "https://clarkconstruction.box.com/shared/static/fli8o80p0wccwj688zhmixgjzk15wzom.json" -OutFile X:\OSDCloud\Config\AutopilotJSON\AutopilotProfile.json
    } 

    If ( $action -eq 2 ) {
        Write-Host "=========================================================================" -ForegroundColor Cyan
        Write-Host "========================= Travel PC Deployment ==========================" -ForegroundColor Cyan
        Write-Host "=========================================================================" -ForegroundColor Cyan
        Invoke-WebRequest -Uri "https://clarkconstruction.box.com/shared/static/uzfltkr8mllyd4t7xld64fqendtbgt6j.json" -OutFile X:\OSDCloud\Config\AutopilotJSON\AutopilotProfile.json
    } 

    If ( $action -eq 3 ) {
        Write-Host "=========================================================================" -ForegroundColor Cyan
        Write-Host "======================== Donation PC Deployment =========================" -ForegroundColor Cyan
        Write-Host "=========================================================================" -ForegroundColor Cyan

        $Global:StartOSDCloudGUI = [ordered]@{
            ApplyManufacturerDrivers   = $false
            ApplyCatalogDrivers        = $false
            ApplyCatalogFirmware       = $false
            AutopilotJsonChildItem     = $false
            AutopilotJsonItem          = $false
            AutopilotJsonName          = $false
            AutopilotJsonObject        = $false
            AutopilotOOBEJsonChildItem = $false
            AutopilotOOBEJsonItem      = $false
            AutopilotOOBEJsonName      = $false
            AutopilotOOBEJsonObject    = $false
            ImageFileFullName          = $false
            ImageFileItem              = $false
            ImageFileName              = $false
            OOBEDeployJsonChildItem    = $false
            OOBEDeployJsonItem         = $false
            OOBEDeployJsonName         = $false
            OOBEDeployJsonObject       = $false
            Restart                    = $false
            SkipAutopilot              = $true
            SkipAutopilotOOBE          = $true
            SkipODT                    = $true
            SkipOOBEDeploy             = $true 
            ZTI                        = $true
            HPIADrivers                = $true
            HPIAFirmware               = $true
            HPTPMUpdate                = $true
            HPBIOSUpdate               = $true
            OSName                     = 'Windows 11 23H2 x64'
            OSEdition                  = 'Pro'
            OSActivation               = 'Retail'
            OSLanguage                 = 'en-us'
            updateDiskDrivers          = $true
            updateFirmware             = $true
            updateNetworkDrivers       = $true
            updateSCSIDrivers          = $true
            SyncMSUpCatDriverUSB       = $true
            WindowsUpdate              = $true
            WindowsUpdateDrivers       = $true       
        }
        Start-OSDCloud

        # Set Drive Lable Name
        Set-Volume -DriveLetter C -NewFileSystemLabel "Windows"

        # Restart from WinPE
        Write-Host -ForegroundColor Cyan "Restarting in 10 seconds!"
        Start-Sleep -Seconds 10

        wpeutil reboot
    } 

    Start-OSDCloud -ImageFileUrl "https://ccgsoftdist.s3.amazonaws.com/Kaseya/Windows10/install_23H2_2024_04_22631_3447_PRO.esd"

    # Set Drive Lable Name
    Set-Volume -DriveLetter C -NewFileSystemLabel "Windows"

    # Restart from WinPE
    Write-Host -ForegroundColor Cyan "Restarting in 10 seconds!"
    Start-Sleep -Seconds 10

    wpeutil reboot

}
else {
    Write-Host -ForegroundColor Cyan "The required module is not loaded. Please check the network connection and try again!"
}
