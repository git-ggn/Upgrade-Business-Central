
Import-Module 'C:\Program Files\Microsoft Dynamics 365 Business Central\240\Service\NavAdminTool.ps1'


Get-NAVAppInfo -ServerInstance BC240 -Tenant default | % { Uninstall-NAVApp -ServerInstance BC240 -Tenant default -Name $_.Name -Version $_.Version -Force}

Get-NAVAppInfo -ServerInstance BC240 | % { Unpublish-NAVApp -ServerInstance BC240 -Name $_.Name -Version $_.Version}

Get-NAVAppInfo -ServerInstance BC240 -SymbolsOnly | % { Unpublish-NAVApp -ServerInstance BC240 -Name $_.Name -Version $_.Version }

Stop-NAVServerInstance -ServerInstance BC240


Get-NAVAppInfo -ServerInstance BC240



# Uninstall only those apps that are actually installed
Get-NAVAppInfo -ServerInstance BC240 -Tenant default | Where-Object { $_.IsInstalled -eq $true } | % {
    Uninstall-NAVApp -ServerInstance BC240 -Tenant default -Name $_.Name -Version $_.Version -Force -Verbose
}

# Then unpublish everything (installed or not)
Get-NAVAppInfo -ServerInstance BC240 | % {  Unpublish-NAVApp -ServerInstance BC240 -Name $_.Name -Version $_.Version -Verbose }

# And also unpublish symbol-only apps
Get-NAVAppInfo -ServerInstance BC240 -SymbolsOnly | % {
    Unpublish-NAVApp -ServerInstance BC240 -Name $_.Name -Version $_.Version -Verbose
}


Get-NAVAppInfo -ServerInstance BC240 | Select Name, Version, Publisher, Dependencies



