#Requires -Module Microsoft.PowerShell.SecretManagement, Configuration

$public  = @( Get-ChildItem -Path $PSScriptRoot\public\*.ps1 -ErrorAction SilentlyContinue )
$private = @( Get-ChildItem -Path $PSScriptRoot\private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
foreach($import in @($public + $private))
{
    try
    {
        . $import.fullname
    }
    catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

$script:moduleConfig = Import-Configuration

# Check secret management vault, determine which will be used by default
if(!$script:moduleConfig.ContainsKey('VaultName')) {
    Write-Warning 'This module has not yet been configured with a specific SecretsManagement vault, using system default.  Use Set-OneLoginModuleDefaults to set this value.'
    $vault = Get-SecretVault | Where-Object IsDefault | Select-Object -ExpandProperty Name
    if(!$vault) {
        Write-Error 'No default vault defined for Microsoft.PowerShell.SecretManagement.  Please define at least one vault prior to using this module.'
    } else {
        $script:moduleConfig.VaultName = $vault
    }
}

Write-Verbose -Message ('Using "{0}" as the SecretManagment vault for OneLogin credentials' -f $script:moduleConfig.VaultName)

$vault = Get-SecretVault -Name $script:moduleConfig.VaultName
if(!$vault) {
    Write-Error ('The defined SecretManagement vault ("{0}") does not exist.  Please create it prior to using this module' -f $script:moduleConfig.VaultName)
}

$script:Connections = @{}

Export-ModuleMember -Function $public.BaseName

