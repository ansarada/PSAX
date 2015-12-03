<#

.SYNOPSIS
	Will set access rule of directory path if it does not exist, otherwise will do nothing

.PARAMETER Path
	The path to set the access rule

.PARAMETER PRINCIPLE
	The windows principle that the access rule applies to

.PARAMETER PERMISSIONS
	The hashtable that contains the file system right (eg: "FullControl", "Read") and access control (eg: "Allow", "Deny")

.PARAMETER INHERITANCEFLAGS
	The attribute value which indicate permission inheritance (eg: "ContainerInherit", "ObjectInherit" or "ContainerInherit,ObjectInherit" )

.PARAMETER PROPAGATIONFLAGS
    Specifies how Access Rule are propagated to child objects.

.EXAMPLE
	C:\PS> Set-PathAccessRule -Path 'SomePath' -Principle "SomeUser" -Permissions @{"FullControl" = "Allow"}

#>

function Set-PathAccessRule {
	param (
		[parameter(Mandatory=$true)]
		[String[]]
		$Paths,

        [parameter(Mandatory=$true)]
		[String[]]
        $Principles,

        [parameter(Mandatory=$true)]
		[Hashtable]
        $Permissions,

        [parameter()]
		[String[]]
        $InheritanceFlags = @(”ContainerInherit", "ObjectInherit”),

        [parameter()]
		[String[]]
        $PropagationFlags = @("None"),

        # Set if you want all child files or folders set too
        [Switch]
        $Recurse
	)

    [System.Security.AccessControl.InheritanceFlags]$InheritanceFlags = $InheritanceFlags -join ','

    foreach ($Path in $Paths) {

        $Acl = Get-Acl $Path

        foreach ($Principle in $Principles) {

            foreach ($FileSystemRight in $Permissions.Keys) {

                $AccessControl = $Permissions.Item($FileSystemRight)

                $Ar = New-Object  system.security.accesscontrol.filesystemaccessrule($Principle,$FileSystemRight,$InheritanceFlags,$PropagationFlags,$AccessControl)
                $Acl.SetAccessRule($Ar)
            }

            Set-Acl $Path $Acl
        }

        if ($Recurse) {
            Get-ChildItem $path | foreach {
                $parameters = @{
                    Path = $_;
                    $Principles = Principles;
                    $Permissions = $Permissions;
                    $InheritanceFlags = $InheritanceFlags;
                    $PropagationFlags = $PropagationFlags;
                    $Recurse = $true
                }
                Set-PathAccessRule @parameters
            }
        }
    }
}