#requires -Version 3 -Modules AWSPowerShell
#Requires -RunAsAdministrator

$currentDirectory = Split-Path -Parent $PSCommandPath
$sourceFile = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
. "$currentDirectory\$sourceFile"

Describe "Set-PathAccessRule" {

    $testPath = Join-Path $TestDrive 'somefile.txt'
    Set-Content $testPath -value "my test text."

    $fakeFilePaths = @($testPath)
    $fakeDirectoryPath = [System.IO.Path]::GetDirectoryName($testPath)
    $fakeFilePath = ''
    $emptyFilePaths = @('', '')
    $fakeArray = @('a', 'b', 'c')
    $fakehash =  @{"FullControl" = "Allow"}
    $Username = "unittestuser"

    Context "Testing parameters validation" {

        It "Passing mandatory parameter as null and empty should throw exception" {
            
            { Set-PathAccessRule -Path $null -Principles $null -Permissions $null } | Should Throw
            { Set-PathAccessRule -Path "" -Principles "" -Permissions "" } | Should Throw
            { $emptyFilePaths | Set-PathAccessRule -Principles $emptyFilePaths -Permissions $emptyFilePaths } | Should Throw
            { Set-PathAccessRule -Path $fakeFilePath -Principles $fakeArray -Permissions $fakehash } | Should Throw 

        }

        It "When passing a file path instead of a directory path, this method should return exception" {

            { Set-PathAccessRule -Path $testPath -Principles $fakeArray -Permissions $fakehash } | Should Throw

        }

        It "When Get-Acl returns exception this method should return exception" {

            Mock -CommandName Get-Acl -MockWith {throw} 

            { Set-PathAccessRule -Path $fakeDirectoryPath -Principles $fakeArray -Permissions $fakehash } | Should Throw

        }

        It "When Get-Acl returns null this method should return exception" {

            Mock -CommandName Get-Acl -MockWith {return $null} 

            { Set-PathAccessRule -Path $fakeDirectoryPath -Principles $fakeArray -Permissions $fakehash } | Should Throw

        }


    }
    

    Context "Passing real values and testing actual outputs" {

         BeforeEach {
            Write-Host "Real stuff context begin"
            $ADSIComp = [adsi]"WinNT://." 
            $NewUser = $ADSIComp.Create('User',$Username) 
            $NewUser.SetPassword("P@ssword1")
            $NewUser.setinfo()
        }

        AfterEach {
            Write-Host "Real stuff context ends"

            $ADSIComp = [adsi]"WinNT://."
            $ADSIComp.Delete('User',$Username) 
        }


        It "Passing all correct values and checking if the return value is as per expectation (not passing recursion switch)" {

            $OperationDetailInfo = Set-PathAccessRule -Path $fakeDirectoryPath -Principles $Username -Permissions $fakehash -PassThru
            $OperationDetailInfo.TopLevelACL | where {$_.IdentityReference -like "*$Username*"} | Should Not BeNullOrEmpty
            $OperationDetailInfo.RecursedOpeartionOutput | Should BeNullOrEmpty

        }

        It "Passing all correct values and checking if the return value is as per expectation (passing recursion switch)" {

            $OperationDetailInfo = Set-PathAccessRule -Path $fakeDirectoryPath -Principles $Username -Permissions $fakehash -PassThru -Recurse
            $OperationDetailInfo.TopLevelACL | where {$_.IdentityReference -like "*$Username*"} | Should Not BeNullOrEmpty
            $OperationDetailInfo.RecursedOpeartionOutput | Should Match "Successfully processed 1 files;"
            $OperationDetailInfo.RecursedOpeartionExitCode | Should Be 0

        }

        It "Passing all correct values and checking if passthru parameter is not supplied then the method should not throw exception" {

            {Set-PathAccessRule -Path $fakeDirectoryPath -Principles $Username -Permissions $fakehash} | Should Not throw

        }

        It "When Invoke-Process returns null function throws exception" {

            Mock -CommandName Invoke-Process -MockWith {return $null} 
            {Set-PathAccessRule -Path $fakeDirectoryPath -Principles $Username -Permissions $fakehash -Recurse} | Should throw "icacls returned null"

        }

        It "When Invoke-Process returns operation status which is unsuccessful function throws exception" {

            Mock -CommandName Invoke-Process -MockWith {return [hashtable]@{"ExitCode"="1"; "ErrorInfo"="Access denied"}} 
            {Set-PathAccessRule -Path $fakeDirectoryPath -Principles $Username -Permissions $fakehash -Recurse} | Should throw "icacls returned error. Error detail Access denied"

        }

    }

}