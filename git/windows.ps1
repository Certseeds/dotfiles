$script = {
    $userPath = "C:\Users\${env:USERNAME}"
    $time = "$(Get-Date -Format 'yyyy-MM-dd-HH-mm-ss')"
    function before() {
        Set-Location git
    }
    function ensure_dir() {
        $Array = ("$userPath\.ssh", "$userPath\dotfilesbackup")
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
        $Array = ("$userPath\.gitconfig", "$userPath\.ssh\config")
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
        conf-git
        conf-ssh
    }
    function conf-git() {
        New-Item -Path "$userPath\.gitconfig" `
            -ItemType SymbolicLink `
            -Value "$userPath\dotfiles\git\.gitconfig"
        # `~/.gitconfig`
        # `git config --list`
    }

    function conf-ssh() {
        $folder = "$userPath\.ssh"
        $T_F = (Test-Path $folder)
        if (!$T_F) {
            mkdir $folder
        }
        New-Item -Path $folder"\config" `
            -ItemType SymbolicLink `
            -Value $userPath"\dotfiles\git\.ssh.config"
        # `~/.gitconfig`
        # `git config --list`
    }
    function main {
        ensure_dir
        backup_exists_file
        conf
    }
    function after() {
        cd ..
    }
    before
    main
    after
}
#netsh winhttp set proxy 127.0.0.1:1080
Invoke-Command $script
