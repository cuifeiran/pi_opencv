#!/bin/bash

echo "======1、更新系统======"
sudo apt-get update && sudo apt-get upgrade
echo "======2、安装依赖======"
sudo apt-get install -y build-essential cmake pkg-config
sudo apt-get install -y libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev
sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
sudo apt-get install -y libxvidcore-dev libx264-dev
sudo apt-get install -y libgtk2.0-dev libgtk-3-dev
sudo apt-get install -y libatlas-base-dev gfortran
sudo apt-get install -y python2.7-dev python3-dev
sudo apt-get install -y unzip
echo "======3、下载OpenCV======"
cd ~
wget -O opencv.zip https://github.com/Itseez/opencv/archive/3.3.0.zip
unzip opencv.zip
wget -O opencv_contrib.zip https://github.com/Itseez/opencv_contrib/archive/3.3.0.zip
unzip opencv_contrib.zip
 
echo "======4、安装Python包管理器======"
wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
sudo python3 get-pip.py

echo "======5、安装虚拟环境======"
sudo pip install virtualenv virtualenvwrapper
sudo rm -rf ~/.cache/pip

echo "======6、更新配置文件======"
cat >> ~/.profile << EOF
# virtualenv and virtualenvwrapper
export WORKON_HOME=\$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source /usr/local/bin/virtualenvwrapper.sh
EOF

echo "======7、创建并进入虚拟环境======"
source ~/.profile
mkvirtualenv cv -p python3

echo "======8、安装Numpy======"
pip install numpy

echo "======9、设置编译安装OpenCV参数======"
cd ~/opencv-3.3.0/
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib-3.3.0/modules \
    -D BUILD_EXAMPLES=ON ..


echo "======10、编译安装OpenCV准备======"
sed -i “s/CONF_SWAPSIZE=100/CONF_SWAPSIZE=1024/g” grep zhangsan -rl /etc/dphys-swapfile
sudo /etc/init.d/dphys-swapfile stop
sudo /etc/init.d/dphys-swapfile start

echo "======11、开始编译OpenCV======"
make -j2

echo "======11、开始编译OpenCV======"
sudo make install
sudo ldconfig

ls -l /usr/local/lib/python3.5/site-packages/


echo "======12、创建软链接======"
cd /usr/local/lib/python3.5/site-packages/
sudo mv cv2.cpython-35m-arm-linux-gnueabihf.so cv2.so
cd ~/.virtualenvs/cv/lib/python3.5/site-packages/
ln -s /usr/local/lib/python3.5/site-packages/cv2.so cv2.so

echo "======13、测试======"
source ~/.profile 
workon cv
python
import cv2
cv2.__version__
'3.3.0'
echo "======14、善后======"
sed -i “s/CONF_SWAPSIZE=1024/CONF_SWAPSIZE=100/g” grep zhangsan -rl /etc/dphys-swapfile
source /usr/local/bin/virtualenvwrapper.sh



