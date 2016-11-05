Set-StrictMode -Version Latest

function Set-StringInFile {
    <#
.SYNOPSIS
Replaces a string within a file

.PARAMETER searchString
The string to search within the file

.PARAMETER replaceString
The replacement string for the above searchString

.PARAMETER filePath
The file you wish to replace

.PARAMETER fileOutputEncoding
The encoding of the file

.EXAMPLE
Set-StringInFile -SearchString '[[replace_me]]' -replaceString 'password1234!' -filePath 'C:\inetpub\wwwroot\ServiceHost\Web.config' -fileOutputEncoding utf8
#>
    [CmdletBinding(PositionalBinding = $false)]
    param (
        [parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $searchString = $(throw "searchString is mandatory, please provide a value"),

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [string]        
        $replaceString = $(throw "replaceString is mandatory, please provide a value"),

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $filePath = $(throw "filePath is mandatory, please provide a value"),

        [parameter()]        
        [string]
        $fileOutputEncoding = 'utf8'
    )
    
    process{
        (Get-Content $filePath).Replace($searchString, $replaceString) | Out-File $filePath -Encoding $fileOutputEncoding -Force
    }
}