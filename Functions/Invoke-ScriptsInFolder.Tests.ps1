$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Invoke-ScriptsInFolder" {

    Write-Host 'Creating Fake scripts for test'
    New-item -Path $TestDrive\001_test.ps1 -ItemType file
    New-item -Path $TestDrive\002_test.ps1 -ItemType file
    New-item -Path $TestDrive\empty -ItemType directory

    It  'Should Throw if folder path does not exist ' {
        {Invoke-ScriptsInFolder -FolderPath "$TestDrive\FakeFolder"} | Should Throw "Folder does not exist"
    }

    It 'Should Throw if no scripts in directory' {
        {Invoke-ScriptsInFolder -FolderPath "$TestDrive\empty"} | Should Throw "No scripts found in folder"
    }

    It 'Should Throw if folder is not a folder' {
        {Invoke-ScriptsInFolder -FolderPath "$TestDrive\001_test.ps1"} | Should Throw "FolderPath Is not a directory"
    }

    It 'Should be able to execute scripts' {
        Mock -CommandName Start-Process { return @{exitcode = 0} }
        Invoke-ScriptsInFolder -FolderPath "$TestDrive"
        Assert-MockCalled Start-Process 2
    }

    It 'Should throw if script exit 1' {
        Mock -CommandName Start-Process { return @{exitcode = 1} }
        { Invoke-ScriptsInFolder -FolderPath "$TestDrive" } | Should Throw
    }

    It 'Should throw if child script throws' {
        Mock -CommandName Start-Process { Throw 'random error' }
        { Invoke-ScriptsInFolder -FolderPath "$TestDrive" } | Should Throw 'random error'
    }
}
