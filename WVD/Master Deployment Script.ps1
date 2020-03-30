<##################################################################################
#
#
#
#
#
# 
# 1. Give WVD Consent to your Azure AD Tenant
#       Browse to: https://rdweb.wvd.microsoft.com/
#       Select "Server App" in Consent Option
#       Enter your Azure AD Tenant ID and select Submit
#       You will be prompted to enter Admin credentials for the Azure AD Tenant
#       Open the same page again: https://rdweb.wvd.microsoft.com/
#       Select "Client App" in Consent Option
#       Enter your Azure AD Tenant ID and select Submit
#       You will again be prompted for Admin crednetials for your Azure AD Tenant
#
###################################################################################
#>

#region Environment Setup
#Install all the modules
#<todo: Add error check code>
  #Install-Module AzureAD
  #Install-Module -Name Microsoft.RDInfra.RDPowerShell

#Import all the modules
#<todo: add error check code>
  #Import-Module AzureAD
  #Import-Module -Name Microsoft.RDInfra.RDPowerShell

#endregion


#region - Variable Definitions
#$AzureGAcred = Get-Credential -Message "Enter the Global Admin Account of your Azure Tenant"
$SubGUID = ""
$AADGUID = ""
$WVDTenantName = ""
$DesktopHostPoolName = ""
$AppHostPoolName = ""
$AppGroupName = ""
$SPNAppID = ""
$SPNAppSecret = ""
$SPNObjectID = ""

#endregion


#region - Login to both AAD and WVD

# Login to Azure so you can deploy VMs to your Azure Subscription - you must have Contributor or Owner rights
Login-AzureRmAccount -Subscription $SubGUID

# Login to WVD 
Add-RdsAccount –DeploymentUrl “https://rdbroker.wvd.microsoft.com” #You must login with a UPN that has been assigned Tenant Creator role in AAD

#endregion


#region - Create a New WVD Tenant

    #Create WVD Tenant command
    New-RdsTenant -Name $WVDTenantName -AadTenantId $AADGUID -AzureSubscriptionId $SubGUID

    #Add a SPN created in Azure for the Tenant
    New-RdsRoleAssignment -TenantName $WVDTenantName -RoleDefinitionName "RDS Owner" -ApplicationId $SPNAppID

#endregion


#region - Create the Desktop HostPool and Add Users
    #Create a new Desktop Host Pool with pooled desktops
    #ToDo: Deploy App Host Pool from ARM Template

    #Wait until Desktop Host Pool is deployed

    #Add Users t one Host Pool
    Add-RdsAppGroupUser $WVDTenantName $HostPoolNameDesktops “Desktop Application Group” -UserPrincipalName "UPN of User"

    #This command sets the host pool to be a validation host pool
    #It will receive service updates at a faster cadence, allowing you to test any service changes before they are deployed broadly in production.
    #Set-RdsHostPool -TenantName $WVDTenantName -HostPoolName $HostPoolNameDesktops -ValidationEnv $true

#endregion


#region - Create the App HostPool and Add Users
    #Deploy a new Host Pool for Remote Applications
    #ToDo: Deploy App Host Pool from ARM Template

    #Wait until App Host Pool is deployed

    #Create a new App Group 
    New-RdsAppGroup $WVDTenantName $AppHostPoolName $AppGroupName -ResourceType "RemoteApp"

    Get-RdsStartMenuApp $WVDTenantName $HostPoolNameApps $AppGroupName | Out-File -FilePath .\applist.txt

    #Run the following cmdlet to install the application based on its appalias
    New-RdsRemoteApp $WVDTenantName $HostPoolName $AppGroupName -Name "Word" -AppAlias word
    New-RdsRemoteApp $WVDTenantName $HostPoolName $AppGroupName -Name "Excel" -AppAlias excel
    New-RdsRemoteApp $WVDTenantName $HostPoolName $AppGroupName -Name "PowerPoint" -AppAlias powerpoint
    New-RdsRemoteApp $WVDTenantName $HostPoolName $AppGroupName -Name "Outlook" -AppAlias outlook
    New-RdsRemoteApp $WVDTenantName $HostPoolName $AppGroupName -Name "MSPaint" -AppAlias paint
    New-RdsRemoteApp $WVDTenantName $HostPoolName $AppGroupName -Name "Chrome" -AppAlias googlechrome -FriendlyName "MSN" -CommandLineSetting Require -RequiredCommandLine "--allow-no-sandbox-job --disable-gpu https://www.msn.com"

    #Run the following cmdlet to grant users access to the RemoteApps in the app group:
    Add-RdsAppGroupUser $WVDTenantName $HostPoolNameApps $AppGroupName -UserPrincipalName willy@customdomain.net

#endregion