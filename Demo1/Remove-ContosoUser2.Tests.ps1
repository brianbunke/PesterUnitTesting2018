Describe 'Remove-ContosoUser' -Tag 'Unit' {
    ### ARRANGE
    . $PSScriptRoot\Remove-ContosoUser.ps1

    $User = 'ContosoTest'

    Mock 'Get-Item'      {'gi'} -Verifiable
    Mock 'Remove-Item'   {} -Verifiable
    Mock 'Remove-ADUser' {} -Verifiable

    ### ACT
    Remove-ContosoUser -Username $User

    ### ASSERT
    It 'Called all mocks' {
        Assert-VerifiableMock
    }
}
