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

Clear-Host
# Starting the Imaging
Write-Host "=========================================================================" -ForegroundColor Cyan
Write-Host "===================== Cloud Image Deployment Script =====================" -ForegroundColor Cyan
Write-Host "=========================================================================" -ForegroundColor Cyan
Write-Host "========================== Starting Imaging ZTI =========================" -ForegroundColor Cyan
Write-Host "================= Edition - 23H2 == Build - 22631.3155 ==================" -ForegroundColor Cyan
Write-Host "=========================================================================" -ForegroundColor Cyan
Start-Sleep -Seconds 5

# Updating Module
#Install-Module OSD -Force
#Import-Module OSD -Force
#iex (irm functions.garytown.com)

# Select Deployment Method
$actionChoice = [System.Management.Automation.Host.ChoiceDescription[]]@(
    (New-Object System.Management.Automation.Host.ChoiceDescription("&Hybrid", "Hybrid Joined Machine")),
    (New-Object System.Management.Automation.Host.ChoiceDescription("&AAD", "AzureAD Joined Machine")),
    (New-Object System.Management.Automation.Host.ChoiceDescription("&Travel", "AzureAD Joined Machine for Travel")),
    (New-Object System.Management.Automation.Host.ChoiceDescription("&Donation PC", "Regular Image for Donation PC"))
)

# Prompt for choice with a timer
$action = $null
$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()

while (-not $action -and $timer.Elapsed.TotalSeconds -lt 30) {
    if ($Host.UI.RawUI.KeyAvailable) {
        $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        if ($key.Key -eq "Enter") {
            break
        }
    }
}

# Select default option if no input within the specified time
if (-not $action) {
    $action = 0  # Default option index
}

$timer.Stop()


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

    $Global:StartOSDCloudGUI = $null
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
        HPBIOSUpdate               = $false
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

# Start-OSDCloud -Product NODRIVER -OSLanguage en-us -OSBuild 23H2 -OSEdition Enterprise -ZTI
$Global:StartOSDCloudGUI = [ordered]@{
    ZTI                        = $true
    HPIADrivers                = $true
    HPIAFirmware               = $true
    HPTPMUpdate                = $true
    HPBIOSUpdate               = $false

    OSName = 'Windows 11 23H2 x64'
    OSEdition = 'Pro'
    OSActivation = 'Retail'
    OSLanguage = 'en-us'
    updateDiskDrivers = $true
    updateFirmware = $true
    updateNetworkDrivers =$true
    updateSCSIDrivers = $true
    SyncMSUpCatDriverUSB = $true
    WindowsUpdate = $true
    WindowsUpdateDrivers = $true

}

Start-OSDCloud
#Start-OSDCloud -ImageFileUrl "https://ccgsoftdist.s3.amazonaws.com/Kaseya/Windows10/install_23H2_2024_02_22631_3155_PRO.esd"


# Set Drive Lable Name
Set-Volume -DriveLetter C -NewFileSystemLabel "Windows"

# Restart from WinPE
Write-Host -ForegroundColor Cyan "Restarting in 10 seconds!"
Start-Sleep -Seconds 10

wpeutil reboot
