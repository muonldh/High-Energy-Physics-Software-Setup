#!/bin/bash

echo "------------------------------------------------------"
echo "Installing PYTHIA 8.316"
echo "------------------------------------------------------"

# --- Configuration ---
INSTALL_BASE="$HOME/Dependencies"
VERSION="8316"  # Pythia uses '8316' in filenames for 8.316
FILENAME="pythia${VERSION}.tgz"
SOURCE_URL="https://pythia.org/download/pythia83/$FILENAME"

# 1. Ensure Dependencies folder exists and enter it
mkdir -p "$INSTALL_BASE"
cd "$INSTALL_BASE"

# 2. Clean up any previous failed attempts
rm -rf pythia8-src pythia8-install "$FILENAME"

# 3. Download
echo "Downloading Pythia 8 source code..."
wget -nc "$SOURCE_URL"

# 4. Extract
echo "Extracting Pythia 8..."
tar -zxvf "$FILENAME"
rm "$FILENAME"

# 5. Organize Folders
mv "pythia$VERSION" pythia8-src
mkdir -p pythia8-install

# 6. Configure and Compile
cd pythia8-src

echo "Configuring Pythia 8 (Linking LHAPDF6)..."
./configure --prefix="$INSTALL_BASE/pythia8-install" \
            --with-lhapdf6="$INSTALL_BASE/LHAPDF-install"

echo "Compiling Pythia 8 (This may take a few minutes)..."
make -j"$(nproc)"

echo "Installing Pythia 8..."
make install

echo "------------------------------------------------------"
echo "PYTHIA 8 Installation Complete!"
echo "Check version by running: ~/Dependencies/pythia8-install/bin/pythia8-config --version"
echo "------------------------------------------------------"
