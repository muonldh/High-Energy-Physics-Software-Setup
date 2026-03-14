#!/bin/bash

echo "------------------------------------------------------"
echo "Installing ROOT 6.36.04"
echo "------------------------------------------------------"

# --- Configuration ---
INSTALL_BASE="$HOME/Dependencies"
VERSION="6.36.04" 
FILENAME="root_v${VERSION}.source.tar.gz"
SOURCE_URL="https://root.cern/download/$FILENAME"

# --- Define Paths to Custom Physics Installations ---
export LHAPDF="$INSTALL_BASE/LHAPDF-install"
export PYTHIA8="$INSTALL_BASE/pythia8-install"

# Safely export the path list for CMake (Xerces and libxml2 are handled by the OS)
export CMAKE_PREFIX_PATH="$LHAPDF:$PYTHIA8"

# 1. Ensure Dependencies folder exists and enter it
mkdir -p "$INSTALL_BASE"
cd "$INSTALL_BASE"

# 2. Clean up old source archives 
# (NOTE: We deliberately DO NOT delete root-build to allow resuming if interrupted)
rm -rf root-src "$FILENAME" "root-${VERSION}"

# 3. Download
echo "Downloading ROOT source code..."
wget -nc "$SOURCE_URL"

# 4. Extract
echo "Extracting ROOT..."
tar -zxvf "$FILENAME"
rm "$FILENAME"

# 5. Organize Folders
mv "root-${VERSION}" root-src

# 6. Prepare Directories
mkdir -p root-build
mkdir -p root-install

# 7. Configure
cd root-build

echo "Configuring ROOT with CMake..."
cmake ../root-src \
  -DCMAKE_INSTALL_PREFIX="../root-install" \
  -DCMAKE_BUILD_TYPE=Release \
  -Dgdml=ON \
  -Dxml=ON \
  -Dmathmore=ON \
  -Droofit=ON \
  -Droofit_multiprocess=OFF \
  -Dtmva=ON \
  -Dtmva-cpu=ON \
  -Dunuran=ON \
  -Dvdt=ON \
  -Dfftw3=ON \
  -Dgraphviz=ON \
  -Dmysql=ON \
  -Dpythia8=ON \
  -DPYTHIA8_DIR="$PYTHIA8" \
  -Dbuiltin_glew=ON \
  -Dbuiltin_ftgl=OFF \
  -Dbuiltin_gl2ps=ON \
  -Dsoversion=ON

# 8. Compile
echo "-------------------------------------------------------"
echo "STARTING COMPILATION."
echo "This will take 30 to 60 minutes. Grab a coffee."
echo "-------------------------------------------------------"
make -j"$(nproc)"

# 9. Install
echo "Installing ROOT..."
make install

echo "------------------------------------------------------"
echo "ROOT Installation Complete!"
echo "Check version by running: ~/Dependencies/root-install/bin/root-config --version"
echo "------------------------------------------------------"
