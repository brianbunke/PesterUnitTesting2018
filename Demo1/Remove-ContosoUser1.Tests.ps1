#Requires -Modules ActiveDirectory

Describe 'Remove-ContosoUser' -Tag 'Integration' {
    ### ARRANGE
    . $PSScriptRoot\Remove-ContosoUser.ps1

    $User = 'ContosoTest'
    $UserFolders = 'C:\UserFolders'
    $Cred = Get-Credential
    
    # Create a user folder to act on
    New-Item -Path "$UserFolders\$User" -ItemType Directory
    New-Item -Path "$UserFolders\$User" -ItemType File      -Name 'test1.txt'
    New-Item -Path "$UserFolders\$User\Test" -ItemType Directory
    New-Item -Path "$UserFolders\$User\Test" -ItemType File -Name 'test2.txt'

    # Create an AD user object to act on
    New-ADUser $User -Credential $Cred

    ### ACT
    Remove-ContosoUser -Username $User -Credential $Cred
    $TestPath = Test-Path "$UserFolders\$User"

    ### ASSERT
    It 'Removed the user directory' {
        $TestPath | Should -Be $false
    }
    
    It 'Removed the user' {
        {Get-ADUser $User} | Should -Throw
    }
}
