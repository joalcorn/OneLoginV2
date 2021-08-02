function Set-OLModuleDefaults {
    [CmdletBinding(PositionalBinding=$false)]
    Param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory=$false)]
        [string]$VaultName,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory=$false)]
        [string]$DefaultCredentialName
    )
    End {
        if($SecretVaultName) {
            $vault = Get-SecretVault -Name $SecretVaultName
            if(!$vault) {
                Write-Warning ('Unable to find registered vault with name "{0}", setting will not be saved' -f $SecretVaultName)
            } else {
                $script:moduleConfig.DefaultVaultName = $SecretVaultName
            }
        }

        if($DefaultCredentialName) {
            $script:moduleConfig.DefaultCredentialName = $DefaultCredentialName
            $secret = Get-SecretInfo -Vault $script:moduleConfig.SecretVaultName -Name $script:moduleConfig.DefaultCredentialName -ErrorAction SilentlyContinue
            if(!$secret) {
                Write-Warning ('Unable to find a secret with name "{0}".  Please remember to create it')
            }
        }

        $script:moduleConfig | Export-Configuration -Scope User
    }
}