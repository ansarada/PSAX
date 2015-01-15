<#

.SYNOPSIS
	Will create a local account if it doesn't exist

.PARAMETER Username
	The username of the account to create if it doesn't exist

.PARAMETER Password
	The password of the local account to create

.EXAMPLE
	C:\PS> Create-LocalUser -UserName 'MyLocalAccount' -Password 'MyPassword'

#>

function Create-LocalUser {
	[CmdletBinding()]

	param(
		[parameter(Mandatory=$true)]
		[String]
		$UserName,
		
		[parameter(Mandatory=$true)]
		[String]
		$Password
	)
	
	if ([ADSI]::Exists("WinNT://$env:computername/$UserName"))
	{
		Write-Verbose "User $UserName already exists."
	}
	else
	{
		Write-Verbose "Creating local user $UserName"

		$comp = [adsi] "WinNT://$env:computername"
		$user = $comp.Create("User", $UserName)   
		$user.SetPassword($Password)
		$user.SetInfo()

		Write-Verbose "Finished creating local user $UserName"
	}
}

