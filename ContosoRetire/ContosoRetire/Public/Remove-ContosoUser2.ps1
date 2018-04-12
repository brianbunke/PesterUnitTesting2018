function Remove-ContosoUser2 {
    [CmdletBinding()]
    param (
        # Should be [Microsoft.ActiveDirectory.Management.ADUser]
        [ValidateScript({$_.SamAccountName})]
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        $User,

        [PSCredential]$Credential
    )

    # You can isolate dependencies (ActiveDirectory) to private functions
    # ActiveDirectory will load when needed, not on ContosoRetire module import
    Import-ActiveDirectory -User $User

    # Remove the AD user object
    If ($Credential) {
        Remove-ADUser -Identity $User.SamAccountName -Confirm:$false -Credential $Credential
    } Else {
        Remove-ADUser -Identity $User.SamAccountName -Confirm:$false
    }
}
