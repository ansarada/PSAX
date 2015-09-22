Set-StrictMode -Version Latest

function Write-Log {

	[CmdletBinding()]

	param (
		[parameter(mandatory=$true,position=0)]
		[Hashtable]
		$Log,

		[parameter(mandatory=$true,position=1)]
		[String]
		$LogData
	)

	process {

		$RequiredKeys = @(
			'LogPath',
			'AddtionalLogData'
		)
		foreach ($Key in $RequiredKeys) {
			Write-Verbose "Checking to see if log parameter contains $Key key"
			if ($Log.Keys -contains $Key) {
				Write-Verbose "$Key key found in Log parameter"
			}
			else {
				throw "Unable to find $Key key in Log parameter, you need to pass in result of Start-Log"
			}
		}

		Write-Verbose "Checking to see if log file $($Log.LogPath) exists"
		if (Test-Path $Log.LogPath) {
			Write-Verbose "Found log file $($Log.LogPath)"
		}
		else {
			throw "Unable to find log file $($Log.LogPath)"
		}

		$Pid = [System.Diagnostics.Process]::GetCurrentProcess()

		$LogRecord = @{
			TimeStamp = $(Get-Date -Format 'F');
			Hostname = $env:ComputerName;
			Pid = $Pid.Id;
			Username = $env:Username;
			LogPath = $Log.LogPath;
			LogData = $LogData;
			AddtionalLogData = $Log.AddtionalLogData
		}
		ConvertTo-Json $LogRecord -Compress | Out-File -FilePath $Log.LogPath -Append
	}
}
