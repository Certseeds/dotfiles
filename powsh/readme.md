# meaningless title

1. 重装
2. 确认连通性, 可以正常执行
3. config broswer
4. install scoop, `scoop install git`, clone dotfiels
5. install visual stuidio code(can not via scoop, bugs)
6. `scoop install uv`, config dotfiles
7. get firefox and config
8. get edge and config
9. `scoop install diskplusplus`, 开始调系统
10. 安装fillder, 解锁uwp的网络问题 (不用 uwp 可跳过)
11. 安装一票uwp应用, 顺带解锁网络问题 (不用 uwp 可跳过)
12. `scoop install officetoolplus`, 装office
13. wsl settings
14. `scoop install jetbrains-toolbox`, 装clion, idea, etc...
15. `scoop install temurin8/25-jdk`, 配idea
16. `scoop install neteasemusic`
17. `scoop install nanazip 7-zip`
18. `scoop install potplayer mpc-be`
19. 调hyperv 镜像

+ 会自动更新的(Edge,vscode,jetbrains), 只用scoop的库里的下载的链接, 自己安装.
+ 自己不更新的/不需要更新的/不想更新的,用scoop

## 更换系统

如果原有系统在另外一个盘里, 有很多东西可以复制过来, 不需要下载.

0. 装机
1. 开启windows更新, 后台更新系统+驱动.
2. login broswer, sync conf and config
3. 开bitlocker, 全盘加密先搞上.

``` log
login, and sync其他配置.

DnsOverHttpsMode: secure
DnsOverHttpsTemplates: https://doh.pub/dns-query
HubsSidebarEnabled: false
```

1. 把scoop复制过来

``` log
重装系统之前, 先完整复制用户目录下的scoop文件夹到非系统盘
重装系统之后, 将scoop文件夹粘贴回去用户目录
在环境变量设置中,新建一个用户变量,名字为SCOOP,值为当前scoop文件夹的地址,即:
> C:\Users\xxxx\scoop
允许脚本执行:
> set-executionpolicy remotesigned -s currentuser
双击用户变量中的path,新建一个路径,填入 :
> %SCOOP%\shims
管理员权限powershell中运行:
> scoop reset *
```

1. uwp应用

+ eartrumpet
+ ms-todo
+ windows-terminal

1. 把dotfiles复制过来, 上软链接
2. 先把onedrive文件复制一个小文件, 开onedrive试一下, 然后决定是否复制全部的.
3. 装一下ide

+ java在scoop里面
+ clion需要wsl2里面的gcc
+ goland在scoop里面
+ pycharm在wsl2里面起podman-python
