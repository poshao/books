# Linux网络工程模拟软件GNS3安装说明

### GNS安装
``` shell
sudo add-apt-repository ppa:gns3/ppa
sudo apt update
sudo apt install gns3-gui gns3-server
```
### IOU支持
``` shell
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install gns3-iou
```

### Docker-CE安装
``` shell
# 卸载旧版本
sudo apt-get remove docker docker-engine docker.io containerd runc

# 安装支持库
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# 添加密钥
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# 添加软件包库 bionic根据实际的版本自行替换
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   bionic \
   stable"
# 若以上步骤失败可手动添加
# sudo echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" > /etc/apt/sources.list.d/docker.list


sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
```

### VirtualBox安装
``` shell
# 下载

wget https://download.virtualbox.org/virtualbox/6.1.0/virtualbox-6.1_6.1.0-135406~Ubuntu~bionic_amd64.deb

```
### VM镜像下载
``` shell
wget https://github.com/GNS3/gns3-gui/releases/download/v2.2.3/GNS3.VM.VirtualBox.2.2.3.zip
```
使用VMware Player导入镜像文件

### 思科IOS下载
[系统镜像文件](https://drive.google.com/open?id=1KwVl6SgKky6gr20Z4pk6wpnLQcyNB9PM)

