# SSH 基本配置

## 安装
``` shell
sudo apt-get install openssh
```

## 基本应用
``` shell
# 生成秘钥
ssh-keygen -t rsa

# 复制公钥到服务器
ssh-copy-id root@127.0.0.1
```

## ssh配置文件
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