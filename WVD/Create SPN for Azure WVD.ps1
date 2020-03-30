$WVDTenant = ""
$TenantID = ""
$SubID = ""
$SPNAppID = ""
$SPNAppSecret = ""
$AzureGAcred = Get-Credential -Message "Enter the Global Admin Account of your Azure Tenant"

Import-Module -Name Microsoft.RDInfra.RDPowerShell
Connect-AzureAD -Credential $AzureGACred

#Create SPN
$svcPrincipal = New-AzureADApplication -AvailableToOtherTenants $true -DisplayName "WVD Service Principal"
$svcPrincipalCreds = New-AzureADApplicationPasswordCredential -ObjectId $svcPrincipal.ObjectId

#Build WVD Tenant
Add-RdsAccount -DeploymentUrl https://rdbroker.wvd.microsoft.com -Credential $AzureGAcred
New-RdsTenant -Name $WVDTenant -AadTenantId $TenantID -AzureSubscriptionId $SubID

#Add SPN Owner Role to WVD Tenant
New-RdsRoleAssignment -RoleDefinitionName "RDS Owner" -ApplicationId $SPNAppID -TenantName $WVDTenant

#Outbput SPN App ID and Secret to console
Write-Host "The SPN ID is:" $svcPrincipal.AppId
Write-Host "The SPN Secret is:" $svcPrincipalCreds.Value