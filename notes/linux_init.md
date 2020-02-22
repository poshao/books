# Linux系统常见配置

[toc]

#### 安装中文语言包
``` shell
sudo apt-get install language-pack-zh-hans
```

#### 设置sudo免密码
``` sh
sudo sed -i 's/^%sudo/%sudo ALL=(ALL) NOPASSWD: ALL\n#%sudo/' /etc/sudoers
```

