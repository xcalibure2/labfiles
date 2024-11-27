# Define variables
$GPOName = "Test"                   				# The name of the GPO
$OUPath = "OU=2019,OU=Servers,DC=PROIT,DC=LOCAL"  	# The Distinguished Name (DN) of the target OU
$User = "PROIT\SQLService"

# Step 1: Create the GPO if it doesn't exist
($ExistingGPO = Get-GPO -Name $GPOName -ErrorAction SilentlyContinue) | Out-Null

if ($ExistingGPO -eq $null) {
    Write-Host "[*] Creating new GPO"
    ($GPO = New-GPO -Name $GPOName) | Out-Null
    #Write-Host "GPO $GPOName created successfully."
	Write-Host "[+] GPO created successfully."
} else {
    Write-Host "[*] GPO already exists."
    ($GPO = $ExistingGPO) | Out-Null
}

# Link the GPO to the OU
New-GPLink -Name $GPOName -Target $OUPath -LinkEnabled Yes -ErrorAction SilentlyContinue| Out-Null
#Write-Host "GPO $GPOName successfully linked to OU $OUPath."
Write-Host "[+] GPO successfully linked."

# Define the target GPO
($GPO = Get-GPO -Name $GPOName) | Out-Null

# Define the user/group and permissions
$Permission = "GPOEdit" # Options: "GPOEdit", "GPORead", "GPOLink"

# Set the permission
(Set-GPPermission -Name $GPO.DisplayName -TargetName $User -TargetType User -PermissionLevel $Permission) | Out-Null

