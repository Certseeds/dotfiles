$script = {
    $userPath = "C:\Users\${env:USERNAME}"

    function HideDesktopIcons(){
        New-Item `
          -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" `
          -Force
        Set-ItemProperty `
          -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" `
          -Name "{2cc5ca98-6485-489a-920e-b3e88a6ccce3}" `
          -Value 1
    }
    function RemoveImageLibrary(){
        New-Item `
          -Path "HKCU:\Software\Classes\CLSID\{E88865EA-0E1C-4E20-9AA6-EDCD0212C87C}" `
          -Force
        Set-ItemProperty `
          -Path "HKCU:\Software\Classes\CLSID\{E88865EA-0E1C-4E20-9AA6-EDCD0212C87C}" `
          -Name "System.IsPinnedToNameSpaceTree" `
          -Value 0
    }
    function MsEdge(){
        New-Item `
          -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" `
          -Force
        
        New-Item `
          -Path "$userPath\scoop\persist\edge" `
          -ItemType Directory
        
        New-Item `
          -Path "$userPath\scoop\persist\edge\cache" `
          -ItemType Directory
        
        New-Item `
          -Path "$userPath\scoop\persist\edge\profiles" `
          -ItemType Directory
        
        Set-ItemProperty `
          -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" `
          -Name "DiskCacheDir" `
          -Value "$userPath\scoop\persist\edge\cache"
        
        Set-ItemProperty `
          -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" `
          -Name "DnsOverHttpsMode" `
          -Value "secure"
        
        Set-ItemProperty `
          -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" `
          -Name "DnsOverHttpsTemplates" `
          -Value "https://doh.pub/dns-query"
        
        Set-ItemProperty `
          -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" `
          -Name "UserDataDir" `
          -Value "$userPath\scoop\persist\edge\profiles"
        
        Set-ItemProperty `
          -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" `
          -Name "WebRtcLocalhostIpHandling" `
          -Value "disable_non_proxied_udp"
    }
    function disableNetworkSearch() {
        New-Item `
          -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" `
          -Force
        Set-ItemProperty `
          -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" `
          -Name "DisableSearchBoxSuggestions" `
          -Value 1
    }

    function main {
        HideDesktopIcons
        RemoveImageLibrary
        MsEdge
        disableNetworkSearch
    }

    main
}
Invoke-Command $script
