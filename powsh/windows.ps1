$script = {
    $userPath = "C:\Users\${env:USERNAME}"
    $time = "$(Get-Date -Format 'yyyy-MM-dd-HH-mm-ss')"
    function before() {
        Set-Location powsh
    }

    function ensure_dir() {
        $Array = ("$userPath\dotfilesbackup", "$userPath\Documents\WindowsPowerShell")
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
        $Array = ("$userPath\Documents\WindowsPowerShell\Microsoft.Powershell_profile.ps1", "$userPath\Documents\WindowsPowerShell\Profile.ps1", "${env:PSHOME}\profile.ps1", "$userPath\Documents\PowerShell\Microsoft.Powershell_profile.ps1", "$userPath\Documents\PowerShell\Profile.ps1")
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
        conf-pwsh
    }
    function conf-pwsh() {
        $folder = "$userPath\Documents\WindowsPowerShell"
        New-Item -Path "${folder}\Microsoft.Powershell_profile.ps1" `
            -ItemType SymbolicLink `
            -Value $userPath"\dotfiles\powsh\profile.ps1"
        New-Item -Path "${folder}\Profile.ps1" `
            -ItemType SymbolicLink `
            -Value $userPath"\dotfiles\powsh\profile.ps1"
        # or in public loca `${PSHOME}\profile.ps1`
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
