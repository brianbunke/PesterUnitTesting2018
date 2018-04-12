Describe 'Mock Pipeline' -Tag 'Unit' {
    ### ARRANGE
    . $PSScriptRoot\Services.ps1

    $script:svc = 0

    # Guard mocks
    Mock Stop-Service
    Mock Start-Service

    # Worker mocks
    Mock Stop-Service -ParameterFilter {$Name -eq 1} -MockWith {
        $script:svc++
    }
    Mock Stop-Service -ParameterFilter {$Name -eq 2} -MockWith {
        If ($script:svc -eq 1) {
            $script:svc++
        }
    }

    Mock Start-Service -ParameterFilter {$Name -eq 2} -MockWith {
        If ($script:svc -eq 2) {
            $script:svc++
        }
    }
    Mock Start-Service -ParameterFilter {$Name -eq 1} -MockWith {
        If ($script:svc -eq 3) {
            $script:svc++
        }
    }

    ### ACT
    Restart-ContosoService

    ### ASSERT
    It 'Called commands in order' {
        $script:svc |
            Should -Be 4 -Because 'Service actions must be performed in order'
    }
}
