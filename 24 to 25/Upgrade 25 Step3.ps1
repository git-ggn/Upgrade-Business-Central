Import-Module 'C:\Program Files\Microsoft Dynamics 365 Business Central\252\Service\NavAdminTool.ps1'

function Publish-NonMSExtensions {
    $appfolder = 'C:\Users\Gagan\Desktop\Apps Issue\252' #'C:\Users\Gagan\Desktop\Not Installed Issue'     # 'C:\Users\Gagan\Desktop\Other Extensions Apps\252'  # path of the folder
    $ServerInstance = "BC252"
    $Tenant = "default"

    Write-Host "Scanning apps in: $appfolder" -ForegroundColor Cyan

    # Get all .app files recursively from the folder
    $AppsOnDisk = Get-ChildItem -Path $appfolder -Filter *.app -Recurse

    $appInfos = @()

    # Extract app metadata
    foreach ($appFile in $AppsOnDisk) {
        try {
            $app = Get-NAVAppInfo -Path $appFile.FullName
            $app | Add-Member -MemberType NoteProperty -Name FullPath -Value $appFile.FullName
            $appInfos += $app
        } catch {
            Write-Warning "Failed to read app info: $($appFile.FullName)"
        }
    }

    # Sort apps by number of dependencies
    $sortedApps = $appInfos | Sort-Object { ($_.Dependencies).Count }

    foreach ($app in $sortedApps) {
        Write-Host "Processing: $($app.Name) v$($app.Version)" -ForegroundColor Cyan
        try {
            # Publish
            Publish-NAVApp -ServerInstance $ServerInstance -Path $app.FullPath -SkipVerification
            Write-Host "Published: $($app.Name)" -ForegroundColor Green

            # Sync
            Sync-NAVApp -ServerInstance $ServerInstance -Tenant $Tenant -Name $app.Name -Version $app.Version
            Write-Host "Synced: $($app.Name)" -ForegroundColor Yellow

            # Data upgrade
            Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Tenant $Tenant -Name $app.Name -Version $app.Version
            Write-Host "Upgraded data: $($app.Name)" -ForegroundColor Green
        } catch {
            Write-Warning "Failed to process $($app.Name): $_"
        }
    }

    Write-Host "All apps processed successfully." -ForegroundColor Cyan
}

# Run the function
Publish-NonMSExtensions

#----------------------------------Independently Nedded to upgrade------------------------------------------------------------

Publish-NAVApp -ServerInstance BC252 -Path 'C:\Users\Gagan\Desktop\Apps Issue\Independently Needed\252\Microsoft_India Gate Entry.app' -SkipVerification
Sync-NAVApp -ServerInstance BC252 -Tenant default -Name 'India Gate Entry' -Version 25.10.37185.0
Start-NAVAppDataUpgrade -ServerInstance BC252 -Tenant default -Name "India Gate Entry" -Publisher Microsoft -Version 25.10.37185.0


Publish-NAVApp -ServerInstance BC252 -Path 'C:\Users\Gagan\Desktop\Apps Issue\Independently Needed\252\Microsoft_Email - Current User Connector.app' -SkipVerification
Sync-NAVApp -ServerInstance BC252 -Tenant default -Name 'Email - Current User Connector' -Version 25.10.37185.0
Start-NAVAppDataUpgrade -ServerInstance BC252 -Tenant default -Name "Email - Current User Connector" -Publisher Microsoft -Version 25.10.37185.0


Publish-NAVApp -ServerInstance BC252 -Path 'C:\Users\Gagan\Desktop\Apps Issue\Independently Needed\252\Microsoft_Email - Microsoft 365 Connector.app' -SkipVerification
Sync-NAVApp -ServerInstance BC252 -Tenant default -Name 'Email - Microsoft 365 Connector' -Version 25.10.37185.0
Start-NAVAppDataUpgrade -ServerInstance BC252 -Tenant default -Name "Email - Microsoft 365 Connector" -Publisher Microsoft -Version 25.10.37185.0


Publish-NAVApp -ServerInstance BC252 -Path 'C:\Users\Gagan\Desktop\Apps Issue\252\Microsoft_Performance Toolkit.app' -SkipVerification
Sync-NAVApp -ServerInstance BC252 -Tenant default -Name 'Performance Toolkit' -Version 25.10.37185.0
Start-NAVAppDataUpgrade -ServerInstance BC252 -Tenant default -Name "Performance Toolkit" -Publisher Microsoft -Version 25.10.37185.0

