$script = {
    $userPath="C:\Users\${env:USERNAME}"
    function before(){
        cd git
    }
    
    function conf-git(){
        New-Item -Path $userPath"\.gitconfig" `
        -ItemType SymbolicLink `
        -Value $userPath"\dotfiles\git\.gitconfig" 
        # `~/.gitconfig`
        # `git config --list`
    }    
    
    function conf-ssh(){
        New-Item -Path $userPath"\.gitconfig" `
        -ItemType SymbolicLink `
        -Value $userPath"\dotfiles\git\.gitconfig" 
        # `~/.gitconfig`
        # `git config --list`
    }    
    function main {
        
    }
    function after(){
        cd ..
    }
    before
    main
    after
}
#netsh winhttp set proxy 127.0.0.1:1080
Invoke-Command $script
