Set-StrictMode -Version Latest

<#

.SYNOPSIS
    Set access rule of directory path. It also allows to override and propagate all child items of this path.

.EXAMPLE
    if only one particular path needs ACL modification use the function the following way:
    C:\PS> Set-PathAccessRule -Path 'SomePath' -Principles "someUserName" -Permissions @{"FullControl" = "Allow"}

.EXAMPLE
    if one particular path needs ACL modification, and that ACL need to be replicated into all child objects of that path then
    use the function the following way:

    C:\PS> Set-PathAccessRule -Path 'SomePath' -Principles "someUserName" -Permissions @{"FullControl" = "Allow"} -Recurse

.EXAMPLE
    if you want to get the response of the entire opeartion then use the function the following way:

    C:\PS> $response = Set-PathAccessRule -Path 'SomePath' -Principles "someUserName" -Permissions @{"FullControl" = "Allow"} -Recurse -PassThru
    $response.TopLevelACL <- returns actual ACL object of the location specified in Path variable
    $response.RecursedOpeartionExitCode <- returns recursion operation's (of ACL replication) exit code
    $response.RecursedOpeartionOutput <- returns recursion operation's (of ACL replication) Standard output details
    $response.RecursedOpeartionError <- returns recursion operation's (of ACL replication) Standard error details

#>
function Set-PathAccessRule {
    [CmdletBinding( PositionalBinding = $false )]
    param
    (
        # Directory path to set the access rule
        [parameter(Mandatory=$true, ValueFromPipeline=$True)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ ((Get-Item $_) -is [System.IO.DirectoryInfo])  })]
        [string]
        $Path,

        # The windows principle that the access rule applies to. Can be a string or string array
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Principles,

        # The hashtable that contains the file system right (eg: "FullControl", "Read") and access control (eg: "Allow", "Deny")
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [Hashtable]
        $Permissions,

        # The attribute value which indicate permission inheritance (eg: "ContainerInherit", "ObjectInherit" or "ContainerInherit,ObjectInherit" )
        # Can be single or array of string values
        [parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('ContainerInherit','ObjectInherit','None')]
        [String[]]
        $InheritanceFlags = @('ContainerInherit', 'ObjectInherit'),

        # Specifies how Access Rule are propagated to child objects. Can be single or array of string values
        [parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('InheritOnly', 'NoPropagateInherit', 'None')]
        [String[]]
        $PropagationFlags = @('None'),

        # Instructs this method to apply all child objects to have same ACL as the top level path, specified in Path variable.
        [Switch]
        $Recurse,

        # Returns an object representing full ACL of the path. By default, this cmdlet does not generate any output.
        [Switch]
        $PassThru
    )

     Process {

        [System.Security.AccessControl.InheritanceFlags]$InheritanceFlags = $InheritanceFlags -join ','
        $returnValue = @{"RecursedOpeartionExitCode"=""; "RecursedOpeartionOutput"=""; "RecursedOpeartionError"=""; "TopLevelACL"=""}

        $acl = Get-Acl -Path $Path

        if (! $acl)
        {
            throw "acl detail of $Path is null"
        }

        $Principles | foreach {

            $currentPrinciple = $_

            foreach ($FileSystemRight in $Permissions.Keys) {

                $AccessControl = $Permissions.Item($FileSystemRight)

                $Ar = New-Object  system.security.accesscontrol.filesystemaccessrule($currentPrinciple,$FileSystemRight,$InheritanceFlags,$PropagationFlags,$AccessControl)
                $acl.SetAccessRule($Ar)
            }

            Set-Acl -Path $Path -AclObject $acl

            if ($Recurse)
            {

                $arguments = """$Path\*"" /q /t /reset"

                $executedProcess = Invoke-Process -ApplicationName "icacls" -Argument $arguments

                if (!$executedProcess)
                {
                    throw "icacls returned null."
                }

                if ($executedProcess.ExitCode -ne 0)
                {
                    [string] $errorMessage = $executedProcess.ErrorInfo

                    throw "icacls returned error. Error detail $errorMessage"
                }

                $returnValue.Set_Item("RecursedOpeartionExitCode", $executedProcess.ExitCode)
                $returnValue.Set_Item("RecursedOpeartionOutput", $executedProcess.OutputInfo)
                $returnValue.Set_Item("RecursedOpeartionError", $executedProcess.ErrorInfo)

            }

            if ($PassThru) {

                $completeACL = Get-Acl -Path $Path

                $returnValue.Set_Item("TopLevelACL", $completeACL.Access)

                return $returnValue
            }

        }

    }
}

<#

.SYNOPSIS
    Executes a process and returns process outputs

.EXAMPLE
    C:\PS> Invoke-Process -ApplicationName "SomeApplication.exe" -Argument "/?"

.OUTPUTS
    A hash table that contains 3 set of information. They are: ExitCode, OutputInfo, ErrorInfo

#>
function Invoke-Process {
    [CmdletBinding( PositionalBinding = $false )]
    [OutputType([hashtable])]
param
    (
        # The application name or application full path
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ApplicationName,

        # Arguments related to the application execution
        [string]
        $Argument
    )

    $processInfo = New-Object System.Diagnostics.ProcessStartInfo
    $processInfo.FileName = $ApplicationName
    $processInfo.RedirectStandardError = $true
    $processInfo.RedirectStandardOutput = $true
    $processInfo.UseShellExecute = $false
    $processInfo.Arguments = $Argument
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $processInfo
    $process.Start() | Out-Null
    $process.WaitForExit()


    return [hashtable]@{"ExitCode" = $process.ExitCode; "OutputInfo"=$process.StandardOutput.ReadToEnd(); "ErrorInfo"=$process.StandardError.ReadToEnd()}

}
