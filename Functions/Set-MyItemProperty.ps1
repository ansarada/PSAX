<#

.SYNOPSIS
    Will create a new registry key if it doesn't exist

.PARAMETER Path
    Path of the key

.PARAMETER Name
    Name of the key

.PARAMETER Type
    Type of the key. Possible values are: String, Binary, DWord, ExpandString, MultiString, QWord

.PARAMETER Value
    Value of key

.EXAMPLE
    C:\PS> Set-MyItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\"  -Name "BackConnectionHostNames" -PropertyType "MultiString" -Value "documentprovider.ansarada.prod"

#>

function Set-MyItemProperty {
    [CmdletBinding()]

    param(
        [parameter(Mandatory=$true)]
        [String]
        $Path,

        [parameter(Mandatory=$true)]
        [String]
        $Name,

        [parameter(Mandatory=$true)]
        [ValidateSet("String", "Binary", "DWord", "ExpandString", "MultiString", "QWord")]
        [String]
        $Type,

        [parameter(Mandatory=$true)]
        [String]
        $Value
    )

    $ItemExists = $false;
    $ValueChanged = $false;

    If ($PSBoundParameters['Debug']) {
        $DebugPreference = 'Continue'
    }

    if (Test-Path $Path) {
        $Key = Get-Item -LiteralPath $Path
        $KeyVal = $Key.GetValue($Name, $null)

        if ($KeyVal -ne $null) {
            if($KeyVal -eq $Value) {
                 $ItemExists = $true
            }
            else {
                $ItemExists = $true
                $ValueChanged = $true
            }
        }
     }

     if ($ItemExists -and $ValueChanged -eq $false) {
        Write-Debug "Item property $Path\$Name with value $Value already exists."
     }
     elseif ($ItemExists -and $ValueChanged) {
        Set-ItemProperty -Path $Path -Name $Name -Type $Type -Value $Value
        Write-Debug "Item property $Path\$Name value was changed to $Value"
     }
     else {
        New-ItemProperty -Path $path  -Name $Name -Type $Type -Value $Value
     }
}
