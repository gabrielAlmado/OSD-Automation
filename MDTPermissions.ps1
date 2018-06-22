# Check for elevation
Write-Host "Checking for elevation"
 
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "Oupps, you need to run this script from an elevated PowerShell prompt!`nPlease start the PowerShell prompt as an Administrator and re-run the script."
    Write-Warning "Aborting script..."
    Break
}
 
# Configure NTFS Permissions for the MDT Build Lab deployment share
$DeploymentShareNTFS = "C:\DeploymentShare"
icacls $DeploymentShareNTFS /grant '"ALMADO\MDT":(OI)(CI)(RX)'
icacls $DeploymentShareNTFS /grant '"Administrators":(OI)(CI)(F)'
icacls $DeploymentShareNTFS /grant '"SYSTEM":(OI)(CI)(F)'
icacls "$DeploymentShareNTFS\Captures" /grant '"ALMADO\MDT":(OI)(CI)(M)'
 
# Configure Sharing Permissions for the MDT Build Lab deployment share
$DeploymentShare = "DeploymentShare$"
Grant-SmbShareAccess -Name $DeploymentShare -AccountName "EVERYONE" -AccessRight Change -Force
Revoke-SmbShareAccess -Name $DeploymentShare -AccountName "CREATOR OWNER" -Force