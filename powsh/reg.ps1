$script = {
  $userPath = "C:\Users\${env:USERNAME}"

  function HideDesktopIcons() {
    # 创建注册表项
    reg.exe add `
      "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" `
      /f
    # 设置属性
    reg.exe add `
      "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" `
      /v "{2cc5ca98-6485-489a-920e-b3e88a6ccce3}" `
      /t REG_DWORD `
      /d 1 `
      /f
  }

  function RemoveImageLibrary() {
    # 创建注册表项
    reg.exe add `
      "HKCU\Software\Classes\CLSID\{E88865EA-0E1C-4E20-9AA6-EDCD0212C87C}" `
      /f
    
    # 设置属性
    reg.exe add `
      "HKCU\Software\Classes\CLSID\{E88865EA-0E1C-4E20-9AA6-EDCD0212C87C}" `
      /v "System.IsPinnedToNameSpaceTree" `
      /t REG_DWORD `
      /d 0 `
      /f
  }

  function MsEdge() {
    # 创建注册表项
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Edge" `
      /f
  
    # 设置属性
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Edge" `
      /v "DiskCacheDir" `
      /t REG_SZ `
      /d "$userPath\scoop\persist\edge\cache" `
      /f
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Edge" `
      /v "DnsOverHttpsMode" `
      /t REG_SZ `
      /d "secure" `
      /f
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Edge" `
      /v "DnsOverHttpsTemplates" `
      /t REG_SZ `
      /d "https://doh.pub/dns-query" `
      /f
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Edge" `
      /v "UserDataDir" `
      /t REG_SZ `
      /d "$userPath\scoop\persist\edge\profiles" `
      /f
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Edge" `
      /v "WebRtcLocalhostIpHandling" `
      /t REG_SZ `
      /d "disable_non_proxied_udp" `
      /f
  }
  function disableNetworkSearch() {
    # 创建注册表项
    reg.exe add `
      "HKCU\Software\Policies\Microsoft\Windows\Explorer" `
      /f
  
    # 设置属性
    reg.exe add `
      "HKCU\Software\Policies\Microsoft\Windows\Explorer" `
      /v "DisableSearchBoxSuggestions" `
      /t REG_DWORD `
      /d 1 `
      /f
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
