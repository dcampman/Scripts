Import-Module AzureAD

Connect-AzureAD

$ADUsers = Get-AzureADUser | Where {$_.DirSyncEnabled -eq $true} | Select -Property UserPrincipalName

foreach ($user in $ADUsers)
{
    Remove-AzureADUser -ObjectId $user.UserPrincipalName
    Write-Host "Removing User: $user.UserPrincipalName"
}