#!/bin/bash

echo "------------------------------------------------------"
echo "Installing libxml2 2.15.1"
echo "------------------------------------------------------"

# --- Configuration ---
INSTALL_BASE="$HOME/Dependencies"
VERSION="2.15.1"
FILENAME="libxml2-${VERSION}.tar.xz"
SOURCE_URL="https://download.gnome.org/sources/libxml2/2.15/$FILENAME"

# 1. Ensure Dependencies folder exists and enter it
mkdir -p "$INSTALL_BASE"
cd "$INSTALL_BASE"

# 2. Clean up any previous failed attempts
rm -rf libxml2-src libxml2-install "$FILENAME" "libxml2-$VERSION"

# 3. Download
echo "Downloading libxml2 source code..."
wget -nc "$SOURCE_URL"

# 4. Extract (Note: 'J' flag is for .xz files)
echo "Extracting libxml2..."
tar -xJvf "$FILENAME"
rm "$FILENAME"

# 5. Organize Folders
mv "libxml2-$VERSION" libxml2-src
mkdir -p libxml2-install

# 6. Configure and Compile
cd libxml2-src

echo "Configuring libxml2 (Disabling Python bindings)..."
./configure --prefix="$INSTALL_BASE/libxml2-install" --without-python

echo "Compiling libxml2 (This may take a minute)..."
make -j"$(nproc)"

echo "Installing libxml2..."
make install

echo "------------------------------------------------------"
echo "libxml2 Installation Complete!"
echo "Check version by running: ~/Dependencies/libxml2-install/bin/xml2-config --version"
echo "------------------------------------------------------"
