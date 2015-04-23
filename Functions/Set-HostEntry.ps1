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
		$HostsFilePath
    )
    
	if($HostsFilePath -eq $null) {
		$HostsFile =  "$env:windir\System32\drivers\etc\hosts";
	}
	else {
		$HostsFile = $HostsFilePath
	}
	
    $NewHostEntry = "$IPAddress`t$Hostname`t# $Comment";
	
    $ItemExists = $false;
    $ValueChanged = $false;
	$CommentChanged = $false;
    
	if ($PSBoundParameters['Debug']) {
		$DebugPreference = 'Continue'
	}

	if ((Get-Content $HostsFile) -Contains $NewHostEntry) {
		$ItemExists = $true
	}
	else {
		if (Select-String $Hostname $HostsFile) {
			$ItemExists = $true

			if (Select-String "$IPAddress`t$Hostname" $HostsFile) {
				$ValueChanged = $true
			}
			else {
				$CommentChanged = $true
			}
		}
	}

	if ($ItemExists -and $ValueChanged -eq $false -and $CommentChanged -eq $false) {
		Write-Debug "Item property $Path\$Name with value $Value already exists."
	}
	else {
		if($ItemExists -eq $false) {
			Write-Debug "Host file entry for `"$Hostname`" not found."
			Add-Content -Path $HostsFile -Value "$NewHostEntry"
		 }
		 elseif ($ItemExists -and $ValueChanged) {
			Write-Debug "Host file entry for `"$Hostname`" has wrong IP address."
			(Get-Content $HostsFile) -NotMatch $Hostname | Set-Content $HostsFile
				Add-Content -Path $HostsFile -Value "$NewHostEntry"

		 }
		 elseif ($ItemExists -and $ValueChanged -eq $false -and $CommentChanged) {
			Write-Debug "Host file entry for `"$Hostname`" is missing the correct comment."
			(Get-Content $HostsFile) -NotMatch $Hostname | Set-Content $HostsFile
				Add-Content -Path $HostsFile -Value "$NewHostEntry"
		 }

	}
}