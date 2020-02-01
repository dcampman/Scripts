#Get some information about this Host
$ComputerProperties = [Ordered]@{
ComputerOS = (Get-WMIObject win32_operatingsystem).caption
ComputerArch = (Get-WmiObject Win32_OperatingSystem).OSArchitecture
ComputerName = (Get-WmiObject Win32_OperatingSystem).CSName
CPUName = (Get-WMIObject win32_processor).name
CPUSpeed = [math]::Round((Get-WMIObject win32_processor).maxclockspeed/1000,2)
CPUCores = (Get-WMIObject win32_processor).numberofcores
CPUThreads = (Get-WMIObject win32_processor).numberoflogicalprocessors
FreeMem = [math]::Round((Get-WMIObject win32_operatingsystem).FreePhysicalMemory/1048576,2)
TotalMem = [math]::Round((Get-WMIObject win32_operatingsystem).TotalVisibleMemorySize/1048576,2)
DateTime = (Get-Date).ToString('MM/dd/yyyy hh:mm:ss tt')
}

$PCobject = New-Object PSObject -Property $ComputerProperties | ConvertTo-Json | Out-File "c:\temp\ServerSpecs.json"
