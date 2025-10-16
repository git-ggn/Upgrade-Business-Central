Import-Module 'C:\Program Files\Microsoft Dynamics 365 Business Central\252\Service\NavAdminTool.ps1'

function Publish-NonMSExtensions {
     $appfolder = 'C:\Users\Gagan\Desktop\Client Apps'#'C:\Users\Gagan\Desktop\New Issue Apps 0810' #'C:\Users\Gagan\Desktop\New Apps'   #'C:\Users\Gagan\Desktop\Client Apps'
    $ServerInstance = "BC252"
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

# Run the function
Publish-NonMSExtensions



#Start-NAVAppDataUpgrade -ServerInstance BC252 -Tenant default -Name "Email - Current User Connector" -Publisher Microsoft -Version 25.10.37185.0
#Start-NAVAppDataUpgrade -ServerInstance BC252 -Tenant default -Name "Email - Microsoft 365 Connector" -Publisher Microsoft -Version 25.10.37185.0
#Start-NAVAppDataUpgrade -ServerInstance BC252 -Tenant default -Name "TextileIndustry" -Publisher Microsoft -Version 1.0.0.1




