Import-Module Microsoft.RDInfra.RDPowershell
Add-RdsAccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com"

Login-AzAccount

$aadTenantId = "88ee6237-7316-4e1f-be01-8f2fda4025a1"
$subscriptionId = "c8de4c1d-e88a-4c41-869b-1d67caf99542"
$tenantName = "dcamp89-WVD-Tenant"
$hostPoolName = "dcamp89-Hostpool1"
$recurrenceInterval = "15"
$beginPeakTime = "8:00"
$endPeakTime = "18:00"
$timeDifference = "+5:00"
$sessionThresholdPerCPU = "2”
$minimumNumberOfRdsh = "1"
$limitSecondsToForceLogOffUser = "300"
$logOffMessageTitle = "Logoff Messege”
$logOffMessageBody = "YOU BETER SAVE YOUR WORK”
$location = “Central US”
$connectionAssetName = "AzureRunAsConnection"
$webHookURI = "https://s25events.azure-automation.net/webhooks?token=UZR9qOonBAMvJt5AR9Bbpd3%2byE%2fCNOH9UUN5OfG976g%3d"
$automationAccountName = "Dcamp89Automation"
$maintenanceTagName = "test"

Invoke-WebRequest -Uri “https://raw.githubusercontent.com/Azure/RDS-Templates/master/wvd-templates/wvd-scaling-script/createazureautomationaccount.ps1" -OutFile “.\createazureautomationaccount.ps1”
Invoke-WebRequest -Uri “https://raw.githubusercontent.com/Azure/RDS-Templates/master/wvd-templates/wvd-scaling-script/createazurelogicapp.ps1" -OutFile “.\createazurelogicapp.ps1”

.\createazureautomationaccount.ps1 -SubscriptionID  $subscriptionId  -ResourceGroupName "WVD-Infra"  –AutomationAccountName "Dcamp89Automation" -Location "Central US" 

New-RdsRoleAssignment -RoleDefinitionName "RDS Contributor" -ApplicationId "5ad24c8b-498d-4ee5-a089-54c5d322b3de" -TenantName "dcamp89-WVD-Tenant"

.\createazurelogicapp.ps1 -ResourceGroupName “WVD-Infra” -AADTenantID $aadTenantId -SubscriptionID $subscriptionId -TenantName $tenantName -HostPoolName $hostPoolName -RecurrenceInterval $recurrenceInterval -BeginPeakTime $beginPeakTime -EndPeakTime $endPeakTime -TimeDifference $timeDifference -SessionThresholdPerCPU $sessionThresholdPerCPU -MinimumNumberOfRDSH $minimumNumberOfRdsh -LimitSecondsToForceLogOffUser $limitSecondsToForceLogOffUser -LogOffMessageTitle $logOffMessageTitle -LogOffMessageBody $logOffMessageBody -Location $location -ConnectionAssetName $connectionAssetName -WebHookURI $webHookURI -AutomationAccountName $automationAccountName -MaintenanceTagName $maintenanceTagName  
