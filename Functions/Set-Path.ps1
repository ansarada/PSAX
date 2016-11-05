<#

.SYNOPSIS
    Will create directory path if it does not exist, otherwise will do nothing

.PARAMETER Path
    The set of paths to create if they don't exist

.INPUTS
    The set of paths to create if they don't exist

.EXAMPLE
    C:\PS> Set-Path 'SomePath'

.EXAMPLE
    C:\PS> $Paths = @('SomePath', 'SomeOtherPath')
    C:\PS> $Paths | Set-Path

#>

function Set-Path {
    [CmdletBinding()]

    param (
        [parameter(ValueFromPipeline=$true,Mandatory=$true)]
        [String[]]
        $Path
    )

    process {

        $Parent = Split-Path $Path -Parent
        $Leaf = Split-Path $Path -Leaf
        if (-not [string]::IsNullOrEmpty($Parent)) {
            Set-Path $Parent
        }

        if (Test-Path $Path) {
            Write-Verbose "$Path exists, skipping"
        }
        else {
            Write-Verbose "Creating $Path"
            $result = New-Item -Type directory $Path
        }
    }
}
