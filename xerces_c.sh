#!/bin/bash

echo "------------------------------------------------------"
echo "Installing Xerces-C 3.2.5"
echo "------------------------------------------------------"

# --- Configuration ---
INSTALL_BASE="$HOME/Dependencies"
VERSION="3.2.5"
FILENAME="xerces-c-${VERSION}.tar.gz"
SOURCE_URL="https://archive.apache.org/dist/xerces/c/3/sources/$FILENAME"

# 1. Ensure Dependencies folder exists and enter it
mkdir -p "$INSTALL_BASE"
cd "$INSTALL_BASE"

# 2. Clean up any previous failed attempts
rm -rf xerces-c-src xerces-c-install "$FILENAME" "xerces-c-$VERSION"

# 3. Download
echo "Downloading Xerces-C source code..."
wget -nc "$SOURCE_URL"

# 4. Extract
echo "Extracting Xerces-C..."
tar -zxvf "$FILENAME"
rm "$FILENAME"

# 5. Organize Folders
mv "xerces-c-$VERSION" xerces-c-src
mkdir -p xerces-c-install

# 6. Configure and Compile
cd xerces-c-src

echo "Configuring Xerces-C..."
./configure --prefix="$INSTALL_BASE/xerces-c-install"

echo "Compiling Xerces-C (This may take a minute)..."
make -j"$(nproc)"

echo "Installing Xerces-C..."
make install

echo "------------------------------------------------------"
echo "Xerces-C Installation Complete!"
echo "Check installation by running: ls -l ~/Dependencies/xerces-c-install/lib/libxerces-c.so"
echo "------------------------------------------------------"
