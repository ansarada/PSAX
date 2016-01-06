Set-StrictMode -Version Latest

function Write-Log {

	[CmdletBinding()]

	param (
		[parameter(mandatory=$true,position=0)]
		[Hashtable]
		$Log,

		[parameter(mandatory=$true,position=1)]
		[Object]
		$LogData
	)

	process {

		$requiredKeys = @(
			'LogPath',
			'AddtionalLogData'
		)
		foreach ($key in $requiredKeys) {
			Write-Verbose "Checking to see if log parameter contains $key key"
			if ($Log.Keys -contains $key) {
				Write-Verbose "$key key found in Log parameter"
			}
			else {
				throw "Unable to find $key key in Log parameter, you need to pass in result of Start-Log"
			}
		}

		Write-Verbose "Checking to see if log file $($Log.LogPath) exists"
		if (Test-Path $Log.LogPath) {
			Write-Verbose "Found log file $($Log.LogPath)"
		}
		else {
			throw "Unable to find log file $($Log.LogPath)"
		}

		$pidId = [System.Diagnostics.Process]::GetCurrentProcess().Id

		$LogRecord = @{
			timeStamp = $(Get-Date -Format 'F');
			hostname = $env:ComputerName;
			pidId = $pidId;
			username = $env:Username;
			logPath = $Log.LogPath;
			logData = $LogData
		}
		if ($Log.AddtionalLogData -ne $null) {
				$LogRecord.Add('addtionalLogData', $Log.AddtionalLogData)
		}
		ConvertTo-Json $LogRecord -Compress -Depth 1000 | Out-File -FilePath $Log.LogPath -Append
	}
}
