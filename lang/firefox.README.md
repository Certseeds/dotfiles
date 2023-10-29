# firefox profiles

workwith `arkenfox/user.js`

## prefs.js

prefs.js是firefox读了user.js之后, 配合runtime的一些修改形成的配置文件, 每次启动/关闭时都会改变, 没有备份的必要.

## user.js

这个文件需要软链接到配置目录下.

## user-overrides.js

它只是一份抽离出来的diff, parse时会后面的会覆盖前面的, 往后append即可生效.

## 更新方式

0. `killall firefox`
1. update user.js
2. `cat ./user-overrides.js >> ./user.js`
