Import-Module 'C:\Program Files\Microsoft Dynamics 365 Business Central\252\Service\NavAdminTool.ps1'

$orderedApps = @(
   # 'C:\Users\Gagan\Desktop\ERPCode\LiveCode\Punjab Bulls_Live Code_1.0.0.2.app'
   'C:\Users\Gagan\Desktop\ERPCode\PayRole\Punjab Bulls_PayRole_1.0.0.3.app'
   # 'C:\Users\Gagan\Desktop\ERPCode\TextileIndustry\punjabbulls_TextileIndustry_1.0.0.0.app'
)

foreach ($appPath in $orderedApps) {
    Write-Host "`n➡ Processing: $appPath"

    Publish-NAVApp -ServerInstance BC252 -Path $appPath -SkipVerification

    # get the published app info
    $appInfo = Get-NAVAppInfo -ServerInstance BC252 | Where-Object { $_.Path -eq $appPath }
    if ($appInfo) {
        $appName = $appInfo.Name
        $appVersion = $appInfo.Version.ToString()

        Write-Host "Syncing and upgrading $appName ($appVersion)..."
        Sync-NAVApp -ServerInstance BC252 -Tenant default -Name $appName -Version $appVersion
        Start-NAVAppDataUpgrade -ServerInstance BC252 -Tenant default -Name $appName -Version $appVersion
    } else {
        Write-Warning "App not found after publish: $appPath"
    }
}

Write-Host "`n✅ All Apps are Published uccessfully."


#------------------------------------------------------------------------------------------------------------------------

