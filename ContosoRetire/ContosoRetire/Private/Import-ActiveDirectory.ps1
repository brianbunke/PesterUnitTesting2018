# This function:
    # Imports the ActiveDirectory module
    # Casts the supplied $User object to validate [ADUser] type

function Import-ActiveDirectory {
    [CmdletBinding()]
    param (
        $User
    )

    If (-not (Get-Module ActiveDirectory)) {
        Import-Module ActiveDirectory -Verbose:$false | Out-Null
    }

    [Microsoft.ActiveDirectory.Management.ADUser]$User | Out-Null
}
