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

# 2. SAFE CLEANUP: We deliberately DO NOT delete geant4-build or geant4-install.
# This ensures that if the script is restarted, progress is saved.
rm -rf "$FILENAME" "geant4-v${VERSION}"

# 3. Download (Only if source folder doesn't already exist)
if [ ! -d "geant4-src" ]; then
    echo "Downloading Geant4 source code..."
    wget -nc "$SOURCE_URL"

    echo "Extracting Geant4..."
    tar -zxvf "$FILENAME"
    rm "$FILENAME"
    mv "geant4-v${VERSION}" geant4-src
else
    echo "Geant4 source code already extracted. Skipping download..."
fi

# 4. Prepare Directories
mkdir -p geant4-build
mkdir -p geant4-install

# 5. Configure
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

# 6. Compile with AUTO-RESUME LOOP
echo "-------------------------------------------------------"
echo "STARTING COMPILATION."
echo "Note: The first step will download heavy physics datasets."
echo "If the CERN server drops the connection, this script will automatically resume."
echo "-------------------------------------------------------"

# Try to compile. If it fails (due to network drop), retry up to 5 times.
RETRY_COUNT=0
MAX_RETRIES=5

until make -j"$(nproc)"; do
    RETRY_COUNT=$((RETRY_COUNT+1))
    if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
        echo "Compilation failed after $MAX_RETRIES attempts. Please check your internet connection and run the script again."
        exit 1
    fi
    echo "-------------------------------------------------------"
    echo "CERN server dropped the connection! Auto-resuming (Attempt $RETRY_COUNT of $MAX_RETRIES)..."
    echo "-------------------------------------------------------"
    sleep 5
done

# 7. Install
echo "Installing Geant4..."
make install

echo "------------------------------------------------------"
echo "GEANT4 Installation Complete!"
echo "Verify version by running: ~/Dependencies/geant4-install/bin/geant4-config --version"
echo "Verify datasets by running: ~/Dependencies/geant4-install/bin/geant4-config --check-datasets"
echo "------------------------------------------------------"
