$code = 
{
    # submit the host process RawUI interface and the execution context
    param($RawUi)

    do
    {
        # compose the time and date display
        $time = Get-Date -Format 'HH:mm:ss dddd MMMM d'
        # compose the title bar text
        $title = "Current Time: $time" 
        # output the information to the title bar of the host process
        $RawUI.WindowTitle = $title
        # wait a half second
        Start-Sleep -Milliseconds 500
    } while ($true)
}
$ps = [PowerShell]::Create()
$null = $ps.AddScript($code).AddArgument($host.UI.RawUI)
$handle = $ps.BeginInvoke() 
