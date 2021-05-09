# Starting the Imaging
Write-Host -ForegroundColor Green "Starting Clark Imaging ZTI"
Start-Sleep -Seconds 5

# Start the Script
Write-Host -ForegroundColor Green "Start Cloud Image..."
Start-OSDCloud -Product NODRIVER -OSLanguage en-us -OSBuild 20H2 -OSEdition Enterprise -ZTI -ImageFileUrl "https://ccgsoftdist.s3.amazonaws.com/Kaseya/Windows10/20H2/install_20H2_2021_04_(19042.928).esd?AWSAccessKeyId=AKIAJ6POTXPHUP2EPBXA&Expires=1715135567&Signature=s8kbsn95UYNj%2BOTG%2FYAl845GlR4%3D"

# Restart from WinPE
Write-Host -ForegroundColor Green "Restarting in 20 seconds!"
Start-Sleep -Seconds 20

wpeutil reboot