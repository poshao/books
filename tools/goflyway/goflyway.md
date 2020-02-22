# goflyway安装配置

## 安装
#### 1.下载二进制包
[release](https://github.com/coyove/goflyway/releases)
根据系统下载对应版本

#### 2.编译生成
1. 安装golang

``` sh
sudo apt-get install golang git
```

2. 下载源码[release](https://github.com/coyove/goflyway/releases)
    下载source code ,将文件解压到 $HOME/go/src/github.com/coyove

3. 安装依赖库

``` sh
    cd $HOME/go/src/github.com/coyove/goflyway
    make goget

    # 使用一下命令手动安装依赖库
    # go get github.com/coyove/tcpmux
    # go get golang.org/x/crypto

```

3. 编译
``` sh
# 生成所有版本，默认生成在 build文件夹
make release
```

* 修改生成树莓派(arm)版本
在makefile 文件添加以下内容,然后执行 <code>make raspi</code>即可生成

``` makefile
raspi: $(SOURCE)
        $(call release,linux,arm,$(NAME))
        $(call tar,linux,arm)
```



## 快速配置脚本
[goflyway_setup.sh](./code/goflyway_setup.sh)

``` sh
#!/bin/sh

GFW_APP=$(pwd)/goflyway
#GFW_HOST='cf://www.free6666.com:8080'
#GFW_PASSWD='?cwww.free6666.com:8080'


gfw_start(){
	echo 'start goflyway ...'
	nohup $GFW_APP -up="$GFW_HOST" -k="$GFW_PASSWD" -l=":1080" > /tmp/goflyway.log 2>&1 &
}

gfw_stop(){
	echo 'stop goflyway...'
	killall goflyway
}

gfw_restart(){
	echo 'restart goflyway...'
	killall goflyway
	sleep 2s
	nohup $GFW_APP -up="$GFW_HOST" -k="$GFW_PASSWD" -l=":1080" > /tmp/goflyway.log 2>&1 &
}

gfw_edit(){
	echo 'edit configure...'
	if [ ! -e $(pwd)/passwd.ini ]; then
		echo "[goflyway]\nup=\nkey=" > $(pwd)/passwd.ini
	fi
	nano $(pwd)/passwd.ini
	gfw_get_config
	gfw_restart
}

gfw_get_config(){
	GFW_HOST=`cat $(pwd)/passwd.ini | grep -P '(?<=up=).*$' -o`
	GFW_PASSWD=`cat $(pwd)/passwd.ini | grep -P '(?<=key=).*$' -o`
}

gfw_help(){
echo "setup [option]

help		show this message
free		show the page about free account
edit		edit configure
start		start proxy service
stop		stop proxy service
restart		restart proxy service"
}

if [ ! -e $(pwd)/passwd.ini ]; then
	gfw_edit
	exit 0
fi

gfw_get_config

case $1 in
start)
	gfw_start
	;;
stop)
	gfw_stop
	;;
restart)
	gfw_restart
	;;
edit)
	gfw_edit
	;;
free)
	echo 'https://github.com/Alvin9999/new-pac/wiki/Goflyway%E5%85%8D%E8%B4%B9%E8%B4%A6%E5%8F%B7'
	;;
help)
	gfw_help
	;;
*)
	echo 'invalid params...'
	gfw_help
	;;
esac
```