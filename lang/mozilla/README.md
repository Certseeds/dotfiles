# firefox profiles

## firefox

workwith `arkenfox/user.js`

> 注意不要将 thundbird 的 user.js 链接到 firefox 的配置目录下, 反之亦然. 不然启动后, 配置污染会导致一些莫名其妙的问题, 比如图像无法显示, 并且还原之后也不会好转, 删除prefs.js-清空配置后才有好转.

### prefs.js

prefs.js是firefox读了user.js之后, 配合runtime的一些修改形成的配置文件, 每次启动/关闭时都会改变, 没有备份的必要.

### user.js

这个文件需要软链接到配置目录下.

### user-overrides.js

它只是一份抽离出来的diff, parse时会后面的会覆盖前面的, 往后append即可生效.

### 更新方式

0. `killall firefox`
1. update user.js
2. `cat ./user-overrides.js >> ./user.js`
3. update symlink

## thunderbird

workwith `/HorlogeSkynet/thunderbird-user.js`

使用风格与 firefox 相同, policies 相同, user.js不同, 而user-overrides.js 相同.

### 更新方式

0. `killall thunderbird`
1. update user.js
2. `cat ./user-overrides.js >> ./user.js`
3. update symlink
