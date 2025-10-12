$script = {
    $userPath = "C:\Users\${env:USERNAME}"
    function main {
        uv --version
        uvx --version
        sudo uvx dotbot `
            --verbose `
            --base-directory "$userPath\dotfiles\git" `
            --config install.conf.yaml
    }
    main
}
#netsh winhttp set proxy 127.0.0.1:1080
Invoke-Command $script
