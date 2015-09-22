Set-StrictMode -Version Latest
Import-Module PSAX

function Start-Log {

	[CmdletBinding()]

	param (
		[parameter(mandatory=$true,position=0)]
		[String]
		$LogDirPath,

		[parameter(mandatory=$true,position=1)]
		[String]
		$LogName,

		[parameter()]
		[Hashtable]
		$AddtionalLogData
	)

	process {

		Write-Verbose "Checking to see if log directory path $LogDirPath exists"
		if (Test-Path $LogDirPath) {
			Write-Verbose "Log directory path $LogDirPath exists"
		}
		else {
			Write-Verbose "Log directory path $LogDirPath does not exist, creating"
			Set-Path $LogDirPath
		}

		$Pid = [System.Diagnostics.Process]::GetCurrentProcess()
		$i = 0
		$LimitI = 1000

		do {
			$LogFilename = (@(
					$LogName,
					$(Get-Date -Format 'yyyyMMdd_hhmmss'),
					$Pid.Id,
					[Convert]::ToString($i).PadLeft([Convert]::ToString($LimitI).Length-1, '0')
				) -join '_') + '.log'
			$i++
		} while ($(Test-Path $(Join-Path $LogDirPath $LogFilename)) -and $i -le $LimitI)

		$LogPath = Join-Path $LogDirPath $LogFilename
		Write-Verbose "Log path set to $LogPath"

		if (Test-Path $LogPath) {
			throw "Unable to generate log path, last tried $LogPath"
		}
		else {
			$LogRecord = @{
				TimeStamp = $(Get-Date -Format 'F');
				Hostname = $env:ComputerName;
				Pid = $Pid.Id;
				Username = $env:Username;
				LogPath = $LogPath;
				LogData = @{
					Message = "Starting PSJsonLogger $LogPath";
				};
				AddtionalLogData = $AddtionalLogData
			}
			ConvertTo-Json $LogRecord -Compress | Out-File -FilePath $LogPath
		}

		return @{
			LogPath = $LogPath;
			AddtionalLogData = $AddtionalLogData
		}
	}
}
