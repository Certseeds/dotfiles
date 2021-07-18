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
        $folder="$userPath\.ssh"
        $T_F=(Test-Path $folder)
        if (!$T_F){
            mkdir $folder
        }
        New-Item -Path $folder"\config" `
        -ItemType SymbolicLink `
        -Value $userPath"\dotfiles\git\.ssh.config" 
        # `~/.gitconfig`
        # `git config --list`
    }    
    function main {
        conf-git
        conf-ssh
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
