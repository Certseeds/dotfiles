$script = {
    $userPath="C:\Users\${env:USERNAME}"
    function before(){
        cd powsh
    }
    
    function conf-pwsh(){
        $folder="$userPath\My Documents\PowerShell"
        $T_F=(Test-Path $folder)
        if (!$T_F){
            mkdir $folder
        }
        New-Item -Path "${folder}\Microsoft.Powershell_profile.ps1" `
        -ItemType SymbolicLink `
        -Value $userPath"\dotfiles\powsh\profile.ps1" 
        # or in public loca `${PSHOME}\profile.ps1`
    }

    function main {
        conf-pwsh
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
