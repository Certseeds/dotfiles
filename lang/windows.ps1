$script = {
    $userPath="C:\Users\${env:USERNAME}"
    function before(){
        cd lang
    }
    function conf-pip(){
        $folder="$userPath\pip"
        $T_F=(Test-Path $folder)
        if (!$T_F){
            mkdir $folder
        }
        New-Item -Path "$folder\pip.ini" `
        -ItemType SymbolicLink `
        -Value "$userPath\dotfiles\lang\pip.ini"
        # test by `pip config list -v`
    }
    function conf-mvn(){
        $folder="$userPath\.m2"
        $T_F=(Test-Path $folder)
        if (!$T_F){
            mkdir $folder
        }
        New-Item -Path "$folder\settings.xml" `
        -ItemType SymbolicLink `
        -Value "$userPath\dotfiles\lang\settings.xml" 
        # `~\.m2\settings.xml`
        # `mvn help:effective-settings`
    }
    function conf-gradle(){
        $folder="$userPath\.gradle"
        $T_F=(Test-Path $folder)
        if (!$T_F){
            mkdir $folder
        }
        New-Item -Path "$folder\init.gradle" `
        -ItemType SymbolicLink `
        -Value "$userPath\dotfiles\lang\init.gradle" 
        # `~\.gradle\init.gradlel`
    }
    function conf-conda(){
        New-Item -Path "$userPath\.condarc" `
        -ItemType SymbolicLink `
        -Value "$userPath\dotfiles\lang\.condarc" 
        # `conda config --show`
    } 
    function conf-cargo(){
        $folder="$userPath\.cargo"
        $T_F=(Test-Path $folder)
        if (!$T_F){
            mkdir $folder
        }
        New-Item -Path "$folder\config" `
        -ItemType SymbolicLink `
        -Value "$userPath\dotfiles\lang\cargo.config.toml" 
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
