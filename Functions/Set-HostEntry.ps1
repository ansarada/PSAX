<#

.SYNOPSIS
	Will create a new entry in the hosts file if it doesn't exist

.PARAMETER IpAddress
	Ip address of the entry

.PARAMETER Hostname
	Name of the host

.PARAMETER Comment
	Comment for the entry

.PARAMETER HostsFilePath
	Overrides the path for the hosts file. Used for testing purposes

	.EXAMPLE
	C:\PS> Set-HostEntry -IpAddress 127.0.0.1  -Hostname dataroom.ansarada.dev -Comment "Entry for the local dataroom"
#>
	
function Set-HostEntry {
	[CmdletBinding()]

	param(
		[parameter(Mandatory=$true)]
		[String]
		$IpAddress,

		[parameter(Mandatory=$true)]
		[String]
		$Hostname,

		[parameter(Mandatory=$false)]
		[String]
		$Comment,

		[parameter(Mandatory=$false)]
		[String]
		$HostsFile = "$env:windir\System32\drivers\etc\hosts"
	)

	$NewHostEntry = "$IPAddress`t$Hostname"
    
    if (-not [string]::IsNullOrEmpty($Comment)) {
        $NewHostEntry+= "`t# $Comment"
    }

    $MatchPattern = "$IpAddress\s+$Hostname"
    
    if (-not [string]::IsNullOrEmpty($Comment)) {
        $MatchPattern+= "\s+#\s*$Comment"
    }
	
	$ItemExists = $false;
	$ValueChanged = $false;
	$CommentChanged = $false;

	if ($PSBoundParameters['Debug']) {
		$DebugPreference = 'Continue'
	}

	if ((Get-Content $HostsFile) -match $MatchPattern) {
		Write-Debug "Item property $Path\$Name with value $Value already exists."
		return
	}
	
	if (Select-String $Hostname $HostsFile) {
		$ItemExists = $true

		if ([string]::IsNullOrEmpty((Select-String -pattern "$IPAddress\s*$Hostname" -path $HostsFile))) {
			$ValueChanged = $true
		}
		else {
			$CommentChanged = $true
		}
	}
	

	if($ItemExists -eq $false) {
		Write-Debug "Host file entry for `"$Hostname`" not found."
		Add-Content -Path $HostsFile -Value "$NewHostEntry"
	}
	else {
		if ($ItemExists -and $ValueChanged) {
			Write-Debug "Host file entry for `"$Hostname`" has wrong IP address."
		}
		else {
			Write-Debug "Host file entry for `"$Hostname`" is missing the correct comment."
		}

		(Get-Content $HostsFile) | 
			Foreach-Object {
				if ($_ -match $Hostname) {
					$NewHostEntry  
				}
				else {
					$_
				}
			} | Set-Content $HostsFile
	}
}
