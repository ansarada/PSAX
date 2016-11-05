$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe "Set-Path" {
    Context "no existing directories" {

        BeforeEach {
            $CurrentLocation = Get-Location
            Set-Location "TestDrive:\"
            Remove-Item Test* -Force -Recurse
        }

        AfterEach {
            Set-Location $CurrentLocation
        }

        It "Should create single level directory" {
            Set-Path 'Test'
            {Test-Path 'Test' } | Should be $true
        }

        It "Should create nested directories" {
            Set-Path 'Test1\Test2'
            {Test-Path 'Test1\Test2' } | Should be $true
        }

        It "Should not worry about trailing slash" {
            Set-Path 'Test1\Test2\'
            {Test-Path 'Test1\Test2' } | Should be $true
        }

        It "Should accept an empty array via the pipe" {
            @() | Set-Path
        }

        It "Should accept 1 item via the pipe" {
            'Test' | Set-Path
            {Test-Path 'Test' } | Should be $true
        }

        It "Should accept 1 item via the pipe" {
            $Paths = @(
                'Test10',
                'Test20\Test21',
                'Test30\Test31\',
                'Test40\Test41',
                'Test40\Test42\'
            )
            $Paths | Set-Path
            {Test-Path 'Test10' } | Should be $true
            {Test-Path 'Test20\Test21' } | Should be $true
            {Test-Path 'Test30\Test31' } | Should be $true
            {Test-Path 'Test40\Test41' } | Should be $true
            {Test-Path 'Test40\Test42' } | Should be $true
        }
    }


    Context "existing directories" {

        BeforeEach {
            $CurrentLocation = Get-Location
            Set-Location "TestDrive:\"
            Remove-Item Test* -Force -Recurse
            New-Item -Type directory 'Test1'
            New-Item -Type directory 'Test20\Test21'
        }

        AfterEach {
            Set-Location $CurrentLocation
        }

        It "Should leave single level directory" {
            Set-Path 'Test1'
            {Test-Path 'Test1' } | Should be $true
        }

        It "Should create nested directories" {
            Set-Path 'Test1\Test2'
            {Test-Path 'Test1\Test2' } | Should be $true
        }

        It "Should leave nested directories" {
            Set-Path 'Test20\Test21'
            {Test-Path 'Test20\Test21' } | Should be $true
        }
    }
}
