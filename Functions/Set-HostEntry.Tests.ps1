$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"


Describe "Set-HostEntry" {

	Context "Host entry does not exist." {

		$HostsFile =  "TestDrive:\testHosts.txt";
		$NewHostEntry = "127.0.0.4`thostA`t# CommentA"
 
		New-Item $HostsFile -type file
		Add-Content -Path $HostsFile -Value "127.0.0.1`thost1`t# comment1"
		Add-Content -Path $HostsFile -Value "127.0.0.2`thost2`t# comment2"
		Add-Content -Path $HostsFile -Value "127.0.0.3`thost3`t# comment3"

		It "Should add the host entry" {

			$Parameters = @{
				IpAddress = "127.0.0.4";
				Hostname = "hostA";
				Comment = "CommentA"; `
				HostsFilePath = $HostsFile;
			}

			Set-HostEntry @Parameters

			((Get-Content $HostsFile) -Contains $NewHostEntry) | Should be $true

		}

		Remove-Item $HostsFile
	}

	Context "Host entry exists; Ip address is not the same as provided." {
	
		$HostsFile =  "TestDrive:\testHosts.txt";
		$NewHostEntry = "127.0.0.9`thost1`t# Comment1"

		New-Item $HostsFile -type file
		Add-Content -Path $HostsFile -Value "127.0.0.1`thost1`t# comment1"
		Add-Content -Path $HostsFile -Value "127.0.0.2`thost2`t# comment2"
		Add-Content -Path $HostsFile -Value "127.0.0.3`thost3`t# comment3"

		It "Should replace ip address in host entry with provided one" {

			$Parameters = @{
				IpAddress = "127.0.0.9";
				Hostname = "host1";
				Comment = "Comment1"; `
				HostsFilePath = $HostsFile;
			}

			Set-HostEntry @Parameters

			((Get-Content $HostsFile) -Contains $NewHostEntry) | Should be $true

		}

		Remove-Item $HostsFile

	}

	Context "Host entry exists; Ip address is the same as provided; comment is not the same as provided" {

		$HostsFile =  "TestDrive:\testHosts.txt";
		$NewHostEntry = "127.0.0.1`thost1`t# Comment111"

		New-Item $HostsFile -type file
		Add-Content -Path $HostsFile -Value "127.0.0.1`thost1`t# comment1"
		Add-Content -Path $HostsFile -Value "127.0.0.2`thost2`t# comment2"
		Add-Content -Path $HostsFile -Value "127.0.0.3`thost3`t# comment3"

		It "Should replace the comment in host entry with the one provided." {

			$Parameters = @{
				IpAddress = "127.0.0.1";
				Hostname = "host1";
				Comment = "Comment111"; `
				HostsFilePath = $HostsFile;
			}

			Set-HostEntry @Parameters

			((Get-Content $HostsFile) -Contains $NewHostEntry) | Should be $true

		}

		Remove-Item $HostsFile

	}

	Context "Host entry exists; Ip address is the same as provided; comment does not exist" {

		$HostsFile =  "TestDrive:\testHosts.txt";
		$NewHostEntry = "127.0.0.1`thost1`t# Comment111"

		New-Item $HostsFile -type file
		Add-Content -Path $HostsFile -Value "127.0.0.1`thost1"
		Add-Content -Path $HostsFile -Value "127.0.0.2`thost2`t# comment2"
		Add-Content -Path $HostsFile -Value "127.0.0.3`thost3`t# comment3"

		It "Should add the comment to host entry with provided one." {

			$Parameters = @{
				IpAddress = "127.0.0.1";
				Hostname = "host1";
				Comment = "Comment111";
				HostsFilePath = $HostsFile;
			}

			Set-HostEntry @Parameters

			((Get-Content $HostsFile) -Contains $NewHostEntry) | Should be $true

		}

		Remove-Item $HostsFile

	}

	Context "Host entry exists; Ip address is the same as provided; comment is the same as provided" {

		$HostsFile =  "TestDrive:\testHosts.txt";
		$NewHostEntry = "127.0.0.1`thost1`t# comment1"

		New-Item $HostsFile -type file
		Add-Content -Path $HostsFile -Value "127.0.0.1`thost1`t# comment1"
		Add-Content -Path $HostsFile -Value "127.0.0.2`thost2`t# comment2"
		Add-Content -Path $HostsFile -Value "127.0.0.3`thost3`t# comment3"

		It "Should leave the host entry, ip address and comment as is." {

			$Parameters = @{
				IpAddress = "127.0.0.1";
				Hostname = "host1";
				Comment = "comment1";
				HostsFilePath = $HostsFile;
			}

			Set-HostEntry @Parameters

			((Get-Content $HostsFile) -Contains $NewHostEntry) | Should be $true

		}

		Remove-Item $HostsFile

	}
}