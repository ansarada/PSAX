$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Install-MSI" {

    Write-Host 'Creating Fake installers for test'
    New-item -Path $TestDrive\Realinstaller.msi -ItemType file
    New-item -Path $TestDrive\Realinstaller.exe -ItemType file


    It  'Should Throw if installer path does not exist ' {
        {install-msi -installerpath "$TestDrive\FakeInstaller.msi" -ArgumentList 'test'} | Should Throw
    }

    It 'Should Throw if installer not an MSI' {
        {install-msi -installerpath "$TestDrive\RealInstaller.exe" -ArgumentList 'test'} | Should Throw
    }

    It 'Should Not Throw if Installation exit code = 0' {
        Mock -CommandName Start-Process -MockWith {return [pscustomobject]@{"exitcode" = "0"}}
        {install-msi -installerpath "$TestDrive\RealInstaller.msi"-argumentlist 'test'} | Should not throw
    }

    It 'Should Throw if Exit code = anything but 0' {
        Mock -CommandName Start-Process -MockWith {return [pscustomobject]@{"exitcode" = "1633"}}
        {install-msi -installerpath 'C:\Windows' -argumentlist 'test'} | Should throw
    }

}
