function Set-OneLoginConnectionDefaults {
    [CmdletBinding(PositionalBinding=$false)]
    Param(
        [ValidateSet('us','eu')]
        [Parameter(Mandatory=$false)]
        [string]$Region

    )
    End {

    }
}