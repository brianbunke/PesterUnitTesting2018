function Remove-ContosoUser {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Username,

        [PSCredential]$Credential
    )

    # Remove the directory
    Get-Item "C:\UserFolders\$Username" | Remove-Item -Recurse

    # Remove the user
    If ($Credential) {
        Remove-ADUser $Username -Confirm:$false -Credential $Credential
    } Else {
        Remove-ADUser $Username -Confirm:$false
    }
}
