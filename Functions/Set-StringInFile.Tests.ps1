$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

write-host "$here\$sut"

Describe "Set-StringInFile" {
    Context "No required values tests"{
        It "No filePath provided should throw an error"{
            { Set-StringInFile -SearchString 'search' -replaceString 'replace' } | Should throw "filePath is mandatory"
        }
        It "No searchString provided should throw an error"{
            { Set-StringInFile -replaceString 'replace' -filePath 'C:\temp\test.txt' } | Should throw "searchString is mandatory"
        }
        It "No replaceString provided should throw an error"{
            { Set-StringInFile -searchString 'search' -filePath 'C:\temp\test.txt' } | Should throw "replaceString is mandatory"
        }
    }

    Context "Successful tests"{
        BeforeEach{
            $pesterSearchString = '[[replace_me]]'
            $pesterReplaceString = 'it works!'
        }
        
        It "will replace a string within a file"{
            "Hello ${pesterSearchString} World!" | Out-File TestDrive:\test.txt
            $expectedOutput = "Hello ${pesterReplaceString} World!"
            Set-StringInFile -SearchString $pesterSearchString -replaceString $pesterReplaceString -filePath TestDrive:\test.txt
            $fileContents = Get-Content -Path 'TestDrive:\test.txt'
            $fileContents | Should BeExactly $expectedOutput
        }
        
        It "will replace strings within a file"{
            "${pesterSearchString} Hello ${pesterSearchString} World! Testing ${pesterSearchString} again ${pesterSearchString}" | Out-File TestDrive:\test.txt
            $expectedOutput = "${pesterReplaceString} Hello ${pesterReplaceString} World! Testing ${pesterReplaceString} again ${pesterReplaceString}"            
            Set-StringInFile -SearchString $pesterSearchString -replaceString $pesterReplaceString -filePath TestDrive:\test.txt
            $fileContents = Get-Content -Path 'TestDrive:\test.txt'
            $fileContents | Should BeExactly $expectedOutput
        }
    }
    
    Context "Failed tests"{
        It "Throw if file does not exist exist"{
            $filePath = 'C:\tempasdjkfh\jsakdfiuyahsdfjk\9832q7ruidsahkjsdfa\sadhbnmsd\connection.txt'
            { Set-StringInFile -SearchString $pesterSearchString -replaceString $pesterReplaceString -filePath $filePath } | Should Throw
        }
    }
}
