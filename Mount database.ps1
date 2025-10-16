Import-Module "C:\Program Files\Microsoft Dynamics 365 Business Central\240\Service\NavAdminTool.ps1"

Set-NAVServerConfiguration -ServerInstance BC240 -KeyName DatabaseServer -KeyValue BUSINESSCENTRAL
Set-NAVServerConfiguration -ServerInstance BC240 -KeyName DatabaseName -KeyValue MalwaLive


Restart-NAVServerInstance -ServerInstance BC240

#---------------------------------------------------------------------------------------------------------------


Stop-NAVServerInstance -ServerInstance BC240


Set-NAVServerConfiguration -ServerInstance BC240 -KeyName "DatabaseServer" -KeyValue "BUSINESSCENTRAL"
Set-NAVServerConfiguration -ServerInstance BC240 -KeyName "DatabaseName" -KeyValue "Demo Database BC (24-0)"


Start-NAVServerInstance -ServerInstance BC240


#to Check the database server and the database name..
Get-NAVServerInstance -ServerInstance BC240 | Select-Object State, DatabaseServer, DatabaseName

Import-NAVServerLicense -ServerInstance BC240 -LicenseFile "C:\Users\Gagan\Desktop\5879088.flf"
Import-NAVServerLicense -ServerInstance BC240 -LicenseFile "C:\Users\Gagan\Desktop\5879088.bclicense"

Start-NAVServerInstance -ServerInstance BC240

Stop-NAVServerInstance -ServerInstance BC240

Start-NAVServerInstance -ServerInstance BC240
Import-NAVServerLicense -ServerInstance BC240 -LicenseFile "C:\Users\Gagan\Desktop\5879088.flf"

Restart-NAVServerInstance -ServerInstance BC240

