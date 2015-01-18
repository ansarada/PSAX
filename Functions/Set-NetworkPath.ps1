<#

.SYNOPSIS
	Will create a shared network folder with an account if it doesn't exist

.PARAMETER Name
	Name of the share

.PARAMETER LocalPath
	The local path that will be shared

.PARAMETER Account
	The account for which the network path is being shared

.PARAMETER Permissions
	The permissions that the account will have on the network path. Possible values are: FullAccess, ReadAccess and NoAccess
	
.EXAMPLE
	C:\PS> Set-NetworkPath -Name 'NetworkPath' -LocalPath 'c:\temp' -Account 'comptName\administrator' -Permissions 'FullAccess'

#>

function Set-NetworkPath {
	[CmdletBinding()]

	param(
		[parameter(Mandatory=$true)]
		[String]
		$Name,
		
		[parameter(Mandatory=$true)]
		[String]
		$LocalPath,
		
		[parameter(Mandatory=$true)]
		[String]
		$Account,
		
		[parameter(Mandatory=$true)]
		[ValidateSet("FullAccess","ReadAccess","NoAccess")] 
		[String]
		$Permissions
	)
	
	if (GET-WMIOBJECT Win32_Share -Filter "name = '$Name'") {
		Write-Verbose "$Name is already shared"
	}
	else {
		Write-Verbose "Creating network path $Name"
		switch($permissions)
		{
			'FullAccess'{ New-SmbShare -Name $Name -Path $LocalPath -FullAccess $Account }
			'ReadOnly'  { New-SmbShare -Name $Name -Path $LocalPath -ReadAccess $Account }
			'NoAccess'  { New-SmbShare -Name $Name -Path $LocalPath -NoAccess $Account }
		}
		Write-Verbose "Finished creating network path $Name"
	}
}

