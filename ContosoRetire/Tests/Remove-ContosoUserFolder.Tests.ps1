Remove-Module ContosoRetire -ErrorAction SilentlyContinue
Import-Module "$PSScriptRoot\..\ContosoRetire\ContosoRetire.psd1"

InModuleScope ContosoRetire {
    Describe 'Remove-ContosoUserFolder' -Tag 'unit' {
        ### ARRANGE
        $MockUser1 = [PSCustomObject]@{
            SamAccountName = 'jane.doe'
            Department     = 'Executive'
        }
        $MockUser2 = [PSCustomObject]@{
            SamAccountName = 'max.mustermann'
            Department     = 'IT'
        }

        # Guard mocks
        Mock Compress-Archive
        Mock Remove-Item

        # Worker mocks
        Mock Compress-Archive -Verifiable -ParameterFilter {
            $Path -and $DestinationPath
        } -MockWith {
            'zip'
        }
        Mock Remove-Item -Verifiable -ParameterFilter {
            $Path -and $Recurse
        }

        ### ACT
        $Act1 = Remove-ContosoUserFolder -User $MockUser1
        $Act2 = Remove-ContosoUserFolder -User $MockUser2

        ### ASSERT
        It 'Calls all worker mocks' {
            Assert-VerifiableMock
        }
        
        It "Zips the executive's folder" {
            $Act1 | Should -Be 'zip'
        }

        It "Does not zip the folder otherwise" {
            $Act2 | Should -BeNullOrEmpty
        }
    } #Describe
} #InModuleScope
