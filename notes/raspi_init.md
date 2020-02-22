# 树莓派初始化配置

### 配置Wifi
修改文件/etc/wpa_supplicant/wpa_supplicant.conf
``` conf
# 添加以下内容
network={
  ssid="wifi名称"
  proto=WPA
  key_mgmt=WPA-PSK
  psk="密码"
}
```

### 使用镜像源
修改文件 /etc/apt/source.list
```
deb https://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian/ buster main contrib non-free rpi
```

修改文件 /etc/apt/sources.list.d/raspi.list
```
deb http://mirrors.ustc.edu.cn/archive.raspberrypi.org/debian/ buster main
```

### 使用ZSH工具
``` sh
sudo apt-get install zsh git -y
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
```