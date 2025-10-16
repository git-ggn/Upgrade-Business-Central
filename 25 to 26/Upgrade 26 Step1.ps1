Import-Module 'C:\Program Files\Microsoft Dynamics 365 Business Central\252\Service\NavAdminTool.ps1'

Get-NAVAppInfo -ServerInstance BC252 -Tenant default | % { Uninstall-NAVApp -ServerInstance BC252 -Tenant default -Name $_.Name -Version $_.Version -Force}

Get-NAVAppInfo -ServerInstance BC252 | % { Unpublish-NAVApp -ServerInstance BC252 -Name $_.Name -Version $_.Version}

Get-NAVAppInfo -ServerInstance BC252 -SymbolsOnly | % { Unpublish-NAVApp -ServerInstance BC252 -Name $_.Name -Version $_.Version }


Stop-NAVServerInstance -ServerInstance BC252


#Get-NAVAppInfo -ServerInstance BC252

