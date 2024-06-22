<#
 # Description : Script to Run Cloud Image
 # Created : 05/10/2021 by Danial
 #>

# Function to decode obfuscated strings
function Decode-String {
    param ([string]$EncodedString)
    [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($EncodedString))
}

# Function to display banner
function Show-Banner {
    Clear-Host
    Write-Host ("=" * 73) -ForegroundColor Cyan
    Write-Host "===================== Cloud Image Deployment Script =====================" -ForegroundColor Cyan
    Write-Host ("=" * 73) -ForegroundColor Cyan
    Write-Host "========================== Starting Imaging ZTI =========================" -ForegroundColor Cyan
    Write-Host "================= Edition - 23H2 == Build - 22631.3737 ==================" -ForegroundColor Cyan
    Write-Host ("=" * 73) -ForegroundColor Cyan
    Start-Sleep -Seconds 5
}

# Function to update OSD module
function Update-OSDModule {
    $installedVersion = (Get-Module -ListAvailable OSD | Sort-Object Version -Descending | Select-Object -First 1).Version
    $onlineVersion = (Find-Module -Name OSD).Version

    if ($installedVersion -lt $onlineVersion) {
        Install-Module -Name OSD -Force
        Import-Module OSD
    }

    $updatedVersion = (Get-Module -ListAvailable OSD | Sort-Object Version -Descending | Select-Object -First 1).Version
    if ($updatedVersion -lt [version]'24.3.10.1') {
        Write-Host "The required module version is not loaded. Please check the network connection and try again!" -ForegroundColor Cyan
        exit
    }
}

# Function to set up deployment
function Set-DeploymentConfig {
    param (
        [string]$DeploymentType,
        [string]$EncodedJsonUrl
    )
    Write-Host ("=" * 73) -ForegroundColor Cyan
    Write-Host "========================== $DeploymentType Deployment ============================" -ForegroundColor Cyan
    Write-Host ("=" * 73) -ForegroundColor Cyan

    if ($EncodedJsonUrl) {
        $JsonUrl = Decode-String $EncodedJsonUrl
        Invoke-WebRequest -Uri $JsonUrl -OutFile X:\OSDCloud\Config\AutopilotJSON\AutopilotProfile.json
    }
}

# Main script
Update-OSDModule
Show-Banner

# Select Deployment Method
$actionChoice = @(
    [System.Management.Automation.Host.ChoiceDescription]::new("&Hybrid", "Hybrid Joined Machine")
    [System.Management.Automation.Host.ChoiceDescription]::new("&AAD", "AzureAD Joined Machine")
    [System.Management.Automation.Host.ChoiceDescription]::new("&Travel", "AzureAD Joined Machine for Travel")
    [System.Management.Automation.Host.ChoiceDescription]::new("&Donation PC", "Regular Image for Donation PC")
)

$action = $Host.UI.PromptForChoice("Deployment Method", "Select a Deployment method to perform imaging", $actionChoice, 0)

$Global:StartOSDCloudGUI = @{
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

switch ($action) {
    0 { Set-DeploymentConfig -DeploymentType "Hybrid" }
    1 { Set-DeploymentConfig -DeploymentType "AzureAD" -EncodedJsonUrl "aHR0cHM6Ly9jbGFya2NvbnN0cnVjdGlvbi5ib3guY29tL3NoYXJlZC9zdGF0aWMvZmxpOG84MHAwd2Njd2o2ODh6aG1peGdqemsxNXd6b20uanNvbg==" }
    2 { Set-DeploymentConfig -DeploymentType "Travel PC" -EncodedJsonUrl "aHR0cHM6Ly9jbGFya2NvbnN0cnVjdGlvbi5ib3guY29tL3NoYXJlZC9zdGF0aWMvdXpmbHRrcjhtbGx5ZDR0N3hsZDY0ZnFlbmR0Ymd0NmouanNvbg==" }
    3 { Set-DeploymentConfig -DeploymentType "Donation PC"
        $Global:StartOSDCloudGUI += @{
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
        }
        Start-OSDCloud
        Set-Volume -DriveLetter C -NewFileSystemLabel "Windows"
        Write-Host "Restarting in 10 seconds!" -ForegroundColor Cyan
        Start-Sleep -Seconds 10
        wpeutil reboot
        exit
    }
}

$encodedImageFileUrl = "aHR0cHM6Ly9jY2dzb2Z0ZGlzdC5zMy51cy1lYXN0LTEuYW1hem9uYXdzLmNvbS9LYXNleWEvV2luZG93czEwL2luc3RhbGxfMjRIMl8yMDI0XzA1XzI2MTAwXzcxMl9QUk8uZXNk"
$imageFileUrl = Decode-String $encodedImageFileUrl

Start-OSDCloud -ImageFileUrl $imageFileUrl

Set-Volume -DriveLetter C -NewFileSystemLabel "Windows"

Write-Host "Restarting in 10 seconds!" -ForegroundColor Cyan
Start-Sleep -Seconds 10
wpeutil reboot