<#
 # Description: Script to Run Cloud Image
 # Created: 05/10/2021 by Danial
 #>

# Clear the host to ensure a clean environment
Clear-Host

# Retrieve the currently installed version of the OSD module
$currentVersion = (Get-Module -ListAvailable OSD | Sort-Object Version -Descending | Select-Object -First 1).Version

# Retrieve the latest available version of the OSD module from the PowerShell gallery
$latestVersion = (Find-Module -Name OSD | Sort-Object Version -Descending | Select-Object -First 1).Version

# Compare versions and install/update the OSD module if necessary
if ($currentVersion -lt $latestVersion) {
    Install-Module -Name OSD -Force
    Import-Module OSD
}

# Final check for the OSD module version
$currentVersion = (Get-Module -ListAvailable OSD | Sort-Object Version -Descending | Select-Object -First 1).Version

if ($currentVersion -ge [version]'24.3.10.1') {

    Clear-Host
    # Display startup message
    Write-Host "=========================================================================" -ForegroundColor Cyan
    Write-Host "===================== Cloud Image Deployment Script =====================" -ForegroundColor Cyan
    Write-Host "=========================================================================" -ForegroundColor Cyan
    Write-Host "========================== Starting Imaging ZTI =========================" -ForegroundColor Cyan
    Write-Host "================= Edition - 24H2 == Build - 26100.712 ===================" -ForegroundColor Cyan
    Write-Host "=========================================================================" -ForegroundColor Cyan
    Start-Sleep -Seconds 5

    # Deployment method choices
    $actionChoice = [System.Management.Automation.Host.ChoiceDescription[]]@(
        (New-Object System.Management.Automation.Host.ChoiceDescription("&Hybrid", "Hybrid Joined Machine")),
        (New-Object System.Management.Automation.Host.ChoiceDescription("&EntraID", "EntraID Joined Machine")),
        (New-Object System.Management.Automation.Host.ChoiceDescription("&Travel", "EntraID Joined Machine for Travel")),
        (New-Object System.Management.Automation.Host.ChoiceDescription("&Donation PC", "Regular Image for Donation PC"))
    )

    # Prompt user to select a deployment method
    $action = $Host.Ui.PromptForChoice("Deployment Method", "Select a Deployment method to perform imaging", $actionChoice, 0)

    # Base configuration for OSDCloudGUI with default values
    $baseConfig = @{
        ZTI                  = $true
        HPIADrivers          = $true
        HPIAFirmware         = $true
        HPTPMUpdate          = $true
        HPBIOSUpdate         = $true
        updateDiskDrivers    = $true
        updateFirmware       = $true
        updateNetworkDrivers = $true
        updateSCSIDrivers    = $true
        SyncMSUpCatDriverUSB = $true
        WindowsUpdate        = $true
        WindowsUpdateDrivers = $true
    }

    # Specific configuration for Donation PC Deployment
    $donationPCConfig = @{
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
        OSName                     = 'Windows 11 23H2 x64'
        OSEdition                  = 'Pro'
        OSActivation               = 'Retail'
        OSLanguage                 = 'en-us'
    }

    # Apply specific configuration based on user selection
    if ($action -eq 3) {
        $Global:StartOSDCloudGUI = $baseConfig + $donationPCConfig
    }
    else {
        $Global:StartOSDCloudGUI = $baseConfig
    }


    # Common deployment message
    $deploymentMessages = @(
        "========================== Hybrid Deployment ============================",
        "========================= AzureAD Deployment ============================",
        "========================= Travel PC Deployment ==========================",
        "======================== Donation PC Deployment ========================="
    )

    Write-Host $deploymentMessages[$action] -ForegroundColor Cyan

    # Handle deployment based on user selection
    switch ($action) {
        1 {
            Invoke-WebRequest -Uri "https://clarkconstruction.box.com/shared/static/fli8o80p0wccwj688zhmixgjzk15wzom.json" -OutFile X:\OSDCloud\Config\AutopilotJSON\AutopilotProfile.json
        }
        2 {
            Invoke-WebRequest -Uri "https://clarkconstruction.box.com/shared/static/uzfltkr8mllyd4t7xld64fqendtbgt6j.json" -OutFile X:\OSDCloud\Config\AutopilotJSON\AutopilotProfile.json
        }
        3 {
            Start-OSDCloud
        }
    }

    # Common deployment tasks for non-donation PCs
    if ($action -ne 3) {
        Start-OSDCloud -ImageFileUrl "https://ccgsoftdist.s3.us-east-1.amazonaws.com/Kaseya/Windows10/install_24H2_2024_05_26100_712_PRO.esd"
    }
    # Set drive label name
    Set-Volume -DriveLetter C -NewFileSystemLabel "Windows"

    # Restart from WinPE
    Write-Host "Restarting in 10 seconds!" -ForegroundColor Cyan
    Start-Sleep -Seconds 10
    wpeutil reboot

}
else {
    Write-Host "The required module is not loaded. Please check the network connection and try again!" -ForegroundColor Cyan
}
