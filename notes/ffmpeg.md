# ffmpeg转码

### 安装nVidia的CUDA
[参考](https://developer.nvidia.com/cuda-downloads)
``` sh
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
sudo add-apt-repository "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /"
sudo apt-get update
sudo apt-get -y install cuda
```

### 编译ffmpeg
**apt安装的不支持硬件加速**

``` sh
# 安装编译依赖库
sudo apt-get install mercurial yasm nasm cmake

# 定义输出目录
FF_CP_DIR=$HOME/compile \
FF_BUILD_DIR=$FF_CP_DIR/build \
FF_BIN_DIR=$FF_CP_DIR/build


# 下载编译h264源码
cd $FF_CP_DIR
git clone --depth 1 https://code.videolan.org/videolan/x264.git x264

cd ./x264
./configure --prefix=$FF_BUILD_DIR --bindir=$FF_BIN_DIR \
 --enable-shared --enable-static --enable-strip --disable-cli && \
make -j4 && make install


# 下载h265源码
cd $FF_CP_DIR
hg clone https://bitbucket.org/multicoreware/x265

cd ./x265
PATH="$FF_BIN_DIR:$PATH" cmake -G "Unix Makefiles"  -DCMAKE_INSTALL_PREFIX=$FF_BUILD_DIR -DBIN_INSTALL_DIR=$FF_BIN_DIR \
 -DENABLE_SHARED=on -DENABLE_ASSEMBLY=off -DENABLE_CLI=off ./source && \
 PATH="$FF_BIN_DIR:$FF_BUILD_DIR/lib:$PATH" make -j4 && make install

# 下载nvidia解码器
cd $FF_CP_DIR
git clone --depth=1 https://git.videolan.org/git/ffmpeg/nv-codec-headers.git

cd ./nv-codec-headers
make install PREFIX=$FF_BUILD_DIR

# 下载ffmpeg源码(调试中)
cd $FF_CP_DIR
git clone --depth=1 https://git.ffmpeg.org/ffmpeg.git ffmpeg

cd ./ffmpeg
PATH="$FF_BUILD_DIR:$PATH" PKG_CONFIG_PATH="$FF_BUILD_DIR/lib/pkgconfig" \
./configure \
--prefix=$FF_BUILD_DIR \
--bindir="$FF_BIN_DIR" \
--pkg-config-flags="--static" \
--extra-cflags="-I/usr/local/cuda/include" \
--extra-ldflags="-L/usr/local/cuda/lib64" \
--enable-pic --enable-shared \
--enable-cuda --enable-cuvid --enable-nvenc \
--enable-nonfree --enable-gpl  --enable-version3 \
--enable-libx264  --enable-libx265 \

  --enable-static --disable-pic \


PATH="$FF_BUILD_DIR:$PATH" PKG_CONFIG_PATH="$FF_BUILD_DIR/lib/pkgconfig" ./configure \
 --prefix=$FF_BUILD_DIR \
 --bindir="$FF_BIN_DIR" \
 --pkg-config-flags="--static" \
 --extra-cflags="-I/usr/local/cuda/include" \
 --extra-ldflags="-L/usr/local/cuda/lib64" \
 --enable-pic --enable-shared \
 --enable-cuda --enable-cuvid --enable-nvenc \
 --enable-gpl  --enable-version3  --enable-nonfree \
 --enable-ffmpeg  --disable-ffplay  --disable-ffprobe \
 --disable-doc  --disable-htmlpages  --disable-manpages  --disable-podpages  --disable-txtpages \
 --enable-libx264  --enable-libx265 \
 --disable-debug \
 --disable-opencl \
 --disable-thumb \
 --disable-stripping \
 --enable-encoder=libx265 \
 --enable-encoder=libx264 \
 --enable-decoder=h264 \
 --enable-encoder=aac \
 --enable-decoder=aac \
 --enable-encoder=ac3 \
 --enable-decoder=ac3 \
 --enable-encoder=rawvideo \
 --enable-decoder=rawvideo \
 --enable-muxer=flv \
 --enable-demuxer=flv \
 --enable-muxer=mp4 \
 --enable-demuxer=mpegvideo \
 --enable-muxer=matroska \
 --enable-demuxer=matroska \
 --enable-muxer=wav \
 --enable-demuxer=wav \
 --enable-muxer='pcm*' \
 --enable-demuxer='pcm*' \
 --enable-muxer=rawvideo \
 --enable-demuxer=rawvideo \
 --enable-parser=h264 \
 --enable-parser=aac \
 --enable-protocol=file \
 --enable-protocol=tcp \
 --enable-protocol=rtmp \
 --enable-protocol=hls \
 --enable-protocol=http \
 --enable-protocol=cache \
 --enable-protocol=pipe \
 --enable-filter=aresample \
 --enable-filter=allyuv \
 --enable-filter=scale \
 --enable-indev=v4l2 \
 --enable-indev=alsa

make  -j4 && make install
#--enable-hwaccel=h264_mmal \
#--enable-decoder=h264_mmal
```

# 添加l库链接 （否则会提示 error while loading shared libraries 错误）
#/etc/ld.so.conf 添加 /home/pi/ff_srcs/build/lib
#sudo ldconfig