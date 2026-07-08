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
  function laptop(){
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
    # 笔记本允许地图自动下载更新
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\Maps" `
      /v "AutoDownloadAndUpdateMapData" `
      /t REG_DWORD `
      /d 1 `
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
      /d "off" `
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
    # 关闭地址栏搜索建议、搜索推荐
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Edge" `
      /v "SearchSuggestEnabled" `
      /t REG_DWORD `
      /d 0 `
      /f
    # 关闭 Edge 遥测实验配置
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Edge" `
      /v "ExperimentationAndConfigurationServiceControl" `
      /t REG_DWORD `
      /d 0 `
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
  function disableEvilRecall() {
    # 创建注册表项
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" `
      /f
    # 设置属性
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" `
      /v "AllowRecallEnablement" `
      /t REG_DWORD `
      /d 0 `
      /f
    Disable-WindowsOptionalFeature `
      -Online `
      -FeatureName 'Recall' `
      -Remove
  }
  function disableCDP() {
    reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\CDPSvc" `
      /v Start `
      /t REG_DWORD `
      /d 4 `
      /f
    reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\CDPUserSvc" `
      /v Start `
      /t REG_DWORD `
      /d 4 `
      /f
  }
  function disableActivityHistory() {
    reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" `
    /f
    reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" `
      /v EnableActivityFeed `
      /t REG_DWORD `
      /d 0 `
      /f
    reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" `
      /v PublishUserActivities `
      /t REG_DWORD `
      /d 0 `
      /f
    reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" `
      /v UploadUserActivities `
      /t REG_DWORD `
      /d 0 `
      /f
  }
  # ref: https://learn.microsoft.com/en-us/windows/privacy/configure-windows-diagnostic-data-in-your-organization
  function disableCoreTelemetry() {
    # 创建注册表项
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" `
      /f
    # 设置属性
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" `
      /v "AllowTelemetry" `
      /t REG_DWORD `
      /d 0 `
      /f
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" `
      /v "LimitDumpCollection" `
      /t REG_DWORD `
      /d 1 `
      /f
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" `
      /v "LimitDiagnosticLogCollection" `
      /t REG_DWORD `
      /d 1 `
      /f
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" `
      /v "DoNotShowFeedbackNotifications" `
      /t REG_DWORD `
      /d 1 `
      /f
  }

  # ref: https://learn.microsoft.com/en-us/windows/privacy/manage-connections-from-windows-operating-system-components-to-microsoft-services#1822-settings--privacy--diagnostics-feedback
  function disableTailoredExperiences() {
    # 创建注册表项
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" `
      /f
    # 设置属性
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" `
      /v "DisableWindowsConsumerFeatures" `
      /t REG_DWORD `
      /d 1 `
      /f
    reg.exe add `
      "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" `
      /f
    reg.exe add `
      "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" `
      /v "DisableTailoredExperiencesWithDiagnosticData" `
      /t REG_DWORD `
      /d 1 `
      /f
  }

  # ref: https://learn.microsoft.com/en-us/windows/privacy/manage-connections-from-windows-operating-system-components-to-microsoft-services#182-settings--privacy--general
  function disableAdvertisingID() {
    # 创建注册表项
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" `
      /f
    # 设置属性
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" `
      /v "DisabledByGroupPolicy" `
      /t REG_DWORD `
      /d 1 `
      /f
  }

  # ref: "Inking & typing" + "Speech" sections, same doc
  function disableInputTelemetry() {
    # 创建注册表项
    reg.exe add `
      "HKCU\Software\Microsoft\InputPersonalization" `
      /f
    # 设置属性
    reg.exe add `
      "HKCU\Software\Microsoft\InputPersonalization" `
      /v "RestrictImplicitTextCollection" `
      /t REG_DWORD `
      /d 1 `
      /f
    reg.exe add `
      "HKCU\Software\Microsoft\InputPersonalization" `
      /v "RestrictImplicitInkCollection" `
      /t REG_DWORD `
      /d 1 `
      /f
    reg.exe add `
      "HKCU\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" `
      /f
    reg.exe add `
      "HKCU\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" `
      /v "HasAccepted" `
      /t REG_DWORD `
      /d 0 `
      /f
  }

  # ref: "Find My Device" section, same doc
  function disableFindMyDevice() {
    # 创建注册表项
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\FindMyDevice" `
      /f
    # 设置属性
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\FindMyDevice" `
      /v "AllowFindMyDevice" `
      /t REG_DWORD `
      /d 0 `
      /f
  }

  # ref: "Device metadata retrieval" section, same doc
  function disableDeviceMetadata() {
    # 创建注册表项
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\Device Metadata" `
      /f
    # 设置属性
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\Device Metadata" `
      /v "PreventDeviceMetadataFromNetwork" `
      /t REG_DWORD `
      /d 1 `
      /f
  }

  # ref: "Wi-Fi Sense" section, same doc
  function disableWifiSense() {
    reg.exe add "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" `
      /f
    reg.exe add "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" `
      /v "AutoConnectAllowedOEM" `
      /t REG_DWORD `
      /d 0 `
      /f
  }

  # ref: "Sync your settings" section, same doc
  function disableSettingSync() {
    # 创建注册表项
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" `
      /f
    # 设置属性
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" `
      /v "DisableSettingSync" `
      /t REG_DWORD `
      /d 2 `
      /f
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" `
      /v "DisableSettingSyncUserOverride" `
      /t REG_DWORD `
      /d 1 `
      /f
  }

  # ref: "Location" section, same doc
  function disableLocationTracking() {
    # 创建注册表项
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" `
      /f
    # 设置属性
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" `
      /v "DisableLocation" `
      /t REG_DWORD `
      /d 1 `
      /f
  }

  # ref: "News and interests" section, same doc
  function disableWindowsFeeds() {
    # 创建注册表项
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" `
      /f
    # 设置属性
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" `
      /v "EnableFeeds" `
      /t REG_DWORD `
      /d 0 `
      /f
  }

  # ref: "Cortana and Search" section, same doc
  function disableCortana() {
    # 创建注册表项
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" `
      /f
    # 设置属性
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" `
      /v "AllowCortana" `
      /t REG_DWORD `
      /d 0 `
      /f
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" `
      /v "DisableWebSearch" `
      /t REG_DWORD `
      /d 1 `
      /f
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" `
      /v "AllowSearchToUseLocation" `
      /t REG_DWORD `
      /d 0 `
      /f
  }

  # ref: "Insider Preview builds" section, same doc
  function disableInsiderBuilds() {
    # 创建注册表项
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" `
      /f
    # 设置属性
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" `
      /v "AllowBuildPreview" `
      /t REG_DWORD `
      /d 0 `
      /f
  }

  # ref: "Settings > Privacy > General" – Track App Launches
  function disableAppLaunchTracking() {
    reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
      /f
    reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
      /v "Start_TrackProgs" `
      /t REG_DWORD `
      /d 0 `
      /f
  }

  # ref: "Settings > Privacy > App Diagnostics" section, same doc
  function disableAppDiagnostics() {
    reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" `
      /f
    reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" `
      /v "LetAppsGetDiagnosticInfo" `
      /t REG_DWORD `
      /d 2 `
      /f
  }

  # ref: "Offline maps" section, same doc
  function disableMapUpdates() {
    # 创建注册表项
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\Maps" `
      /f
    # 设置属性
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\Maps" `
      /v "AutoDownloadAndUpdateMapData" `
      /t REG_DWORD `
      /d 0 `
      /f
  }

  # ref: "Teredo" section, same doc
  function disableTeredo() {
    # 创建注册表项
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\TCPIP\v6Transition" `
      /f
    # 设置属性
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows\TCPIP\v6Transition" `
      /v "Teredo_State" `
      /t REG_SZ `
      /d "Disabled" `
      /f
  }

  # ref: DiagTrack = Connected User Experiences and Telemetry (诊断数据主服务)
  function disableDiagTrackService() {
    reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack" `
      /v Start `
      /t REG_DWORD `
      /d 4 `
      /f
    # Windows Error Reporting
    reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\WerSvc" `
      /v Start `
      /t REG_DWORD `
      /d 4 `
      /f
  }

  # ref: "Voice Activation" section, same doc
  function disableVoiceActivation() {
    reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" `
      /f
    reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" `
      /v "LetAppsActivateWithVoice" `
      /t REG_DWORD `
      /d 2 `
      /f
    reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" `
      /v "LetAppsActivateWithVoiceAboveLock" `
      /t REG_DWORD `
      /d 2 `
      /f
  }

  # ref: "Software Protection Platform" section, same doc
  function disableSPPTelemetry() {
    # 创建注册表项
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" `
      /f
    # 设置属性
    reg.exe add `
      "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" `
      /v "NoGenTicket" `
      /t REG_DWORD `
      /d 1 `
      /f
  }

  function main {
    HideDesktopIcons
    RemoveImageLibrary
    MsEdge
    disableNetworkSearch
    disableEvilRecall
    disableCDP
    disableActivityHistory
    disableCoreTelemetry
    disableTailoredExperiences
    disableAdvertisingID
    disableInputTelemetry
    disableFindMyDevice
    disableDeviceMetadata
    disableWifiSense
    disableSettingSync
    disableLocationTracking
    disableWindowsFeeds
    disableCortana
    disableInsiderBuilds
    disableAppLaunchTracking
    disableAppDiagnostics
    disableMapUpdates
    disableTeredo
    disableDiagTrackService
    disableVoiceActivation
    disableSPPTelemetry
  }

  main
}
Invoke-Command $script
