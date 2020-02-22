# Samba文件共享设置
### 基础环境
Linux raspberrypi 4.19.75-v7l+
Samba Version 4.9.5-Debian

### 安装命令

``` sh
sudo apt-get install samba -y

```

### 参数配置

#### 配置匿名访问
1. 修改文件 /etc/samba/smb.conf

``` properties
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
#制度权限
read only=yes
```

2. 添加用户

``` sh
#默认情况下smb的用户管理没有nobody,会导致登录时需要密码
sudo smbpasswd -an nobody
```

### 附录
使用以下命令可以检查参数是否设置正确

``` sh
testparm /etc/samba/smb.conf
```