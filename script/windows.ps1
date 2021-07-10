$script = {
    function main {
        $ABC=2323
        & .\git\windows.ps1
        & .\lang\windows.ps1
        & .\powsh\windows.ps1
    }
    main
}
#netsh winhttp set proxy 127.0.0.1:1080
Invoke-Command $script
