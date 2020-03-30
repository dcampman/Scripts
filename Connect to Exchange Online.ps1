$Office365Username = "dcadmin@dcamp89.com"
$keypath = "c:\temp\SecureAADPassword.txt"

#Decypt the password and convert to secure string
$SecureOffice365AdminPassword = Unprotect-CmsMessage -To cn=$CertName -Path $keypath | ConvertTo-SecureString -AsPlainText -Force

#Build credentials object
$Office365Credentials  = New-Object System.Management.Automation.PSCredential $Office365Username, $SecureOffice365AdminPassword

#Remove all existing Powershell sessions 
Get-PSSession | Remove-PSSession

#Create remote Powershell session to Exchange online
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/PowerShell-LiveID?PSVersion=4.0 -Credential $Office365credentials -Authentication Basic –AllowRedirection

#Import the session 
Import-PSSession $Session -AllowClobber | Out-Null

*******
   #Script
*******

#Clean up session 
Get-PSSession | Remove-PSSession