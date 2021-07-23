Import-Module PSReadLine # version 2.1+
Import-Module posh-git # scoop install posh-git

Set-PSReadLineOption -PredictionSource History
Set-PSReadlineKeyHandler -Key Tab -Function Complete # 自动补全
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete # 自动补全
Set-PSReadlineKeyHandler -Key "Ctrl+d" -Function MenuComplete # 自动补全
Set-PSReadlineKeyHandler -Key "Ctrl+z" -Function Undo # 自动补全
# Set-PSReadlineKeyHandler -Key "Ctrl+c" -Function Undo # 自动补全
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackWard # 自动补全
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward # 自动补全

Invoke-Expression (oh-my-posh --init --shell pwsh --config ~/dotfiles/powsh/.poshtheme.json)
# dont forget to set the windows-terminal's default font to SauceCodePro NF

# name it as `Microsoft.PowerShell_profile.ps1` or `profile.ps1`