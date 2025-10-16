Import-Module 'C:\Program Files\Microsoft Dynamics 365 Business Central\260\Service\NavAdminTool.ps1'

function Publish-NonMSExtensions {
    $appfolder =  'C:\Users\Gagan\Desktop\Other Extension Apps\260'  # path of the folder
    $ServerInstance = "BC260"
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



