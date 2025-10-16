Import-Module 'C:\Program Files\Microsoft Dynamics 365 Business Central\260\Service\NavAdminTool.ps1'

function Publish-NonMSExtensions {
    $appfolder = 'C:\Users\Gagan\Desktop\New Apps\260'#'C:\Users\Gagan\Desktop\Apps Issue\260'#'C:\Users\Gagan\Desktop\New Apps\260'
    $ServerInstance = "BC260"
    $Tenant = "default"

    Write-Host "Scanning apps in: $appfolder" -ForegroundColor Cyan

    $AppsOnDisk = Get-ChildItem -Path $appfolder -Filter *.app -Recurse
    $appInfos = @()

    foreach ($appFile in $AppsOnDisk) {
        try {
            $app = Get-NAVAppInfo -Path $appFile.FullName
            $app | Add-Member -MemberType NoteProperty -Name FullPath -Value $appFile.FullName
            $appInfos += $app
        } catch {
            Write-Warning "Failed to read app info: $($appFile.FullName)"
        }
    }

    # Sort by dependency count
    $sortedApps = $appInfos | Sort-Object { ($_.Dependencies).Count }

    foreach ($app in $sortedApps) {
        Write-Host "`n➡ Processing: $($app.Name) v$($app.Version)" -ForegroundColor Cyan
        try {
            # Publish
            Publish-NAVApp -ServerInstance $ServerInstance -Path $app.FullPath -SkipVerification
            Write-Host "Published: $($app.Name)" -ForegroundColor Green

            # Sync
            Sync-NAVApp -ServerInstance $ServerInstance -Tenant $Tenant -Name $app.Name -Version $app.Version
            Write-Host "Synced: $($app.Name)" -ForegroundColor Yellow

            # Check if installed already
            $installed = Get-NAVAppInfo -ServerInstance $ServerInstance -Tenant $Tenant |
                         Where-Object { $_.Name -eq $app.Name }

            if ($installed) {
                Write-Host "App already installed. Running data upgrade..." -ForegroundColor Magenta
                Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Tenant $Tenant -Name $app.Name -Version $app.Version
                Write-Host "Data upgrade done: $($app.Name)" -ForegroundColor Green
            }
            else {
                Write-Host "App not previously installed. Installing now..." -ForegroundColor Magenta
                Install-NAVApp -ServerInstance $ServerInstance -Tenant $Tenant -Name $app.Name -Version $app.Version
                Write-Host "Installed: $($app.Name)" -ForegroundColor Green
            }
        }
        catch {
            Write-Warning "Failed to process $($app.Name): $_"
        }
    }

    Write-Host  "All apps processed successfully." -ForegroundColor Cyan
}
Publish-NonMSExtensions





#Get-NAVAppInfo -ServerInstance BC260 -Name "Subscription Billing"


#Publish-NAVApp -ServerInstance BC260 -Path 'C:\Users\Gagan\Downloads\Dynamics.365.BC.40035.IN.DVD\applications\SubscriptionBilling\Source\Microsoft_Subscription Billing.app' -SkipVerification

#Sync-NAVApp -ServerInstance BC260 -Tenant default -Name "Subscription Billing" -Version 26.6.40035.0
#Start-NAVAppDataUpgrade -ServerInstance BC260 -Tenant default -Name "Subscription Billing" -Version 26.6.40035.0


#Install-NAVApp -ServerInstance BC260 -Tenant default -Name "Subscription Billing" -Version 26.6.40035.0


#Start-NAVAppDataUpgrade -ServerInstance BC260 -Tenant default -Name "E-Document Connector - Pagero" -Version 26.6.40035.0
