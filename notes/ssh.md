# SSH 基本配置

## 安装
``` shell
sudo apt-get install openssh
```

## 常见应用

#### 使用秘钥登录

``` shell
# 生成秘钥
ssh-keygen -t rsa

# 复制公钥到服务器
ssh-copy-id root@127.0.0.1
```

#### ssh快捷登录配置
创建文件 **~/.ssh/config**

```
Host s1
    HostName 192.168.10.3
    User root
    Port 22

Host s2
    HostName 192.168.10.4
    User root
    Port 22
```
按上面配置后可以通过<code>ssh s1</code>快捷登录

#### 使用root账户登录

``` sh
# 解锁root账户, 可以通过 sudo passwd root --lock 重新锁定
sudo passwd root --unlock
```

修改配置文件 /etc/ssh/sshd_config

找到**PermitRootLogin prohibit-password**注释掉并添加**PermitRootLogin yes**

重启sshd服务<code>sudo service sshd restart</code>即可使用root远程登录