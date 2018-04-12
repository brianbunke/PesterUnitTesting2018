function Restart-ContosoService {
    [CmdletBinding()]
    param ()

    Stop-Service -Name 1
    Stop-Service -Name 2

    Start-Service -Name 2
    Start-Service -Name 1
}
