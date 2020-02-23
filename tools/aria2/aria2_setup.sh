#!/bin/sh

# setup for aria2

ARIA2_PATH=$(pwd)
ARIA2_DWFOLDER=$HOME/download
ARIA2_DWDIR=$ARIA2_DWFOLDER/download
ARIA2_DWCDIR=$ARIA2_DWFOLDER/complete
ARIA2_SESSION=$ARIA2_PATH/aria2.session
ARIA2_DHT=$ARIA2_PATH/dht.dat
ARIA2_DHT6=$ARIA2_PATH/dht6.dat
ARIA2_RPC_SECRET='hellohanmeimei'

ARIA2_CONF=$ARIA2_PATH/aria2.conf

aria2_init_conf(){
	if [ `echo $0 | grep -P '/' -o | wc -l` -gt 1 ]; then
		echo 'please change to aria2 folder and run again!'
		exit 0
	fi

	ARIA2_PATH=$(pwd)
	sed -i "s!^ARIA2_PATH=.*!ARIA2_PATH=$ARIA2_PATH!g" $0

	if [ ! -e ${ARIA2_CONF} ]; then
	    cp ${ARIA2_PATH}/aria2.conf.sample ${ARIA2_PATH}/aria2.conf
	fi

	if [ ! -e ${ARIA2_SESSION} ]; then
		touch ${ARIA2_SESSION}
	fi

	if [ ! -d ${ARIA2_DWCDIR} ]; then
		mkdir ${ARIA2_DWCDIR}
	fi

	#read -p "input download dir(${ARIA2_DWDIR}):" ARIA2_DWDIR
	#read -p "input rpc secret(${ARIA2_RPC_SECRET}):" ARIA2_RPC_SERCRET

	sed -i "s!^dir=.*!dir=${ARIA2_DWDIR}!g" ${ARIA2_CONF}
	sed -i "s!^input-file=.*!input-file=${ARIA2_SESSION}!g" ${ARIA2_CONF}
	sed -i "s!^save-session=.*!save-session=${ARIA2_SESSION}!g" ${ARIA2_CONF}
	sed -i "s!^rpc-secret=.*!rpc-secret=${ARIA2_RPC_SECRET}!g" ${ARIA2_CONF}
	sed -i "s!^dht-file-path=.*!dht-file-path=${ARIA2_DHT}!g" ${ARIA2_CONF}
	sed -i "s!^dht-file-path6=.*!dht-file-path6=${ARIA2_DHT6}!g" ${ARIA2_CONF}

	# bind event scripts
	for event_name in 'bt-download-complete' 'download-complete' 'download-start' 'download-pause' 'download-stop' 'download-error'
	do
		event_path=${ARIA2_PATH}/script/cb_${event_name}.sh
		if [ -x ${event_path} ]; then
			if [ -z "`grep 'ARIA2_DWCDIR' ${event_path}`" ]; then
				sed -i '2 iARIA2_DWCDIR='$ARIA2_DWCDIR ${event_path}
			else
				sed -i "s!^ARIA2_DWCDIR.*!ARIA2_DWCDIR=$ARIA2_DWCDIR!g" ${event_path}
			fi

			if [ -z "`grep "on-${event_name}" ${ARIA2_CONF}`" ]; then
				echo "on-$event_name=$event_path" >> ${ARIA2_CONF}
			else
				sed -i "s!on-$event_name.*!on-$event_name=$event_path!g" ${ARIA2_CONF}
			fi
		fi
	done
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
	echo 'restart aria2...'
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
	if [ ! -z "$list" ]; then
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
