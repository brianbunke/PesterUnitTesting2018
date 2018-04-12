function Remove-ContosoUser1 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Username,

        [PSCredential]$Credential
    )

    # Query AD for user's department
    $AD    = Get-ADUser $Username -Properties Department

    $Files = Get-Item "C:\UserFolders\$Username"

    # If an executive, zip and archive the folder
    If ($AD.Department -eq 'Executive') {
        Compress-Archive $Files "\\contoso\archives\$Username"
    }

    # Remove the directory
    $Files | Remove-Item -Recurse

    # Remove the user
    If ($Credential) {
        Remove-ADUser $Username -Confirm:$false -Credential $Credential
    } Else {
        Remove-ADUser $Username -Confirm:$false
    }
}
