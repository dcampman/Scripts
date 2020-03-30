Connect-AzureAD

$upn = Read-Host "Please enter the user account to add"
$user = Get-AzureADUser -ObjectID $upn
$appID = Get-AzureADServicePrincipal -Filter "displayname eq 'Windows Virtual Desktop'"
$appRole = $appID.AppRoles | Where-Object {$_.DisplayName -eq "TenantCreator"}

New-AzureADUserAppRoleAssignment -ObjectId $user.ObjectId -PrincipalId $user.ObjectId -ResourceId $appID.ObjectId -Id $appRole.Id