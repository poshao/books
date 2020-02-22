# 邮件服务器搭建

[TOC]

## 概要
  * 树莓派 3B (Debian)
  * BIND9实现DNS域名解析
  * Postfix + Dovecot + MySQL

## 安装步骤

### Bind配置
#### 简介
BIND是一款开放源码的DNS服务器软件,全称是Berkeley Internet Name Domain（伯克利因特网名字域系统）,由美国加州大学Berkeley分校开发和维护的。官方网址：http://www.isc.org/。 它主要有3个版本：BIND 4，BIND 8，BIND9。

解析库(配置文件)
解析器(named)
管理器(rndc)

#### 安装
``` sh
#!/bin/sh
sudo apt-get install bind9
```

#### 配置
1. 修改文件 /etc/default/bind9
``` properties
#
# run resolvconf?
RESOLVCONF=yes
# startup options for the server
OPTIONS="-4 -u bind"
```

2. 修改文件 /etc/bind/named.conf.local
``` ini
include "/etc/bind/zones.local"
```

3. 创建文件 /etc/bind/zones.local
``` ini
zone "home" { type master; file "/etc/bind/db.home"; };
```

4. 创建文件 /etc/bind/db.home
``` ini
;
; BIND data file for local loopback interface
;
$TTL    604800  ;有效存活时间(秒)
@       IN      SOA     home.      root.home. (
                        2019111701      ; Serial  序列号,从服务器更新判断依据,建议YYYYMMDDnn,nn为修订号
                         604800         ; Refresh 从服务器检查更新的时间间隔(秒)
                          86400         ; Retry   当主服务器无响应时,进行下次请求之前的等待时间(秒)
                        2419200         ; Expire  信息有效时间(秒)
                         604800 )       ; Negative Cache TTL 失效缓存有效时间(秒)
;
@               IN      NS      home.
hello           IN      MX      10      mail.home.
@               IN      A       192.168.3.14
pi              IN      A       192.168.3.14
mail            IN      CNAME   home.
```
*注意域名后面的英文句号 .*

* @符号代表对本机的解析；
* IN表示Internet，表示是解析的是因特网中的域名。这个在RFC1035中也有介绍。据说以前也有别的东西，但是现在基本只剩下IN了。
* SOA的写法参数注释
* NS写本域。
* A写对本机解析到的A地址。

#### 检查验证
1. 重启bind9服务使配置生效
``` sh
#!/bin/sh
service bind9 restart
```
2. 修改DNS服务器地址 /etc/reslove.conf
``` properties
nameserver 127.0.0.1
```

3. 检查结果
``` sh
#!/bin/sh
host home
# 输出以下内容表示配置成功
#   home has address 192.168.3.14
#   home mail is handled by 10 mail.home.
```

### Mariadb 配置(等效MySQL)
#### 安装
``` sh
#!/bin/sh
apt-get install mariadb-server
```

### Nginx + PHP配置
#### 安装
``` sh
#!/bin/sh
apt-get install nginx php-fpm php-imap php-mysql php-mbstring
```

#### 配置
1. 修改文件 /etc/nginx/sites-enable/default
``` properties
# 修改以下内容
server {
        # Add index.php to the list if you are using PHP
        index index.php index.html index.htm index.nginx-debian.html;
        # ...
        # pass PHP scripts to FastCGI server
        #
        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
        #
        #       # With php-fpm (or other unix sockets):
                fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;
        #       # With php-cgi (or other tcp sockets):
        #       fastcgi_pass 127.0.0.1:9000;
        }
}
```
#### 检查验证
1. 重启Nginx服务,使配置生效
``` sh
#!/bin/sh
service nginx restart
```

2. 创建文件 /var/www/html/phpinfo.php
``` php
<?php
    echo phpinfo();
?>
```
2. 浏览器打开 http://localhost/phpinfo.php
显示php的配置信息则安装成功

### PostfixAdmin配置
#### 安装
``` sh
#!/bin/sh
# git 下载源码
git clone --depth=1 https://github.com/postfixadmin/postfixadmin.git /opt/postfixadmin
ln -s /opt/postfixadmin/public /var/www/html/postfixadmin
mkdir /opt/postfixadmin/templates_c
chown www-data:www-data /opt/postfixadmin/templates_c
chmod o+w /opt/postfixadmin/templates_c
```

#### 配置
1. 创建数据库
``` sql
create database if not exists `mailhome`  default charset utf8 collate utf8_general_ci;
create user 'mail'@'localhost' identified by 'mail123';
grant all privileges on `mailhome` . * TO 'mail'@'localhost';
```

2. 创建文件 /opt/postfixadmin/config.local.php
``` php
<?php
$CONF['database_type'] = 'mysqli';
$CONF['database_user'] = 'mail';
$CONF['database_password'] = 'mail123';
$CONF['database_name'] = 'mailhome';
$CONF['configured'] = true;
?>
```

3. 浏览器打开 http://localhost/postfixadmin/setup.php 按提示操作
设定 **$CONF['setup_password']** 密码为 "mail111", 并将生成的配置项添加到 /opt/postfix/config.local.php
``` php
<?php
#在文件最后添加类似以下配置项
$CONF['setup_password'] = '8f1723d626d36729bda705dc6a0f2570:dbf86c60c3dd1f58ae467cca7fae7ccb4674b98f';
?>
```

4. 创建管理员账号
name: admin@hello.home
password: mail222

5. 新建域名空间 **hello.home** 、创建邮箱 **admin@hello.home** 密码 **mail222**


### Postfix + Dovecot配置
#### 安装
``` sh
#!/bin/sh
apt-get install postfix postfix-mysql dovecot-core dovecot-imapd dovecot-pop3d dovecot-lmtpd
```
在弹出的框中选择**Internet Site**选项,然后域名地址填写**mail.home**

#### 配置
##### 通用配置
创建虚拟用户文件夹
``` sh
#!/bin/sh
mkdir /var/mail/vmail
chown mail:mail /var/mail/vmail
chmod o+w /var/mail/vmail
```
##### Postfix 配置
1. 修改 /etc/postfix/main.cf
``` properties
# See /usr/share/postfix/main.cf.dist for a commented, more complete version
#
#
# Debian specific:  Specifying a file name will cause the first
# line of that file to be used as the name.  The Debian default
# is /etc/mailname.
#myorigin = /etc/mailname
#
smtpd_banner = $myhostname ESMTP $mail_name (Raspbian)
biff = no
#
# appending .domain is the MUA's job.
append_dot_mydomain = no
#
# Uncomment the next line to generate "delayed mail" warnings
#delay_warning_time = 4h
#
readme_directory = no
#
# See http://www.postfix.org/COMPATIBILITY_README.html -- default to 2 on
# fresh installs.
compatibility_level = 2
#
# 日志输出到单独文件(需要更改master.cf) 4.3版本开始支持
# maillog_file=/var/log/postfix.log
#
# 基本配置
myhostname = raspberrypi
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
myorigin = /etc/mailname
mydestination = raspberrypi, localhost.localdomain, localhost
relayhost =
mynetworks = 192.168.3.0/24 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
mailbox_size_limit = 0
recipient_delimiter = +
inet_interfaces = all
inet_protocols = all
#
# SMTP认证配置
# => 证书参数 TLS parameters
smtpd_tls_cert_file=/etc/dovecot/private/dovecot.pem
smtpd_tls_key_file=/etc/dovecot/private/dovecot.key
smtpd_use_tls = yes
smtpd_tls_auth_only = yes
#smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache
#smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache
#
# => 认证服务
smtpd_sasl_type = dovecot
smtpd_sasl_path = private/auth
smtpd_sasl_authenticated_header = yes
smtpd_sasl_auth_enable = yes
smtpd_sasl_security_options = noanonymous
broken_sasl_auth_clients = yes
#
# See /usr/share/doc/postfix/TLS_README.gz in the postfix-doc package for
# information on enabling SSL in the smtp client.
smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination
smtpd_recipient_restrictions = permit_sasl_authenticated permit_mynetworks reject_unauth_destination
#
# 虚拟邮箱设定
virtual_transport = lmtp:unix:private/dovecot-lmtp
virtual_mailbox_base = /var/mail/vmail
virtual_mailbox_limit = 500000000
virtual_mailbox_domains = mysql:/etc/postfix/mysql/virtual_mailbox_domains.cf
virtual_mailbox_maps = mysql:/etc/postfix/mysql/virtual_mailbox_maps.cf
virtual_alias_maps = mysql:/etc/postfix/mysql/virtual_alias_maps.cf
virtual_minimum_uid = 8
virtual_uid_maps = static:8
virtual_gid_maps = static:8
relay_domains = $mydestination mysql:/etc/postfix/mysql/relay_domains.cf
```

2. 创建MySQL查询配置文件

2.1. 创建文件 /etc/postfix/mysql/relay_domains.cf
``` properties
hosts = localhost
user = mail
password = mail123
dbname = mailhome
query = SELECT domain FROM domain WHERE domain='%s' and backupmx = true
```

2.2. 创建文件 /etc/postfix/mysql/virtual_alias_maps.cf
``` properties
hosts = localhost
user = mail
password = mail123
dbname = mailhome
query = SELECT goto FROM alias WHERE address='%s' AND active = true
```

2.3. 创建文件 /etc/postfix/mysql/virtual_mailbox_limits.cf
``` properties
hosts = localhost
user = mail
password = mail123
dbname = mailhome
query = SELECT quota FROM mailbox WHERE username='%s'
```

2.4. 创建文件 /etc/postfix/mysql/virtual_mailbox_maps.cf
``` properties
hosts = localhost
user = mail
password = mail123
dbname = mailhome
query = SELECT maildir FROM mailbox WHERE username='%s' AND active = true
```

2.5. 创建文件 /etc/postfix/mysql/virtual_mailbox_domains.cf
``` properties
hosts = localhost
user = mail
password = mail123
dbname = mailhome
#query = SELECT domain FROM domain WHERE domain='%s'
#optional query to use when relaying for backup MX
query = SELECT domain FROM domain WHERE domain='%s' and backupmx = false and active = true
```

2.6. *测试MySQL查询配置文件*
``` sh
#!/bin/sh
postmap -q admin@hello.home mysql:/etc/postfix/mysql/virtual_mailbox_maps.cf
# 输出以下内容成功，使用同样方法测试多个配置文件是否工作正常
# hello.home/admin/
```

3. 修改文件 /etc/postfix/master.cf
``` properties
# 不能注释，不然无法收到邮件 25端口
smtp      inet  n       -       y       -       -       smtpd
#
#取消smtps的注释 使用465端口
smtps     inet  n       -       y       -       -       smtpd
#  -o syslog_name=postfix/smtps
  -o smtpd_tls_wrappermode=yes
#
# 添加以下行支持日志输出指定文件(4.3版本开始支持)
# postlog   unix-dgram n  -       n       -       1       postlogd
```

4. 修改文件 /etc/fstab
``` properties
# 映射mysql.sock文件,trivial-rewrite使用了chroot机制
# trivial-rewrite takes place in a chroot jail
/var/run/mysqld /var/spool/postfix/var/run/mysqld bind defaults,bind 0 0
```
#### Dovecot 配置
1. 修改文件 /etc/dovecot/dovecot.conf
``` properties
# 添加协议
protocols = imap pop3 lmtp
```

2. 修改文件 /etc/dovecot/conf.d/10-mail.conf
``` properties
mail_location = maildir:/var/mail/vmail/%d/%n
first_valid_uid = 8
```

3. 修改文件 /etc/dovecot/conf.d/10-auth.conf
``` properties
disable_plaintext_auth = no
auth_mechanisms = plain login
#
# 禁止使用系统认证
#!include auth-system.conf.ext
#
# 取消注释，启用sql认证方式
!include auth-sql.conf.ext
```

4. 修改文件 /etc/dovecot/conf.d/10-master.conf
``` properties
# 使用ssl认证
service imap-login {
  inet_listener imap {
    #port = 143
    # 禁用143端口
    port = 0
  }
  inet_listener imaps {
    port = 993
    ssl = yes
  }
}
#
service pop3-login {
  inet_listener pop3 {
    #port = 110
    # 禁用110端口
    port = 0
  }
  inet_listener pop3s {
    port = 995
    ssl = yes
  }
}
#
service lmtp {
  unix_listener /var/spool/postfix/private/dovecot-lmtp {
    mode = 0666
    user = postfix
    group = postfix
  }
}
#
service auth {
  # Postfix smtp-auth
  unix_listener /var/spool/postfix/private/auth {
    mode = 0666
    user = postfix
    group = postfix
  }
}
```

5. 修改文件 /etc/dovecot/conf.d/10-logging.conf
``` properties
log_path=/var/log/dovecot.log
```

6. 修改文件 /etc/dovecot/dovecot-sql.conf.ext
``` properties
driver = mysql
connect = host=localhost dbname=mailhome user=mail password=mail123
default_pass_scheme = MD5-CRYPT
password_query = SELECT username AS user,password FROM mailbox WHERE username = '%u' AND active='1'
#
user_query = SELECT CONCAT('/var/mail/vmail/', maildir) AS home, 8 as uid, 8 as gid, CONCAT('*:bytes=', quota) AS quota_rule FROM mailbox WHERE username = '%u' AND active = '1'
```

7. 修改文件 /etc/dovecot/10-ssl.conf
``` properties
# 使用加密通道
ssl = required
```

8. 替代证书链接 /etc/dovecot/private
``` sh
#!/bin/sh
rm /etc/dovecot/private/*
ln -s /etc/ssl/cers/domain.pem /etc/dovecot/private/dovecot.pem
ln -s /etc/ssl/private/domain.key /etc/dovecot/private/dovecot.key
```