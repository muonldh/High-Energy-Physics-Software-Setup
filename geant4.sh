#!/bin/bash

echo "------------------------------------------------------"
echo "Installing GEANT4 11.3.2"
echo "------------------------------------------------------"

# --- Configuration ---
INSTALL_BASE="$HOME/Dependencies"
VERSION="11.3.2" 
FILENAME="geant4-v${VERSION}.tar.gz"
SOURCE_URL="https://geant4-data.web.cern.ch/releases/$FILENAME"

# 1. Ensure Dependencies folder exists and enter it
mkdir -p "$INSTALL_BASE"
cd "$INSTALL_BASE"

# 2. Clean up any previous failed attempts
rm -rf geant4-src geant4-build geant4-install "$FILENAME" "geant4-v${VERSION}"

# 3. Download
echo "Downloading Geant4 source code..."
wget -nc "$SOURCE_URL"

# 4. Extract
echo "Extracting Geant4..."
tar -zxvf "$FILENAME"
rm "$FILENAME"

# 5. Organize Folders
mv "geant4-v${VERSION}" geant4-src

# Geant4 requires a completely separate build folder
mkdir -p geant4-build
mkdir -p geant4-install

# 6. Configure
cd geant4-build

echo "Configuring Geant4 with CMake..."
echo "Enabling OpenGL, GDML (System Xerces-C), and Multithreading."

cmake ../geant4-src \
      -DCMAKE_INSTALL_PREFIX="$INSTALL_BASE/geant4-install" \
      -DGEANT4_INSTALL_DATA=ON \
      -DGEANT4_BUILD_MULTITHREADED=ON \
      -DGEANT4_USE_GDML=ON \
      -DGEANT4_USE_OPENGL_X11=ON \
      -DGEANT4_USE_RAYTRACER_X11=ON \
      -DGEANT4_USE_SYSTEM_EXPAT=OFF \
      -DGEANT4_USE_QT=ON

# 7. Compile
echo "-------------------------------------------------------"
echo "STARTING COMPILATION."
echo "Note: The first step will download heavy physics datasets."
echo "This might take 15 to 45 minutes depending on your internet and CPU."
echo "-------------------------------------------------------"
make -j"$(nproc)"

# 8. Install
echo "Installing Geant4..."
make install

echo "------------------------------------------------------"
echo "GEANT4 Installation Complete!"
echo "Verify version by running: ~/Dependencies/geant4-install/bin/geant4-config --version"
echo "Verify datasets by running: ~/Dependencies/geant4-install/bin/geant4-config --check-datasets"
echo "------------------------------------------------------"
