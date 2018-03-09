<#
        .DESCRIPTION
        This module will loop through and execute all scripts in a specified folder. The order will be alphanumeric

        .PARAMETER FolderPath
        The path of the folder containing the scripts

        .EXAMPLE
        Invoke-ScriptInFolder -FolderPath C:/Scripts
#>
Function Invoke-ScriptsInFolder
{
    [CmdletBinding()]
    param
    (
        [Parameter(mandatory)]
        [String] $FolderPath
    )

    Process {
        write-host "Looking for scripts in $FolderPath"
        if (!(Test-Path $FolderPath)){
          throw "Folder does not exist"
        }
        if (-not ((Get-Item $FolderPath) -is [System.IO.DirectoryInfo])){
            throw "FolderPath Is not a directory"
        }

        $scripts = @() + ("$($FolderPath)/*.ps1" | Resolve-Path | Sort-Object)
        if ($scripts.count -lt 1){
            throw "No scripts found in folder"
        }

        foreach($script in $scripts){
            Write-Host "Running script $($script.ProviderPath)";
            $proc = (Start-Process 'powershell.exe' -ArgumentList "-File `"$($script.ProviderPath)`"" -Wait -PassThru -NoNewWindow)
            if ($proc.exitcode -eq 0){
              Write-Host "Script at $($script.ProviderPath) has succeeded";
            }else{
              throw "Non 0 return code returned. Exitcode was: $($proc.exitcode)"
            }
        }
        Write-Host "All scripts in '$FolderPath' has finished executing"

    }
}
