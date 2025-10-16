Import-Module 'C:\Program Files\Microsoft Dynamics 365 Business Central\260\Service\NavAdminTool.ps1'

Invoke-NAVApplicationDatabaseConversion -DatabaseServer BUSINESSCENTRAL -DatabaseName MalwaLive25_26


Set-NAVServerConfiguration -ServerInstance BC260 -KeyName DatabaseServer -KeyValue BUSINESSCENTRAL
 
Set-NAVServerConfiguration -ServerInstance BC260 -KeyName DatabaseName -KeyValue MalwaLive25_26

Set-NavServerConfiguration -ServerInstance BC260 -KeyName "EnableTaskScheduler" -KeyValue false

#Start-NAVServerInstance -ServerInstance BC260

Restart-NAVServerInstance -ServerInstance BC260


#Import-NAVServerLicense -ServerInstance BC260 -LicenseFile "C:\Users\Gagan\Desktop\5879088.bclicense"
#Restart-NAVServerInstance -ServerInstance BC260


Sync-NAVTenant -ServerInstance BC260 -Tenant default -Mode Sync

Publish-NAVApp -serverInstance BC260 -path "C:\Users\Gagan\Desktop\Core Apps\260\Microsoft_System Application.app"
Publish-NAVApp -serverInstance BC260 -path "C:\Users\Gagan\Desktop\Core Apps\260\Microsoft_Business Foundation.app"
Publish-NAVApp -serverInstance BC260 -path "C:\Users\Gagan\Desktop\Core Apps\260\Microsoft_Base Application.app"
Publish-NAVApp -serverInstance BC260 -path "C:\Users\Gagan\Desktop\Core Apps\260\Microsoft_Application.app"


Restart-NAVServerInstance -ServerInstance BC260


Sync-NAVApp -ServerInstance BC260 -Tenant default -Name "System Application" -Version 26.6.40035.0
Sync-NAVApp -ServerInstance BC260 -Tenant default -Name "Business Foundation" -Version 26.6.40035.0
Sync-NAVApp -ServerInstance BC260 -Tenant default -Name "Base Application" -Version 26.6.40035.0
Sync-NAVApp -ServerInstance BC260 -Tenant default -Name "Application" -Version 26.6.40035.0


Start-NAVAppDataUpgrade -ServerInstance BC260 -Name "System Application" -Version 26.6.40035.0
Start-NAVAppDataUpgrade -ServerInstance BC260 -Name "Business Foundation" -Version 26.6.40035.0
Start-NAVAppDataUpgrade -ServerInstance BC260 -Name "Base Application" -Version 26.6.40035.0
Start-NAVAppDataUpgrade -ServerInstance BC260 -Name "Application" -Version 26.6.40035.0



$AddinsFolder = 'C:\Program Files\Microsoft Dynamics 365 Business Central\260\Service\Add-ins'

Set-NAVAddIn -ServerInstance BC260 -AddinName 'Microsoft.Dynamics.Nav.Client.BusinessChart' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'BusinessChart\Microsoft.Dynamics.Nav.Client.BusinessChart.zip')
Set-NAVAddIn -ServerInstance BC260 -AddinName 'Microsoft.Dynamics.Nav.Client.FlowIntegration' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'FlowIntegration\Microsoft.Dynamics.Nav.Client.FlowIntegration.zip')
Set-NAVAddIn -ServerInstance BC260 -AddinName 'Microsoft.Dynamics.Nav.Client.OAuthIntegration' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'OAuthIntegration\Microsoft.Dynamics.Nav.Client.OAuthIntegration.zip')
Set-NAVAddIn -ServerInstance BC260 -AddinName 'Microsoft.Dynamics.Nav.Client.PageReady' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'PageReady\Microsoft.Dynamics.Nav.Client.PageReady.zip')
Set-NAVAddIn -ServerInstance BC260 -AddinName 'Microsoft.Dynamics.Nav.Client.PowerBIManagement' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'PowerBIManagement\Microsoft.Dynamics.Nav.Client.PowerBIManagement.zip')
Set-NAVAddIn -ServerInstance BC260 -AddinName 'Microsoft.Dynamics.Nav.Client.RoleCenterSelector' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'RoleCenterSelector\Microsoft.Dynamics.Nav.Client.RoleCenterSelector.zip')
Set-NAVAddIn -ServerInstance BC260 -AddinName 'Microsoft.Dynamics.Nav.Client.SatisfactionSurvey' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'SatisfactionSurvey\Microsoft.Dynamics.Nav.Client.SatisfactionSurvey.zip')
Set-NAVAddIn -ServerInstance BC260 -AddinName 'Microsoft.Dynamics.Nav.Client.VideoPlayer' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'VideoPlayer\Microsoft.Dynamics.Nav.Client.VideoPlayer.zip')
Set-NAVAddIn -ServerInstance BC260 -AddinName 'Microsoft.Dynamics.Nav.Client.WebPageViewer' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'WebPageViewer\Microsoft.Dynamics.Nav.Client.WebPageViewer.zip')
Set-NAVAddIn -ServerInstance BC260 -AddinName 'Microsoft.Dynamics.Nav.Client.WelcomeWizard' -PublicKeyToken 31bf3856ad364e35 -ResourceFile ($AppName = Join-Path $AddinsFolder 'WelcomeWizard\Microsoft.Dynamics.Nav.Client.WelcomeWizard.zip')



Set-NAVApplication -ServerInstance BC260 -ApplicationVersion 26.6.40035.0 -Force
Sync-NAVTenant -ServerInstance BC260 -Mode Sync -Tenant default
Start-NAVDataUpgrade -ServerInstance BC260 -FunctionExecutionMode Serial -Tenant default -SkipUserSessionCheck

Set-NAVServerConfiguration -ServerInstance BC260 -KeyName SolutionVersionExtension -KeyValue "437dbf0e-84ff-417a-965d-ed2bb9650972" -ApplyTo All
