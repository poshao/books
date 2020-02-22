# GRUB2 配置修改

[TOC]

### 适用环境
(GRUB) 2.02-2ubuntu8.14

### 设置保存上一次的启动方式
修改文件 /etc/default/grub

``` properties
GRUB_DEFAULT=saved
GRUB_SAVEDEFAULT=true
```

### 增加关机重启菜单
修改文件 /etc/grub.d/40_custom

``` sh
#!/bin/sh
exec tail -n +3 $0
# This file provides an easy way to add custom menu entries.  Simply type the
# menu entries you want to add after this comment.  Be careful not to change
# the 'exec tail' line above.

menuentry "重启" --class restart {
    echo "System rebooting..."
    reboot
}

menuentry "关机" --class shutdown {
    echo "System shutting down..."
    halt
}

```

### 安装主题
[主题下载](https://www.gnome-look.org/browse/cat/109/order/latest/)

**以linuxmint主题为例**

1. 将文件目录linumint复制到 /boot/grub/themes
2. 修改配置使用主题, 创建或修改文件 /etc/default/grub.d/60_mint-theme.cfg

``` sh
#! /bin/sh
set -e

#因该字体不支持中文，使用默认字体
#GRUB_FONT="/boot/grub/fonts/UbuntuMono16.pf2"
GRUB_THEME="/boot/grub/themes/linuxmint/theme.txt"
```

3. 给efi设置菜单增加图标, 修改文件 /etc/grub.d/30_uefi-firmware

``` sh
# 添加 --class efi
menuentry '$LABEL' --class efi \$menuentry_id_option 'uefi-firmware' {
        fwsetup
}
```

#### 菜单图标显示说明
菜单项的图标是根据 class名称加载主题包(linuxmint/icons/*)内的图标

``` properties
#此处class指定的为 restart , 则会显示 linuxmint/icons/restart.png
menuentry "重启" --class restart {
    echo "System rebooting..."
    reboot
}
```

### 更新配置，应用修改
*!!!在修改完成后一定记得执行此步骤!!!*

``` sh
sudo update-grub2
# 重启见证奇迹
sudo reboot
```