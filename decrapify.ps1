# Written by Alexander Hill <ahill@wgtech.com>
# Added to by Sean McKeen <smckeen@wgtech.com>

$badpkg = @(
    "Microsoft.BingNews*"
    "Microsoft.BingWeather*"
    "Microsoft.GamingApp*"
    "Microsoft.Getstarted*"
    "Microsoft.MicrosoftOfficeHub*"
    "Microsoft.People*"
    "Microsoft.PowerAutomateDesktop*"
    "Microsoft.Windows.Photos*"
    "Microsoft.WindowsAlarms*"
    "microsoft.windowscommunicationsapps*"
    "Microsoft.WindowsFeedbackHub*"
    "Microsoft.WindowsMaps*"
    "Microsoft.YourPhone*"
    "Microsoft.ZuneMusic*"
    "Microsoft.ZuneVideo*"
    "MicrosoftCorporationII.QuickAssist*"
    "MicrosoftCorporationII.MicrosoftFamily*"
    "MicrosoftTeams*"
    "26720RandomSaladGamesLLC.3899848563C1F*"
    "C27EB4BA.DropboxOEM*"
    "57540AMZNMobileLLC.AmazonAlexa*"
    "McAfeeWPSSparsePackage*"
    "DolbyLaboratories.DolbyAccess*"

)

$dellBadPKGs = @(
    
)

$hpBadPKGs = @(
    "AD2F1837.HPJumpStarts*"
    "AD2F1837.HPPCHardwareDiagnosticsWindows*"
    "AD2F1837.HPPowerManager*"
    "AD2F1837.HPPrivacySettings*"
    "AD2F1837.HPSureShieldAI*"
    "AD2F1837.HPSystemInformation*"
    "AD2F1837.HPQuickDrop*"
    "AD2F1837.HPWorkWell*"
    "AD2F1837.myHP*"
    "AD2F1837.HPDesktopSupportUtilities*"
    "AD2F1837.HPQuickTouch*"
    "AD2F1837.HPEasyClean*"
    "AD2F1837.HPSystemInformation*"
)

$lenovoBadPKGs = @(
    "E046963F.AIMeetingManager"
    "E0469640.SmartAppearance"
    "MirametrixInc.GlancebyMirametrix"
    "E046963F.LenovoCompanion"
    "E0469640.LenovoUtility"
    "E0469640.LenovoSmartCommunication"
    "E046963F.LenovoSettingsforEnterprise"
    "E046963F.cameraSettings"
    "4505Fortemedia.FMAPOControl2_2.1.37.0_x64__4pejv7q2gmsnr"
    "ElevocTechnologyCo.Ltd.SmartMicrophoneSettings_1.1.49.0_x64__ttaqwwhyt5s6t"
)

# Query WMI to get the computer system information
$computerSystem = Get-CimInstance -ClassName Win32_ComputerSystem

# Retrieve the manufacturer from the computer system information
$manufacturer = $computerSystem.Manufacturer

# Check if the manufacturer contains "Dell"
if ($manufacturer -like "*Dell*") {
    Write-Host "Manufacturer: 'Dell'"
    $badpkg += $dellBadPKGs

} elseif ($manufacturer -like "*HP*") {
    Write-Host "Manufacturer: 'HP'"
    $badpkg += $hpBadPKGs

}elseif ($manufacturer -like "*Lenovo*") {
    Write-Host "Manufacturer: 'Lenovo'"
    $badpkg += $lenovoBadPKGs
}

$provisioned = Get-AppxProvisionedPackage -Online

foreach($pkg in $badpkg) {
    Write-Output ("Removing " + $pkg)

    Try {
        Get-AppxPackage -AllUsers $pkg | Remove-AppxPackage -AllUsers
        $provisioned | Where-Object { $_.PackageName -like $pkg } | Remove-AppxProvisionedPackage -Online
    }
    Catch {
        Write-Warning -Message "Failed to remove provisioned package: [$($ProvPackage)]"
    }
}

#Remove McAfee

$mcAfee = '"C:\Program Files\McAfee\wps\1.18.255.1\mc-update.exe" /uninstall'

    Try {
    Start-Process cmd.exe -ArgumentList "/c $mcAfee" -Verb RunAs -Wait
    Write-Output "Removing McAfee (STILL CHECK CONTROL PANEL)"
    }
    Catch {
    Write-Warning -Message "No McAfee Found"
    }
