#requires -Version 3

    <#
            .DESCRIPTION
            This module will help install MSI files. It will check for correct permissions, install the application and capture any exception codes.

            .PARAMETER InstallerPath
            The full path of the MSI installation file. The parameter will be checked, if the file does not exist the script will terminate. e.g. 'C:\temp\install.msi'

            .PARAMETER ArgumentList	
            All of the native MSI arguments to be passed for installation as a string array e.g. -ArgumentList @('/L*v','C:\temp\install.log','/qn','NR_LICENSE_KEY=111111111111')
            
            .EXAMPLE
            Install-MSI -InstallerPath 'C:\temp\install.msi' -ArgumentList @('/L*v','C:\temp\install.log','/qn','NR_LICENSE_KEY=111111111111')
            Will install the MSI silently with the required arguments.

            .EXAMPLE
            Install-MSI -InstallerPath 'C:\temp\install.msi' -Verbose
            Will install the MSI with default settings and display verbose messaging.

    #>

Function Install-MSI
{
    [CmdletBinding()]
    param
    (
        [Parameter(mandatory)]
        [ValidateScript({
				Test-Path -LiteralPath $_ -PathType Leaf
        })]
        [ValidatePattern(
				'.msi'
        )]
        [String] $InstallerPath,

        [Parameter(mandatory)]
        [ValidateNotNullOrEmpty()]
        [String[]] $ArgumentList

    )


    Process {   
         
        Write-Verbose 'Checking the powershell has been run as Administrator'
             
        if(([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator'))
        {
            Write-Verbose 'Powershell running with Admin permissions. You shall pass.'
        }
        else 
        {
            Throw 'Powershell is not running with Admin permissions. Escalate permissions and try again.'
        }
                            
            
        Try 
        {
            Write-Verbose "Trying to install Application from $InstallerPath"
            $InstallProcess = (Start-Process $InstallerPath -ArgumentList $ArgumentList -Wait -PassThru)
            if ($InstallProcess.ExitCode -eq 0)
            {
                Write-Verbose -Message "$InstallerPath has been successfully installed according to exit code of 0"
            }
            else 
            {
                Throw "Installer exit code  $($InstallProcess.ExitCode) for file  $($InstallerPath)"
            }
        }
            
          
        Catch 
        {
            Throw "Installation failed due to: $_.exception" 
        }
         
    }
}
