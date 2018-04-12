function Remove-ContosoUserFolder {
    [CmdletBinding()]
    param (
        # Should be [Microsoft.ActiveDirectory.Management.ADUser]
        [ValidateScript({
            $_.SamAccountName -and $_.Department
        })]
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        $User,

        [System.IO.DirectoryInfo]
        $Share = 'C:\UserFolders',

        [System.IO.DirectoryInfo]
        $ArchivePath = '\\contoso\archives'
    )

    $Username = $User.SamAccountName
    $Files    = "$Share\$Username"

    # If an executive, zip and archive the folder
    If ($User.Department -eq 'Executive') {
        Compress-Archive -Path $Files -DestinationPath "$ArchivePath\$Username"
    }

    # Remove the directory
    Remove-Item -Path $Files -Recurse
}
