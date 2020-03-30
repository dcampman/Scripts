Install-Module -name Microsoft.RDInfra.RDPowerShell
Import-Module -name Microsoft.RDinfra.rdpowershell

add-rdsaccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com"

# Set name of AAD group you'll be using:
$GroupName="AzureADGroup"
# Provide WVD Tenant Name:
$TenantName="WVD Tenant Name"
# Provide HostPool Name
$HostPoolName="WVD HostPool Name"
# Provide App Group Name
$AppGroupName="Desktop Application Group"
# Add or Remove access?
$Action="Add/Remove"

Connect-AzureAD

$GroupObjectID=Get-AzADGroup -Searchstring $GroupName
$GroupMembers= Get-AzureADGroupMember -objectid $GroupObjectID.Id -All 1

If ($Action -eq "add")
{
    ForEach ($member in $GroupMembers.UserPrincipalName) 
    {
        Add-RdsAppGroupUser -TenantName $TenantName -HostPoolName $HostPoolName -AppGroupName $AppGroupName -UserPrincipalName $member
    }
    $RDSAppGroupUsersList=get-rdsappgroupuser -TenantName $tenantname -HostPoolName $hostpoolname -AppGroupName $AppGroupName
}

If ($Action -eq "remove")
{
    ForEach ($member in $GroupMembers.UserPrincipalName)
    {
        Remove-RdsAppGroupUser -TenantName $TenantName -HostPoolName $HostPoolName -AppGroupName $AppGroupName -UserPrincipalName $member
    }
    $RDSAppGroupUsersList=get-rdsappgroupuser -TenantName $tenantname -HostPoolName $hostpoolname -AppGroupName $AppGroupName
}
