# aria2下载工具配置

## 安装

``` sh
sudo apt-get install aria2
```

## 安装 nginx + AriaNg
[git](https://github.com/mayswind/AriaNg.git)

``` shell
sudo apt-get install nginx
wget https://github.com/mayswind/AriaNg/releases/download/1.1.4/AriaNg-1.1.4.zip
sudo unzip ./AriaNg-1.1.4.zip -d /var/www/html/ariang
```
访问[http://localhost/ariang](http://localhost/ariang)


# 外置硬盘挂载

### 根据UUID指定目录
编辑 /etc/fstab 文件

``` properties
#设备号 | 挂载目录 | 文件系统类型 | 挂载选项 | 是否备份 | 是否检测
UUID=8950cebd-64e3-4896-a3c4-e9dd0394dae3  /mnt  ext4  defaults 0 0

```
### 使用udev实现根据UUID自动挂载(推荐)
编辑文件 /etc/udev/rules.d/99-usb-storage.rules

``` properties
KERNEL=="sd[a-z][1-9]", SUBSYSTEM=="block", ENV{ID_FS_UUID}=="8950cebd-64e3-4896-a3c4-e9dd0394dae3"， ACTION=="add", RUN+="/bin/mkdir /mnt/download", RUN{program}+="/usr/bin/systemd-mount --no-block /dev/%k /mnt/download"
KERNEL=="sd[a-z][1-9]", SUBSYSTEM=="block", ENV{ID_FS_UUID}=="8950cebd-64e3-4896-a3c4-e9dd0394dae3"， ACTION=="remove", RUN{program}+="/usr/bin/systemd-umount /mnt/download", RUN+="/bin/rmdir /mnt/download"
```

#### udev相关命令说明
``` sh
# 查看信息
#==========
udevadm info -p /sys/block/sda/sda1
# 递归展开
udevadm info -a -p /sys/block/sda/sda1

# 规则测试
#==========
udevadm test -a add /sys/block/sda/sda1
```
