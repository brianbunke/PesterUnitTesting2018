Remove-Module ContosoRetire -ErrorAction SilentlyContinue
Import-Module "$PSScriptRoot\..\ContosoRetire\ContosoRetire.psd1"

InModuleScope ContosoRetire {
    Describe 'Remove-ContosoUser2' -Tag 'unit' {
        ### ARRANGE
        $MockUser = [PSCustomObject]@{
            SamAccountName = 'jane.doe'
            Department     = 'Executive'
        }
        $MockCred = New-MockObject PSCredential

        # Guard mocks
        Mock Import-ActiveDirectory

        # If no AD, can't mock what doesn't exist
        # Create an empty Remove-ADUser function instead
        function Remove-ADUser ($Identity, $Credential) {}

        # Worker mocks
        Mock Remove-ADUser -Verifiable -ParameterFilter {
            $Identity -eq $MockUser.SamAccountName
        } -MockWith {
            'nocred'
        }
        Mock Remove-ADUser -Verifiable -ParameterFilter {
            $Identity   -eq $MockUser.SamAccountName -and
            $Credential -eq $MockCred
        } -MockWith {
            'cred'
        }

        ### ACT
        $Act1 = Remove-ContosoUser2 -User $MockUser
        $Act2 = Remove-ContosoUser2 -User $MockUser -Credential $MockCred

        ### ASSERT
        It 'Calls Remove-ADUser as expected' {
            Assert-VerifiableMock
        }
        
        It 'Passes credentials when appropriate' {
            $Act1 | Should -Be 'nocred'
            $Act2 | Should -Be 'cred'
        }
    } #Describe
} #InModuleScope
