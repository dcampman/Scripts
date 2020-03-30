$psVer = $host.Version
if($psVer.Major -lt 5)
{
    Write-Host -ForegroundColor Red "You are currently running PowerShell version: $psVer"
    Write-Host -ForegroundColor Red "PowerShell version 5 or greater is required for this script to run.  Please upgrade!"
    exit
}