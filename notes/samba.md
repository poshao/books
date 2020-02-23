# Samba文件共享设置
### 基础环境
Linux raspberrypi 4.19.75-v7l+
Samba Version 4.9.5-Debian

### 安装命令

``` sh
sudo apt-get install samba -y

```

### 参数配置说明

>配置文件 /etc/samba/smb.conf

``` ini
#在配置文件末尾添加以下内容

[pi_disk]
#共享描述
comment=Pi Disk

#共享的实际目录
path=/mnt/share

#设置可以浏览
browseable=yes

#允许匿名登录，等同public=yes
#注意将[global]的设置项 map to guest = bad user，只用此设定才可以实现匿名
guest ok=yes

#只读权限
#read only=yes

# 有效用户为adm组成员, 用户pi
#valid users=@adm,pi

# 拥有写入权限的用户和组，注意配置文件系统本身的权限 chmod 777 ./*
#write list=@adm,pi
```

### 用户权限认证

***samba的用户认证与linux的用户认证相互独立，所以在第一次配置用户时需要将用户添加到samba中***

``` sh
#默认情况下smb的用户管理没有nobody,会导致登录时需要密码
sudo smbpasswd -an nobody

# 添加pi用户到smb用户管理
sudo smbpasswd -a pi
```


### 服务重启

``` sh
sudo service smbd restart
```

### 附录
使用以下命令可以检查参数是否设置正确

``` sh
testparm /etc/samba/smb.conf
```