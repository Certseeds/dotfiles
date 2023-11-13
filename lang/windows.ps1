$script = {
    $userPath = "C:\Users\${env:USERNAME}"
    $time = "$(Get-Date -Format 'yyyy-MM-dd-HH-mm-ss')"
    function before() {
        Set-Location lang
    }
    function ensure_dir() {
        $Array = ("$userPath\dotfilesbackup", "$userPath\pip", "$userPath\.m2", "$userPath\.gradle", "$userPath\.gradle", "$userPath\.cargo", "$userPath\.vim", "$userPath\.vim\backupdir", "$userPath\.vim\swapdir", "$userPath\.vim\undodir", "$userPath\.gnupg", "$userPath\scoop\buckets")
        foreach ($folder in $Array) {
            $T_F = (Test-Path -Path ${folder})
            if (!$T_F) {
                mkdir ${folder}
                Write-Output "${folder} create success"
            }
            else {
                Write-Output "${folder} exists"
            }
        }
    }
    function backup_exists_file() {
        mkdir "${userPath}\dotfilesbackup\${time}"
        $Array = ("$userPath\pip\pip.ini", "$userPath\.m2\settings.xml", "$userPath\.gradle\init.gradle", "$userPath\.condarc", "$userPath\.cargo\config", "$userPath\.vimrc", "$userPath\.gnupg\gpg.conf")
        foreach ($file in $Array) {
            Write-Output ${file}
            $T_F = (Test-Path -Path ${file} -PathType Leaf)
            if ($T_F) {
                Move-Item -Path "${file}" -Destination "${userPath}\dotfilesbackup\${time}"
                Write-Output "mv ${file} to '${userPath}\dotfilesbackup\${time}'"
            }
            else {
                Write-Output "${file} do not exists"
            }
        }
    }
    function conf() {
        conf-gpg
        conf-pip
        conf-mvn
        conf-gradle
        conf-conda
        conf-cargo
        conf-vim
        conf-scoop-update
        conf-firefox
    }
    function conf-gpg() {
        $folder = "$userPath\.gnupg"
        New-Item -Path "$folder\gpg.conf" `
            -ItemType SymbolicLink `
            -Value "$userPath\dotfiles\lang\gpg.conf"
        # test by `pip config list -v`
    }
    function conf-pip() {
        $folder = "$userPath\pip"
        New-Item -Path "$folder\pip.ini" `
            -ItemType SymbolicLink `
            -Value "$userPath\dotfiles\lang\pip.conf"
        # test by `pip config list -v`
    }
    function conf-mvn() {
        $folder = "$userPath\.m2"
        New-Item -Path "$folder\settings.xml" `
            -ItemType SymbolicLink `
            -Value "$userPath\dotfiles\lang\settings.xml"
        # `~\.m2\settings.xml`
        # `mvn help:effective-settings`
    }
    function conf-gradle() {
        $folder = "$userPath\.gradle"
        New-Item -Path "$folder\init.gradle" `
            -ItemType SymbolicLink `
            -Value "$userPath\dotfiles\lang\init.gradle"
        # `~\.gradle\init.gradlel`
    }
    function conf-conda() {
        New-Item -Path "$userPath\.condarc" `
            -ItemType SymbolicLink `
            -Value "$userPath\dotfiles\lang\.condarc"
        # `conda config --show`
    }
    function conf-cargo() {
        $folder = "$userPath\.cargo"
        New-Item -Path "$folder\config" `
            -ItemType SymbolicLink `
            -Value "$userPath\dotfiles\lang\cargo.config.toml"
    }
    function conf-vim() {
        $folder = "$userPath"
        New-Item -Path "$folder\.vimrc" `
            -ItemType SymbolicLink `
            -Value "$userPath\dotfiles\lang\.vimrc"
    }
    function conf-scoop-update() {
        $folder = "$userPath"
        New-Item -Path "$folder\scoop\buckets\scoop.sh" `
            -ItemType SymbolicLink `
            -Value "$userPath\dotfiles\lang\scoop.sh"
    }
    function conf-firefox() {
        $folder = "$userPath\scoop\persist\firefox"
        New-Item -Path "$folder\profile\user.js" `
            -ItemType SymbolicLink `
            -Value "$userPath\dotfiles\lang\firefox.user.js"
        New-Item -Path "$folder\distribution\policies.json" `
            -ItemType SymbolicLink `
            -Value "$userPath\dotfiles\lang\firefox.policies.json"
    }
    function main {
        ensure_dir
        backup_exists_file
        conf
    }
    function after() {
        Set-Location ..
    }
    before
    main
    after
}
#netsh winhttp set proxy 127.0.0.1:1080
Invoke-Command $script
