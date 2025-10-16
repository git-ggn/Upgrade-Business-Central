Import-Module "C:\Program Files\Microsoft Dynamics 365 Business Central\240\Service\NavAdminTool.ps1"





New-NAVServerUser -ServerInstance BC240
                  -WindowsAccount "DEFACTOINFOTECH\GAGAN"
                  -LicenseType Full




New-NAVServerUserPermissionSet -ServerInstance "BC240" `
                               -WindowsAccount "DEFACTOINFOTECH\GAGAN" `
                               -PermissionSetId "SUPER" `
                               -CompanyName "*"

                               
$ServerInstance="BC240"
$WindowAccount="DEFACTOINFOTECH\GAGAN"
$FullName="Gagan"
$Email="Gagan@defactoinfotech.com"
$PermissionSet="SUPER"
$Company="*"



New-NAVServerUser -ServerInstance "BC240"`
                  -WindowsAccount "DEFACTOINFOTECH\GAGAN"`
                  -UserName "DEFACTOINFOTECH\GAGAN"`
                  -AuthenticationEmail "Gagan@defactoinfotech.com"`
                  -LicenseType Full

New-NAVServerUser -ServerInstance $ServerInstance `
                  -WindowsAccount $WindowAccount`
                  -UserName $WindowAccount `
                  -LicenseType Full

New-NAVServerUserPermissionSet -ServerInstance $ServerInstance `
                               -UserName $WindowAccount `
                               -PermissionSetId "SUPER" `
                               -CompanyName "*"

Get-NAVServerUser -ServerInstance "BC240"


Get-NAVCompany -ServerInstance "BC240"

Get-NAVServerUser -ServerInstance "BC240" |
    Group-Object LicenseType,State |
    Select-Object Name, Count

Remove-NAVServerUser -ServerInstance "BC240" `
                     -UserName "DEFACTOINFOTECH\GAGAN"



Get-NAVServerUser -ServerInstance "BC240" | Where-Object { $_.UserName -eq "DEFACTOINFOTECH\GAGAN" } | Format-List UserName, State, WindowsSecurityID ,LicenseType

Set-NAVServerUser -ServerInstance "BC240"`
-UserName "MALWA\MSINGH"`
-State Disabled


Set-NAVServerUser -ServerInstance "BC240"`
-UserName "MALWA\G.NEGI"`
-State Disabled

Set-NAVServerUser -ServerInstance "BC240"`
-UserName "MALWA\ASHOK.JOHRI"`
-State Disabled

Set-NAVServerUser -ServerInstance "BC240"`
-UserName "MALWA\JAGDEEP.SINGH"`
-State Disabled

Set-NAVServerUser -ServerInstance "BC240"`
-UserName "MALWA\vikas"`
-State Disabled
#--------------------------------------------------------------

$ServerInstance = "BC240"
$UserName = "DEFACTOINFOTECH\GAGAN"
$PermissionSet = "SUPER"

$companies = Get-NAVCompany -ServerInstance $ServerInstance

foreach ($company in $companies) {
    New-NAVServerUserPermissionSet -ServerInstance $ServerInstance `
                                   -UserName $UserName `
                                   -PermissionSetId $PermissionSet `
                                   -CompanyName $company.CompanyName
}



Restart-NAVServerInstance -ServerInstance BC240



$ServerInstance = "BC240"
$WindowsAccount = "DEFACTOINFOTECH\GAGAN"
$LicenseType = "Full"  # or LimitedUser depending on your license
New-NAVServerUser -ServerInstance $ServerInstance `
                  -WindowsAccount $WindowsAccount `
                  -LicenseType $LicenseType
