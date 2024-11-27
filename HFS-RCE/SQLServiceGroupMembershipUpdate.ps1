# Define the username and group distinguished names (DNs)
$user = "SQLService"  # Replace with the actual username
$groups = @(
    "CN=Domain Admins,OU=Groups,DC=PROIT,DC=LOCAL",
    "CN=Enterprise Admins,OU=Groups,DC=PROIT,DC=LOCAL",
    "CN=Schema Admins,OU=Groups,DC=PROIT,DC=LOCAL",
    "CN=Administrators,CN=Builtin,DC=PROIT,DC=LOCAL"
)

# Import the Active Directory module (if not already imported)
Import-Module ActiveDirectory

# Remove the user from each group
foreach ($group in $groups) {
    try {
        Remove-ADGroupMember -Identity $group -Members $user -Confirm:$false | Out-Null
        #Write-Host "User $user has been removed from group : $group"
    } catch {
        Write-Host "Error removing user from group $group : $_"
    }
}

Write-Host "[+] Group membership updated."
