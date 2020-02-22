# Composer 安装使用

## 安装
``` sh
#!/bin/sh
apt-get install composer
# 使用aliyun镜像
composer config -g repo.packagist composer https://packagist.phpcomposer.com

# 解除镜像
# composer config -g --unset repos.packagist

```