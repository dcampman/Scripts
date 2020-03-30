

#--------------------Install Windows Virtual Desktop Agent--------------------#
#Download the Windows Virtual Desktop Agent: https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RWrmXv
#Right-click the downloaded installer, select Properties, select Unblock, then select OK. This will allow your system to trust the installer.
#Run the installer. When the installer asks you for the registration token, enter the value you got from the Export-RdsRegistrationInfo cmdlet.




#--------------------Install the Windows Virtual Desktop Agent Bootloader--------------------#
#Download the Windows Virtual Desktop Agent Bootloader: https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RWrxrH
#Right-click the downloaded installer, select Properties, select Unblock, then select OK. This will allow your system to trust the installer.
#Run the installer.




#--------------------License all RDSH after they are created--------------------#
$vm = Get-AzVM -ResourceGroup <resourceGroupName> -Name <vmName>
$vm.LicenseType = "Windows_Client"
Update-AzVM -ResourceGroupName <resourceGroupName> -VM $vm