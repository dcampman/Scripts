Import-Module AzureAD 

$Office365Username = ""
$Office365Password = ""

#Build credentials object 
$SecureOffice365AdminPassword = ConvertTo-SecureString -AsPlainText $Office365Password -Force 
$Office365Credentials  = New-Object System.Management.Automation.PSCredential $Office365Username, $SecureOffice365AdminPassword 
  
Connect-AzureAD -Credential $Office365Credentials

Get-AzureADUser -All:$true | Select-Object -Property UserPrincipalName -ExpandProperty UserPrincipalName | Export-Csv -Path c:\temp\users.csv