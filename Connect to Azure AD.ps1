Import-Module AzureAD

#Constant Variables
$Office365Username = "dcadmin@dcamp89.com"
$CertName = "DavePSCert"
$keypath = "C:\temp\SecureAADPassword.txt"

#Decypt the password and convert to secure string
$SecureOffice365AdminPassword = Unprotect-CmsMessage -To cn=$CertName -Path $keypath | ConvertTo-SecureString -AsPlainText -Force

#Build credentials object
$Office365Credentials  = New-Object System.Management.Automation.PSCredential $Office365Username, $SecureOffice365AdminPassword

Connect-AzureAD -Credential $Office365Credentials

#******
   #script
#******