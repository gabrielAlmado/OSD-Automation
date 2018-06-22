<#
.Synopsis
    Script for OSD AUTOMATION
.DESCRIPTION
    Script for OSD AUTOMATION
.EXAMPLE
    .\MDT-DeploymentSharePath-Permissions.ps1 -DSPath "C:\Build-and-Capture-DS" -DeploymentSharePath "Build-and-Capture-DS$"
.NOTES
    Created:	 2018-06-22
    Version:	 1.0

    Author - Gabriel Kisielewski
    Twitter: @GabrielJKisiel
    Blog   : http://almado.pl/blog

    Disclaimer:
    This script is provided "AS IS" with no warranties, confers no rights and
    is not supported by the authors.
.LINK
    http://almado.pl/blog
#>

[cmdletbinding(SupportsShouldProcess=$True)]
Param (
    [Parameter(Mandatory=$True,Position=0,HelpMessage="Proszę, podaj pełną ścieżkę do Deployment Share dla katalogu na dysku. Np.: C:\DeploymentShare")]
    $DSPath,

    [Parameter(Mandatory=$True,Position=1,HelpMessage="Proszę, podaj nazwę udziału sieciowego do Deployment Share. Np.: DeploymentShare$")]
    $DeploymentSharePath
)

# Check for elevation
Write-Host "Checking for elevation"

If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "Ups, uruchom ten skrypt z podniesionymi uprawnieniami!`nProszę uruchom PowerShell jako Administrator i ponownie wykonaj skrypt."
    Write-Warning "Przerywanie działania skryptu..."
    Break
}

# Configure NTFS Permissions for the MDT Build Lab deployment share
icacls $DSPath /grant '"ALMADO\MDT":(OI)(CI)(RX)'
icacls $DSPath /grant '"Administrators":(OI)(CI)(F)'
icacls $DSPath /grant '"SYSTEM":(OI)(CI)(F)'
icacls "$DSPath\Captures" /grant '"ALMADO\MDT":(OI)(CI)(M)'

# Configure Sharing Permissions for the MDT Build Lab deployment share
Grant-SmbShareAccess -Name $DeploymentSharePath -AccountName "EVERYONE" -AccessRight Change -Force
Revoke-SmbShareAccess -Name $DeploymentSharePathPath -AccountName "CREATOR OWNER" -Force
