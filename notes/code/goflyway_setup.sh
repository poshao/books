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
