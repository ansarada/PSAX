$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"


Describe "Set-HostEntry" {

	Context "Host entry does not exist. Entries separated by tabs" {

		$HostsFile =  "TestDrive:\testHosts.txt";
		$NewHostEntry = "127.0.0.4`thostA`t# CommentA"
 
		$dummyHostsFile = @(
			"127.0.0.1`thost1`t# comment1",
			"127.0.0.2`thost2`t# comment2",
			"127.0.0.3`thost3`t# comment3"
		) -join "`n"

		New-Item $HostsFile -type file | Add-Content -Value $dummyHostsFile

		It "Should add the host entry. Leaves existing entries in the same order." {

			$Parameters = @{
				IpAddress = "127.0.0.4";
				Hostname = "hostA";
				Comment = "CommentA";
				HostsFile = $HostsFile;
			}

			Set-HostEntry @Parameters

			((Get-Content $HostsFile) -Contains $NewHostEntry) | Should be $true

			#check order
			$expectedHostsFile = @(
				"127.0.0.1`thost1`t# comment1",
				"127.0.0.2`thost2`t# comment2",
				"127.0.0.3`thost3`t# comment3",
				"127.0.0.4`thostA`t# CommentA"
			) -join "`r`n"

			$actualHostsFile = Get-Content $HostsFile | Out-String
			 
			$actualHostsFile | Should be ($expectedHostsFile + "`r`n")
		}

		Remove-Item $HostsFile

	}

	Context "Host entry does not exist. Entries separated by spaces" {

		$HostsFile =  "TestDrive:\testHosts.txt";
		$NewHostEntry = "127.0.0.4`thostA`t# CommentA"
 
		$dummyHostsFile = @(
			"127.0.0.1 host1  # comment1",
			"127.0.0.2   host2 # comment2",
			"127.0.0.3     host3   # comment3"
		) -join "`n"

		New-Item $HostsFile -type file | Add-Content -Value $dummyHostsFile

		It "Should add the host entry. Leaves existing entries in the same order." {

			$Parameters = @{
				IpAddress = "127.0.0.4";
				Hostname = "hostA";
				Comment = "CommentA";
				HostsFile = $HostsFile;
			}

			Set-HostEntry @Parameters

			((Get-Content $HostsFile) -Contains $NewHostEntry) | Should be $true

			#check order
			$expectedHostsFile = @(
				"127.0.0.1 host1  # comment1",
				"127.0.0.2   host2 # comment2",
				"127.0.0.3     host3   # comment3",
				"127.0.0.4`thostA`t# CommentA"
			) -join "`r`n"

			$actualHostsFile = Get-Content $HostsFile | Out-String
			 
			$actualHostsFile | Should be ($expectedHostsFile + "`r`n")
		}

		Remove-Item $HostsFile

	}

	Context "Host entry does not exist. Entries separated by tabs and spaces combination" {

		$HostsFile =  "TestDrive:\testHosts.txt";
		$NewHostEntry = "127.0.0.4`thostA`t# CommentA"
 
		$dummyHostsFile = @(
			"127.0.0.1`t host1`t  # comment1",
			"127.0.0.2   `thost2 `t#`t comment2",
			"127.0.0.3   `t  host3 `t  # comment3"
		) -join "`n"

		New-Item $HostsFile -type file | Add-Content -Value $dummyHostsFile

		It "Should add the host entry. Leaves existing entries in the same order." {

			$Parameters = @{
				IpAddress = "127.0.0.4";
				Hostname = "hostA";
				Comment = "CommentA";
				HostsFile = $HostsFile;
			}

			Set-HostEntry @Parameters

			((Get-Content $HostsFile) -Contains $NewHostEntry) | Should be $true

			#check order
			$expectedHostsFile = @(
				"127.0.0.1`t host1`t  # comment1",
				"127.0.0.2   `thost2 `t#`t comment2",
				"127.0.0.3   `t  host3 `t  # comment3",
				"127.0.0.4`thostA`t# CommentA"
			) -join "`r`n"

			$actualHostsFile = Get-Content $HostsFile | Out-String
			 
			$actualHostsFile | Should be ($expectedHostsFile + "`r`n")
		}

		Remove-Item $HostsFile

	}

	Context "Host entry does not exist. No comment provided. Entries separated by tabs" {

		$HostsFile =  "TestDrive:\testHosts.txt";
		$NewHostEntry = "127.0.0.4`thostA"
 
		$dummyHostsFile = @(
			"127.0.0.1`thost1`t# comment1",
			"127.0.0.2`thost2`t# comment2",
			"127.0.0.3`thost3`t# comment3"
		) -join "`n"

		New-Item $HostsFile -type file | Add-Content -Value $dummyHostsFile

		It "Should add the host entry. Leaves existing entries in the same order." {

			$Parameters = @{
				IpAddress = "127.0.0.4";
				Hostname = "hostA";
				HostsFile = $HostsFile;
			}

			Set-HostEntry @Parameters

			((Get-Content $HostsFile) -Contains $NewHostEntry) | Should be $true

			#check order
			$expectedHostsFile = @(
				"127.0.0.1`thost1`t# comment1",
				"127.0.0.2`thost2`t# comment2",
				"127.0.0.3`thost3`t# comment3",
				"127.0.0.4`thostA"
			) -join "`r`n"

			$actualHostsFile = Get-Content $HostsFile | Out-String
			 
			$actualHostsFile | Should be ($expectedHostsFile + "`r`n")
		}

		Remove-Item $HostsFile

	}

	Context "Host entry does not exist. No comment provided. Entries separated by spaces" {

		$HostsFile =  "TestDrive:\testHosts.txt";
		$NewHostEntry = "127.0.0.4`thostA"
 
		$dummyHostsFile = @(
			"127.0.0.1 host1  # comment1",
			"127.0.0.2   host2 # comment2",
			"127.0.0.3     host3   # comment3"
		) -join "`n"

		New-Item $HostsFile -type file | Add-Content -Value $dummyHostsFile

		It "Should add the host entry. Leaves existing entries in the same order." {

			$Parameters = @{
				IpAddress = "127.0.0.4";
				Hostname = "hostA";
				HostsFile = $HostsFile;
			}

			Set-HostEntry @Parameters

			((Get-Content $HostsFile) -Contains $NewHostEntry) | Should be $true

			#check order
			$expectedHostsFile = @(
				"127.0.0.1 host1  # comment1",
				"127.0.0.2   host2 # comment2",
				"127.0.0.3     host3   # comment3",
				"127.0.0.4`thostA"
			) -join "`r`n"

			$actualHostsFile = Get-Content $HostsFile | Out-String
			 
			$actualHostsFile | Should be ($expectedHostsFile + "`r`n")
		}

		Remove-Item $HostsFile

	}

	Context "Host entry does not exist. No comment provided. Entries separated by tabs and spaces combination" {

		$HostsFile =  "TestDrive:\testHosts.txt";
		$NewHostEntry = "127.0.0.4`thostA"
 
		$dummyHostsFile = @(
			"127.0.0.1`t host1`t  # comment1",
			"127.0.0.2   `thost2 `t#`t comment2",
			"127.0.0.3   `t  host3 `t  # comment3"
		) -join "`n"

		New-Item $HostsFile -type file | Add-Content -Value $dummyHostsFile

		It "Should add the host entry. Leaves existing entries in the same order." {

			$Parameters = @{
				IpAddress = "127.0.0.4";
				Hostname = "hostA";
				HostsFile = $HostsFile;
			}

			Set-HostEntry @Parameters

			((Get-Content $HostsFile) -Contains $NewHostEntry) | Should be $true

			#check order
			$expectedHostsFile = @(
				"127.0.0.1`t host1`t  # comment1",
				"127.0.0.2   `thost2 `t#`t comment2",
				"127.0.0.3   `t  host3 `t  # comment3",
				"127.0.0.4`thostA"
			) -join "`r`n"

			$actualHostsFile = Get-Content $HostsFile | Out-String
			 
			$actualHostsFile | Should be ($expectedHostsFile + "`r`n")
		}

		Remove-Item $HostsFile

	}

	Context "Host entry exists; Ip address is not the same as provided. Entries separate by tabs" {
	
		$HostsFile =  "TestDrive:\testHosts_tests.txt";
		$NewHostEntry = "127.0.0.9`thost2`t# comment2"

		$dummyHostsFile = @(
			"127.0.0.1`thost1`t# comment1",
			"127.0.0.2`thost2`t# comment2",
			"127.0.0.3`thost3`t# comment3"
		) -join "`n"

		New-Item $HostsFile -type file | Add-Content -Value $dummyHostsFile

		It "Should replace ip address in host entry with provided one. Leaves existing entries in the same order." {

			$Parameters = @{
				IpAddress = "127.0.0.9";
				Hostname = "host2";
				Comment = "comment2";
				HostsFile = $HostsFile;
			}

			Set-HostEntry @Parameters

			((Get-Content $HostsFile) -Contains $NewHostEntry) | Should be $true

			#check order
			$expectedHostsFile = @(
				"127.0.0.1`thost1`t# comment1",
				"127.0.0.9`thost2`t# comment2",
				"127.0.0.3`thost3`t# comment3"
			) -join "`r`n"

			$actualHostsFile = Get-Content $HostsFile | Out-String

			$actualHostsFile | Should be ($expectedHostsFile + "`r`n")

		}

		Remove-Item $HostsFile

	}

	Context "Host entry exists; Ip address is not the same as provided. Entries separate by spaces" {
	
		$HostsFile =  "TestDrive:\testHosts_tests.txt";
		$NewHostEntry = "127.0.0.9`thost2`t# comment2"

		$dummyHostsFile = @(
			"127.0.0.1 host1  # comment1",
			"127.0.0.2   host2 # comment2",
			"127.0.0.3     host3   # comment3"
		) -join "`n"

		New-Item $HostsFile -type file | Add-Content -Value $dummyHostsFile

		It "Should replace ip address in host entry with provided one. Leaves existing entries in the same order." {

			$Parameters = @{
				IpAddress = "127.0.0.9";
				Hostname = "host2";
				Comment = "comment2";
				HostsFile = $HostsFile;
			}

			Set-HostEntry @Parameters

			((Get-Content $HostsFile) -Contains $NewHostEntry) | Should be $true

			#check order
			$expectedHostsFile = @(
				"127.0.0.1 host1  # comment1",
				"127.0.0.9`thost2`t# comment2",
				"127.0.0.3     host3   # comment3"
			) -join "`r`n"

			$actualHostsFile = Get-Content $HostsFile | Out-String

			$actualHostsFile | Should be ($expectedHostsFile + "`r`n")

		}

		Remove-Item $HostsFile

	}

	Context "Host entry exists; Ip address is not the same as provided. Entries separated by tabs and spaces combination" {

		$HostsFile =  "TestDrive:\testHosts_tests.txt";
		$NewHostEntry = "127.0.0.9`thost2`t# comment2"

		$dummyHostsFile = @(
			"127.0.0.1`t host1`t  # comment1",
			"127.0.0.2   `thost2 `t#`t comment2",
			"127.0.0.3   `t  host3 `t  # comment3"
		) -join "`n"

		New-Item $HostsFile -type file | Add-Content -Value $dummyHostsFile

		It "Should replace ip address in host entry with provided one. Leaves existing entries in the same order." {

			$Parameters = @{
				IpAddress = "127.0.0.9";
				Hostname = "host2";
				Comment = "comment2";
				HostsFile = $HostsFile;
			}

			Set-HostEntry @Parameters

			((Get-Content $HostsFile) -Contains $NewHostEntry) | Should be $true

			#check order
			$expectedHostsFile = @(
				"127.0.0.1`t host1`t  # comment1",
				"127.0.0.9`thost2`t# comment2",
				"127.0.0.3   `t  host3 `t  # comment3"
			) -join "`r`n"

			$actualHostsFile = Get-Content $HostsFile | Out-String

			$actualHostsFile | Should be ($expectedHostsFile + "`r`n")

		}

		Remove-Item $HostsFile
	}

    Context "Host entry exists; Ip address is not the same as provided; comment is not provided. Entries separate by tabs" {
	
		$HostsFile =  "TestDrive:\testHosts_tests.txt";
		$NewHostEntry = "127.0.0.9`thost2"

		$dummyHostsFile = @(
			"127.0.0.1`thost1`t# comment1",
			"127.0.0.2`thost2`t# comment2",
			"127.0.0.3`thost3`t# comment3"
		) -join "`n"

		New-Item $HostsFile -type file | Add-Content -Value $dummyHostsFile

		It "Should replace ip address in host entry with provided one. Leaves existing entries in the same order." {

			$Parameters = @{
				IpAddress = "127.0.0.9";
				Hostname = "host2";
				HostsFile = $HostsFile;
			}

			Set-HostEntry @Parameters

			((Get-Content $HostsFile) -Contains $NewHostEntry) | Should be $true

			#check order
			$expectedHostsFile = @(
				"127.0.0.1`thost1`t# comment1",
				"127.0.0.9`thost2",
				"127.0.0.3`thost3`t# comment3"
			) -join "`r`n"

			$actualHostsFile = Get-Content $HostsFile | Out-String

			$actualHostsFile | Should be ($expectedHostsFile + "`r`n")

		}

		Remove-Item $HostsFile

	}

	Context "Host entry exists; Ip address is not the same as provided; comment is not provided. Entries separate by spaces" {
	
		$HostsFile =  "TestDrive:\testHosts_tests.txt";
		$NewHostEntry = "127.0.0.9`thost2"

		$dummyHostsFile = @(
			"127.0.0.1 host1  # comment1",
			"127.0.0.2   host2 # comment2",
			"127.0.0.3     host3   # comment3"
		) -join "`n"

		New-Item $HostsFile -type file | Add-Content -Value $dummyHostsFile

		It "Should replace ip address in host entry with provided one. Leaves existing entries in the same order." {

			$Parameters = @{
				IpAddress = "127.0.0.9";
				Hostname = "host2";
				HostsFile = $HostsFile;
			}

			Set-HostEntry @Parameters

			((Get-Content $HostsFile) -Contains $NewHostEntry) | Should be $true

			#check order
			$expectedHostsFile = @(
				"127.0.0.1 host1  # comment1",
				"127.0.0.9`thost2",
				"127.0.0.3     host3   # comment3"
			) -join "`r`n"

			$actualHostsFile = Get-Content $HostsFile | Out-String

			$actualHostsFile | Should be ($expectedHostsFile + "`r`n")

		}

		Remove-Item $HostsFile

	}

	Context "Host entry exists; Ip address is not the same as provided; comment is not provided. Entries separated by tabs and spaces combination" {

		$HostsFile =  "TestDrive:\testHosts_tests.txt";
		$NewHostEntry = "127.0.0.9`thost2"

		$dummyHostsFile = @(
			"127.0.0.1`t host1`t  # comment1",
			"127.0.0.2   `thost2 `t#`t comment2",
			"127.0.0.3   `t  host3 `t  # comment3"
		) -join "`n"

		New-Item $HostsFile -type file | Add-Content -Value $dummyHostsFile

		It "Should replace ip address in host entry with provided one. Leaves existing entries in the same order." {

			$Parameters = @{
				IpAddress = "127.0.0.9";
				Hostname = "host2";
				HostsFile = $HostsFile;
			}

			Set-HostEntry @Parameters

			((Get-Content $HostsFile) -Contains $NewHostEntry) | Should be $true

			#check order
			$expectedHostsFile = @(
				"127.0.0.1`t host1`t  # comment1",
				"127.0.0.9`thost2",
				"127.0.0.3   `t  host3 `t  # comment3"
			) -join "`r`n"

			$actualHostsFile = Get-Content $HostsFile | Out-String

			$actualHostsFile | Should be ($expectedHostsFile + "`r`n")

		}

		Remove-Item $HostsFile
	}

	Context "Host entry exists; Ip address is the same as provided; comment is not the same as provided. Entries separated by tabs" {

		$HostsFile =  "TestDrive:\testHosts.txt";
		$NewHostEntry = "127.0.0.1`thost1`t# Comment111"

		$dummyHostsFile = @(
			"127.0.0.1`thost1`t# comment1",
			"127.0.0.2`thost2`t# comment2",
			"127.0.0.3`thost3`t# comment3"
		) -join "`n"

		New-Item $HostsFile -type file | Add-Content -Value $dummyHostsFile

		It "Should replace the comment in host entry with the one provided. Leaves existing entries in the same order." {

			$Parameters = @{
				IpAddress = "127.0.0.1";
				Hostname = "host1";
				Comment = "Comment111";
				HostsFile = $HostsFile;
			}

			Set-HostEntry @Parameters

			((Get-Content $HostsFile) -Contains $NewHostEntry) | Should be $true

			#check for entry order
			$expectedHostsFile = @(
				"127.0.0.1`thost1`t# Comment111",
				"127.0.0.2`thost2`t# comment2",
				"127.0.0.3`thost3`t# comment3"
			) -join "`r`n"

			$actualHostsFile = Get-Content $HostsFile | Out-String
			 
			$actualHostsFile | Should be ($expectedHostsFile + "`r`n")

		}

		Remove-Item $HostsFile

	}

	Context "Host entry exists; Ip address is the same as provided; comment is not the same as provided. Entries separated by spaces" {

		$HostsFile =  "TestDrive:\testHosts.txt";
		$NewHostEntry = "127.0.0.1`thost1`t# Comment111"

		$dummyHostsFile = @(
			"127.0.0.1 host1  # comment1",
			"127.0.0.2   host2 # comment2",
			"127.0.0.3     host3   # comment3"
		) -join "`n"

		New-Item $HostsFile -type file | Add-Content -Value $dummyHostsFile

		It "Should replace the comment in host entry with the one provided. Leaves existing entries in the same order." {

			$Parameters = @{
				IpAddress = "127.0.0.1";
				Hostname = "host1";
				Comment = "Comment111";
				HostsFile = $HostsFile;
			}

			Set-HostEntry @Parameters

			((Get-Content $HostsFile) -Contains $NewHostEntry) | Should be $true

			#check for entry order
			$expectedHostsFile = @(
				"127.0.0.1`thost1`t# Comment111",
				"127.0.0.2   host2 # comment2",
				"127.0.0.3     host3   # comment3"
			) -join "`r`n"

			$actualHostsFile = Get-Content $HostsFile | Out-String
			 
			$actualHostsFile | Should be ($expectedHostsFile + "`r`n")

		}

		Remove-Item $HostsFile

	}

	Context "Host entry exists; Ip address is the same as provided; comment is not the same as provided. Entries separated by tabs and spaces combination" {

		$HostsFile =  "TestDrive:\testHosts.txt";
		$NewHostEntry = "127.0.0.1`thost1`t# Comment111"

		$dummyHostsFile = @(
			"127.0.0.1`t host1`t  # comment1",
			"127.0.0.2   `thost2 `t#`t comment2",
			"127.0.0.3   `t  host3 `t  # comment3"
		) -join "`n"

		New-Item $HostsFile -type file | Add-Content -Value $dummyHostsFile

		It "Should replace the comment in host entry with the one provided. Leaves existing entries in the same order." {

			$Parameters = @{
				IpAddress = "127.0.0.1";
				Hostname = "host1";
				Comment = "Comment111";
				HostsFile = $HostsFile;
			}

			Set-HostEntry @Parameters

			((Get-Content $HostsFile) -Contains $NewHostEntry) | Should be $true

			#check for entry order
			$expectedHostsFile = @(
				"127.0.0.1`thost1`t# Comment111",
			"127.0.0.2   `thost2 `t#`t comment2",
			"127.0.0.3   `t  host3 `t  # comment3"
			) -join "`r`n"

			$actualHostsFile = Get-Content $HostsFile | Out-String
			 
			$actualHostsFile | Should be ($expectedHostsFile + "`r`n")

		}

		Remove-Item $HostsFile

	}

	Context "Host entry exists; Ip address is the same as provided; comment does not exist. Entries separated by tabs" {

		$HostsFile =  "TestDrive:\testHosts.txt";
		$NewHostEntry = "127.0.0.1`thost1`t# Comment111"

		$dummyHostsFile = @(
			"127.0.0.1`thost1",
			"127.0.0.2`thost2`t# comment2",
			"127.0.0.3`thost3`t# comment3"
		) -join "`n"

		New-Item $HostsFile -type file | Add-Content -Value $dummyHostsFile

		It "Should add the comment to host entry with provided one. Leaves existing entries in the same order." {

			$Parameters = @{
				IpAddress = "127.0.0.1";
				Hostname = "host1";
				Comment = "Comment111";
				HostsFile = $HostsFile;
			}

			Set-HostEntry @Parameters

			((Get-Content $HostsFile) -Contains $NewHostEntry) | Should be $true

			#check for entry order
			$expectedHostsFile = @(
				"127.0.0.1`thost1`t# Comment111",
				"127.0.0.2`thost2`t# comment2",
				"127.0.0.3`thost3`t# comment3"
			) -join "`r`n"

			$actualHostsFile = Get-Content $HostsFile | Out-String
			 
			$actualHostsFile | Should be ($expectedHostsFile + "`r`n")

		}

		Remove-Item $HostsFile

	}

	Context "Host entry exists; Ip address is the same as provided; comment does not exist. Entries separated by spaces" {

		$HostsFile =  "TestDrive:\testHosts.txt";
		$NewHostEntry = "127.0.0.1`thost1`t# Comment111"

		$dummyHostsFile = @(
			"127.0.0.1 host1",
			"127.0.0.2   host2 # comment2",
			"127.0.0.3     host3   # comment3"
		) -join "`n"

		New-Item $HostsFile -type file | Add-Content -Value $dummyHostsFile

		It "Should add the comment to host entry with provided one. Leaves existing entries in the same order." {

			$Parameters = @{
				IpAddress = "127.0.0.1";
				Hostname = "host1";
				Comment = "Comment111";
				HostsFile = $HostsFile;
			}

			Set-HostEntry @Parameters

			((Get-Content $HostsFile) -Contains $NewHostEntry) | Should be $true

			#check for entry order
			$expectedHostsFile = @(
				"127.0.0.1`thost1`t# Comment111",
			    "127.0.0.2   host2 # comment2",
			    "127.0.0.3     host3   # comment3"
			) -join "`r`n"

			$actualHostsFile = Get-Content $HostsFile | Out-String
			 
			$actualHostsFile | Should be ($expectedHostsFile + "`r`n")

		}

		Remove-Item $HostsFile

	}

	Context "Host entry exists; Ip address is the same as provided; comment does not exist. Entries separated by tabs and spaces combination" {

		$HostsFile =  "TestDrive:\testHosts.txt";
		$NewHostEntry = "127.0.0.1`thost1`t# Comment111"

		$dummyHostsFile = @(
			"127.0.0.1`t host1`t ",
			"127.0.0.2   `thost2 `t#`t comment2",
			"127.0.0.3   `t  host3 `t  # comment3"
		) -join "`n"

		New-Item $HostsFile -type file | Add-Content -Value $dummyHostsFile

		It "Should add the comment to host entry with provided one. Leaves existing entries in the same order." {

			$Parameters = @{
				IpAddress = "127.0.0.1";
				Hostname = "host1";
				Comment = "Comment111";
				HostsFile = $HostsFile;
			}

			Set-HostEntry @Parameters

			((Get-Content $HostsFile) -Contains $NewHostEntry) | Should be $true

			#check for entry order
			$expectedHostsFile = @(
				"127.0.0.1`thost1`t# Comment111",
				"127.0.0.2   `thost2 `t#`t comment2",
				"127.0.0.3   `t  host3 `t  # comment3"
			) -join "`r`n"

			$actualHostsFile = Get-Content $HostsFile | Out-String
			 
			$actualHostsFile | Should be ($expectedHostsFile + "`r`n")

		}

		Remove-Item $HostsFile

	}

	Context "Host entry exists; Ip address is the same as provided; comment is the same as provided. Entries separated by tabs" {

		$HostsFile =  "TestDrive:\testHosts.txt";
		$NewHostEntry = "127.0.0.1`thost1`t# comment1"

		$dummyHostsFile = @(
			"127.0.0.1`thost1`t# comment1",
			"127.0.0.2`thost2`t# comment2",
			"127.0.0.3`thost3`t# comment3"
		) -join "`n"

		New-Item $HostsFile -type file | Add-Content -Value $dummyHostsFile

		It "Should leave the host entry, ip address and comment as is. Leaves existing entries in the same order." {

			$Parameters = @{
				IpAddress = "127.0.0.1";
				Hostname = "host1";
				Comment = "comment1";
				HostsFile = $HostsFile;
			}

			Set-HostEntry @Parameters

			((Get-Content $HostsFile) -Contains $NewHostEntry) | Should be $true

			#check for entry order
			$expectedHostsFile = @(
				"127.0.0.1`thost1`t# comment1",
				"127.0.0.2`thost2`t# comment2",
				"127.0.0.3`thost3`t# comment3"
			) -join "`r`n"

			$actualHostsFile = Get-Content $HostsFile | Out-String
			 
			$actualHostsFile | Should be ($expectedHostsFile + "`r`n")

		}

		Remove-Item $HostsFile

	}

	Context "Host entry exists; Ip address is the same as provided; comment is the same as provided. Entries separated by spaces" {

		$HostsFile =  "TestDrive:\testHosts.txt";
		$NewHostEntry = "127.0.0.1 host1  # comment1"

		$dummyHostsFile = @(
			"127.0.0.1 host1  # comment1",
			"127.0.0.2   host2 # comment2",
			"127.0.0.3     host3   # comment3"
		) -join "`n"

		New-Item $HostsFile -type file | Add-Content -Value $dummyHostsFile

		It "Should leave the host entry, ip address and comment as is. Leaves existing entries in the same order." {

			$Parameters = @{
				IpAddress = "127.0.0.1";
				Hostname = "host1";
				Comment = "comment1";
				HostsFile = $HostsFile;
			}

			Set-HostEntry @Parameters

			((Get-Content $HostsFile) -Contains $NewHostEntry) | Should be $true

			#check for entry order
			$expectedHostsFile = @(
				"127.0.0.1 host1  # comment1",
				"127.0.0.2   host2 # comment2",
				"127.0.0.3     host3   # comment3"
			) -join "`r`n"

			$actualHostsFile = Get-Content $HostsFile | Out-String
			 
			$actualHostsFile | Should be ($expectedHostsFile + "`r`n")

		}

		Remove-Item $HostsFile

	}

	Context "Host entry exists; Ip address is the same as provided; comment is the same as provided. Entries separated by tabs and spaces combination" {

		$HostsFile =  "TestDrive:\testHosts.txt";
		$NewHostEntry = "127.0.0.1`t host1`t  # comment1"

		$dummyHostsFile = @(
			"127.0.0.1`t host1`t  # comment1",
			"127.0.0.2   `thost2 `t#`t comment2",
			"127.0.0.3   `t  host3 `t  # comment3"
		) -join "`n"

		New-Item $HostsFile -type file | Add-Content -Value $dummyHostsFile

		It "Should leave the host entry, ip address and comment as is. Leaves existing entries in the same order." {

			$Parameters = @{
				IpAddress = "127.0.0.1";
				Hostname = "host1";
				Comment = "comment1";
				HostsFile = $HostsFile;
			}

			Set-HostEntry @Parameters

			((Get-Content $HostsFile) -Contains $NewHostEntry) | Should be $true

			#check for entry order
			$expectedHostsFile = @(
				"127.0.0.1`t host1`t  # comment1",
				"127.0.0.2   `thost2 `t#`t comment2",
				"127.0.0.3   `t  host3 `t  # comment3"
			) -join "`r`n"

			$actualHostsFile = Get-Content $HostsFile | Out-String
			 
			$actualHostsFile | Should be ($expectedHostsFile + "`r`n")

		}

		Remove-Item $HostsFile

	}

	Context "Host entry exists; Ip address is the same as provided; comment is not provided. Entries separated by tabs" {

		$HostsFile =  "TestDrive:\testHosts.txt";
		$NewHostEntry = "127.0.0.1`thost1"

		$dummyHostsFile = @(
			"127.0.0.1`thost1",
			"127.0.0.2`thost2`t# comment2",
			"127.0.0.3`thost3`t# comment3"
		) -join "`n"

		New-Item $HostsFile -type file | Add-Content -Value $dummyHostsFile

		It "Should leave the host entry, ip address and comment as is. Leaves existing entries in the same order." {

			$Parameters = @{
				IpAddress = "127.0.0.1";
				Hostname = "host1";
				HostsFile = $HostsFile;
			}

			Set-HostEntry @Parameters

			((Get-Content $HostsFile) -Contains $NewHostEntry) | Should be $true

			#check for entry order
			$expectedHostsFile = @(
				"127.0.0.1`thost1",
				"127.0.0.2`thost2`t# comment2",
				"127.0.0.3`thost3`t# comment3"
			) -join "`r`n"

			$actualHostsFile = Get-Content $HostsFile | Out-String
			 
			$actualHostsFile | Should be ($expectedHostsFile + "`r`n")

		}

		Remove-Item $HostsFile

	}
	
    Context "Host entry exists; Ip address is the same as provided; comment is not provided. Entries separated by spaces" {

		$HostsFile =  "TestDrive:\testHosts.txt";
		$NewHostEntry = "127.0.0.1 host1  "

		$dummyHostsFile = @(
			"127.0.0.1 host1  ",
			"127.0.0.2   host2 # comment2",
			"127.0.0.3     host3   # comment3"
		) -join "`n"

		New-Item $HostsFile -type file | Add-Content -Value $dummyHostsFile

		It "Should leave the host entry, ip address and comment as is. Leaves existing entries in the same order." {

			$Parameters = @{
				IpAddress = "127.0.0.1";
				Hostname = "host1";
				HostsFile = $HostsFile;
			}

			Set-HostEntry @Parameters

			((Get-Content $HostsFile) -Contains $NewHostEntry) | Should be $true

			#check for entry order
			$expectedHostsFile = @(
				"127.0.0.1 host1  ",
				"127.0.0.2   host2 # comment2",
				"127.0.0.3     host3   # comment3"
			) -join "`r`n"

			$actualHostsFile = Get-Content $HostsFile | Out-String
			 
			$actualHostsFile | Should be ($expectedHostsFile + "`r`n")

		}

		Remove-Item $HostsFile

	}

	Context "Host entry exists; Ip address is the same as provided; comment is not provided. Entries separated by tabs and spaces combination" {

		$HostsFile =  "TestDrive:\testHosts.txt";
		$NewHostEntry = "127.0.0.1`t host1`t  "

		$dummyHostsFile = @(
			"127.0.0.1`t host1`t  ",
			"127.0.0.2   `thost2 `t#`t comment2",
			"127.0.0.3   `t  host3 `t  # comment3"
		) -join "`n"

		New-Item $HostsFile -type file | Add-Content -Value $dummyHostsFile

		It "Should leave the host entry, ip address and comment as is. Leaves existing entries in the same order." {

			$Parameters = @{
				IpAddress = "127.0.0.1";
				Hostname = "host1";
				HostsFile = $HostsFile;
			}

			Set-HostEntry @Parameters

			((Get-Content $HostsFile) -Contains $NewHostEntry) | Should be $true

			#check for entry order
			$expectedHostsFile = @(
				"127.0.0.1`t host1`t  ",
				"127.0.0.2   `thost2 `t#`t comment2",
				"127.0.0.3   `t  host3 `t  # comment3"
			) -join "`r`n"

			$actualHostsFile = Get-Content $HostsFile | Out-String
			 
			$actualHostsFile | Should be ($expectedHostsFile + "`r`n")

		}

		Remove-Item $HostsFile

	}
}