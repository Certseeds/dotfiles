$script = {
    $userPath = "C:\Users\${env:USERNAME}"
    $time = "$(Get-Date -Format 'yyyy-MM-dd-HH-mm-ss')"
    function before() {
        Set-Location lang
    }
    function ensure_dir() {
        $Array = ("$userPath")
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
        $Array = ("$userPath\.wslconfig")
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
        conf-wslconfig
    }
    function conf-wslconfig() {
        New-Item -Path "$userPath\.wslconfig" `
            -ItemType SymbolicLink `
            -Value "$userPath\dotfiles\wsl\.wslconfig"
    }
    function main() {
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
