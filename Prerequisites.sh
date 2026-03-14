#!/bin/bash

echo "------------------------------------------------------"
echo "Installing JUNO HEP Prerequisites (Ubuntu 24.04)"
echo "------------------------------------------------------"

# 1. Update repositories
echo "Updating package lists and enabling Universe repository..."
sudo apt update
sudo add-apt-repository -y universe
sudo apt update

# 2. Install all required dependencies
echo "Installing compilers, Python, graphics, and math libraries..."
sudo apt install -y build-essential autoconf automake cmake make libtool \
g++ gcc gfortran binutils git rsync dpkg-dev libdpkg-perl \
python3 python3-dev python-is-python3 python3-numpy \
libx11-dev libxpm-dev libxft-dev libxext-dev libmotif-dev libxmu-dev libxt-dev libxi-dev \
libglu1-mesa-dev libgl1-mesa-dev libglew-dev libftgl-dev graphviz-dev libgraphviz-dev \
qtbase5-dev libqt5opengl5-dev \
libpng-dev libjpeg-dev libtiff-dev libgif-dev \
libgsl-dev libfftw3-dev libtbb-dev liblog4cpp5-dev \
libssl-dev openssl libcurl4-openssl-dev davix-dev \
libmysqlclient-dev libpq-dev libldap-dev \
libxml2-dev libxerces-c-dev libpcre3-dev \
libavahi-compat-libdnssd-dev zlib1g-dev

# 3. Create a dedicated directory for our HEP software
echo "Creating ~/Dependencies workspace..."
mkdir -p "$HOME/Dependencies"

echo "------------------------------------------------------"
echo "Prerequisites Installed Successfully!"
echo "Please navigate to your workspace using: cd ~/Dependencies"
echo "------------------------------------------------------"
