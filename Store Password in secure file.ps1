$CertName = "PSCert"

#New-SelfSignedCertificate -DnsName $CertName -CertStoreLocation "Cert:\LocalMachine\My" -KeyUsage KeyEncipherment,DataEncipherment, KeyAgreement -Type DocumentEncryptionCert

$Keypath = "c:\temp\SecureAADPassword.txt"
$Password = Read-host "Please enter your password"

$password | Protect-CmsMessage -To cn=$CertName -OutFile $Keypath