# aria2下载工具配置
[TOC]
## 配置文件
``` conf
## '#'开头为注释内容, 选项都有相应的注释说明, 根据需要修改 ##
## 被注释的选项填写的是默认值, 建议在需要修改时再取消注释  ##

# 后台运行
daemon=true

## 文件保存相关 ##

# 文件的保存路径(可使用绝对路径或相对路径), 默认: 当前启动位置
dir=/home/pi/download/aria2
# 启用磁盘缓存, 0为禁用缓存, 需1.16以上版本, 默认:16M
#disk-cache=32M
# 文件预分配方式, 能有效降低磁盘碎片, 默认:prealloc
# 预分配所需时间: none < falloc ? trunc < prealloc
# falloc和trunc则需要文件系统和内核支持
# NTFS建议使用falloc, EXT3/4建议trunc, MAC 下需要注释此项
#file-allocation=none
# 断点续传
continue=true

## 下载连接相关 ##

# 最大同时下载任务数, 运行时可修改, 默认:5
max-concurrent-downloads=10
# 同一服务器连接数, 添加时可指定, 默认:1
#max-connection-per-server=1
# 最小文件分片大小, 添加时可指定, 取值范围1M -1024M, 默认:20M
# 假定size=10M, 文件为20MiB 则使用两个来源下载; 文件为15MiB 则使用一个来源下载
min-split-size=10M
# 单个任务最大线程数, 添加时可指定, 默认:5
#split=5
# 整体下载速度限制, 运行时可修改, 默认:0
#max-overall-download-limit=0
# 单个任务下载速度限制, 默认:0
#max-download-limit=0
# 整体上传速度限制, 运行时可修改, 默认:0
#max-overall-upload-limit=0
# 单个任务上传速度限制, 默认:0
#max-upload-limit=0
# 禁用IPv6, 默认:false
#disable-ipv6=true
# 连接超时时间, 默认:60
#timeout=60
# 最大重试次数, 设置为0表示不限制重试次数, 默认:5
#max-tries=5
# 设置重试等待的秒数, 默认:0
#retry-wait=0

## 进度保存相关 ##

# 从会话文件中读取下载任务
input-file=/home/pi/apps/aria2/aria2.session
# 在Aria2退出时保存`错误/未完成`的下载任务到会话文件
save-session=/home/pi/apps/aria2/aria2.session
# 定时保存会话, 0为退出时才保存, 需1.16.1以上版本, 默认:0
#save-session-interval=60

## RPC相关设置 ##

# 启用RPC, 默认:false
enable-rpc=true
# 允许所有来源, 默认:false
rpc-allow-origin-all=true
# 允许非外部访问, 默认:false
rpc-listen-all=true
# 事件轮询方式, 取值:[epoll, kqueue, port, poll, select], 不同系统默认值不同
#event-poll=select
# RPC监听端口, 端口被占用时可以修改, 默认:6800
#rpc-listen-port=6800
# 设置的RPC授权令牌, v1.18.4新增功能, 取代 --rpc-user 和 --rpc-passwd 选项
rpc-secret=secret
# 是否启用 RPC 服务的 SSL/TLS 加密,
# 启用加密后 RPC 服务需要使用 https 或者 wss 协议连接
#rpc-secure=true
# 在 RPC 服务中启用 SSL/TLS 加密时的证书文件,
# 使用 PEM 格式时，您必须通过 --rpc-private-key 指定私钥
#rpc-certificate=/path/to/certificate.pem
# 在 RPC 服务中启用 SSL/TLS 加密时的私钥文件
#rpc-private-key=/path/to/certificate.key

## BT/PT下载相关 ##

# 当下载的是一个种子(以.torrent结尾)时, 自动开始BT任务, 默认:true
#follow-torrent=true
# BT监听端口, 当端口被屏蔽时使用, 默认:6881-6999
listen-port=51413
# 单个种子最大连接数, 默认:55
#bt-max-peers=55
# 打开DHT功能, PT需要禁用, 默认:true
enable-dht=true
#DHT (IPv4)路由表文件路径.
dht-file-path=/home/pi/apps/aria2/dht.dat
# 打开IPv6 DHT功能, PT需要禁用
enable-dht6=true
#DHT (IPv6)路由表文件路径.
dht-file-path6=/home/pi/apps/aria2/dht6.dat
# DHT网络监听端口, 默认:6881-6999
#dht-listen-port=6881-6999
# 本地节点查找, PT需要禁用, 默认:false
#bt-enable-lpd=false
# 种子交换, PT需要禁用, 默认:true
enable-peer-exchange=true
# 每个种子限速, 对少种的PT很有用, 默认:50K
#bt-request-peer-speed-limit=50K
# 客户端伪装, PT需要
peer-id-prefix=-TR2770-
user-agent=Transmission/2.77
# 当种子的分享率达到这个数时, 自动停止做种, 0为一直做种, 默认:1.0
seed-ratio=0
# 强制保存会话, 即使任务已经完成, 默认:false
# 较新的版本开启后会在任务完成后依然保留.aria2文件
#force-save=false
# BT校验相关, 默认:true
#bt-hash-check-seed=true
# 继续之前的BT任务时, 无需再次校验, 默认:false
bt-seed-unverified=true
# 保存磁力链接元数据为种子文件(.torrent文件), 默认:false
bt-save-metadata=true

#BT 服务器(https://github.com/ngosang/trackerslist)
bt-tracker=
```

## 添加服务
1. 创建文件 /etc/systemd/system/aria2.service

``` properties
[Unit]
Description=Aria2 Service
After=network.target

[Service]
Type=forking
ExecStart=/usr/bin/aria2c --conf-path=/home/pi/apps/aria2/aria2.conf

[Install]
WantedBy=default.target

```
2. 设置开机启动

``` sh
sudo systemctl enable aria2
```

## 安装 nginx + AriaNg
[git](https://github.com/mayswind/AriaNg.git)

``` shell
sudo apt-get install nginx
wget https://github.com/mayswind/AriaNg/releases/download/1.1.4/AriaNg-1.1.4.zip
sudo unzip ./AriaNg-1.1.4.zip -d /var/www/html/ariang
```
访问[http://localhost/ariang](http://localhost/ariang)


## 快捷配置脚本
[aria2_setup.sh](./code/aria2_setup.sh)
``` sh
#!/bin/sh

# setup for aria2

ARIA2_PATH=$(pwd)
ARIA2_DWDIR=$HOME/download
ARIA2_SESSION=$ARIA2_PATH/aria2.session
ARIA2_DHT=$ARIA2_PATH/dht.dat
ARIA2_DHT6=$ARIA2_PATH/dht6.dat
ARIA2_RPC_SECRET='hellohanmeimei'

ARIA2_CONF=$ARIA2_PATH/aria2.conf

aria2_init_conf(){
	if [ ! -e ${ARIA2_CONF} ]; then
	    cp ${ARIA2_PATH}/aria2.conf.sample ${ARIA2_PATH}/aria2.conf
	fi

	#read -p "input download dir(${ARIA2_DWDIR}):" ARIA2_DWDIR
	#read -p "input rpc secret(${ARIA2_RPC_SECRET}):" ARIA2_RPC_SERCRET

	sed -i "s!^dir=.*!dir=${ARIA2_DWDIR}!g" ${ARIA2_CONF}
	sed -i "s!^input-file=.*!input-file=${ARIA2_SESSION}!g" ${ARIA2_CONF}
	sed -i "s!^save-session=.*!save-session=${ARIA2_SESSION}!g" ${ARIA2_CONF}
	sed -i "s!^rpc-secret=.*!rpc-secret=${ARIA2_RPC_SECRET}!g" ${ARIA2_CONF}
	sed -i "s!^dht-file-path=.*!dht-file-path=${ARIA2_DHT}!g" ${ARIA2_CONF}
	sed -i "s!^dht-file-path6=.*!dht-file-path6=${ARIA2_DHT6}!g" ${ARIA2_CONF}
}

aria2_install_service(){
echo "[Unit]
Description=Aria2 Service
After=network.target

[Service]
Type=forking
ExecStart=/usr/bin/aria2c --conf-path=${ARIA2_CONF}

[Install]
WantedBy=default.target" | sudo tee /etc/systemd/system/aria2.service
sudo systemctl daemon-reload
echo 'service install to /etc/systemd/system/aria2.service'
}

aria2_edit(){
	echo 'edit configure...'
	nano ${ARIA2_CONF}
	aria2_restart
}

aria2_autostart(){
	sudo systemctl enable aria2
}

aria2_start(){
	echo 'start aria2...'
	/usr/bin/aria2c --conf-path=${ARIA2_CONF}
}

aria2_stop(){
	echo 'stop aria2...'
	killall aria2c
}

aria2_restart(){
	echo 'restart arai2...'
	killall aria2c
	sleep 1s
	/usr/bin/aria2c --conf-path=${ARIA2_CONF}
}

#service_install(){
#	sudo ln -s ${ARIA2_PATH}/aria2.service  /etc/systemd/system/aria2.service
#	sudo systemctl daemon-reload
#}

aria2_bt_update(){
	echo 'bt-tracker update...'
	list=`wget -qO- https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt|awk NF|sed ":a;N;s/\n/,/g;ta"`
	if [ ! -z $list]; then
		if [ -z "`grep "bt-tracker" ${ARIA2_CONF}`" ]; then
			sed -i '$a bt-tracker='${list} ${ARIA2_CONF}
			echo add......
		else
			sed -i "s!bt-tracker.*!bt-tracker=$list!g" ${ARIA2_CONF}
			echo update......
		fi
		aria2_restart
	else
		echo 'can not get the tracker list...'
	fi
}

ariang_install(){
	wget -O ~/ariang.tmp https://github.com/mayswind/AriaNg/releases/download/1.1.4/AriaNg-1.1.4.zip
	sudo unzip ~/ariang.tmp -d /var/www/html/ariang
	rm ~/ariang.tmp
}

aria2_help(){
echo "setup [option]

help		show this message
init		init configue
install		install service
edit		edit the configure
bt-update	update bt-tracker
install-ariang	install ariang to /var/www/html/araing
auto-start	start aria2 when system loaded
start		start service
stop		stop service
restart 	restart service"
}

case "$1" in
help)
	aria2_help
	;;
start)
	aria2_start
	;;
stop)
	aria2_stop
	;;
restart)
	aria2_restart
	;;
install)
	aria2_install_service
	;;
auto-start)
	aria2_autostart
	;;
init)
	aria2_init_conf
	;;
edit)
	aria2_edit
	;;
bt-update)
	aria2_bt_update
	;;
install-ariang)
	ariang_install
	;;
*)
	aria2_help
	;;
esac

```


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