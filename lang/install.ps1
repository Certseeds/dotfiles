# it should be run in powershell with admin privilege
$script = {
    $userPath = "C:\Users\${env:USERNAME}"
    function main {
        uv --version
        uvx --version
        uvx dotbot `
            --verbose `
            --base-directory "$userPath\dotfiles\lang" `
            --config install.win.yaml
    }
    main
}
#netsh winhttp set proxy 127.0.0.1:1080
Invoke-Command $script
