#!/bin/bash

echo "------------------------------------------------------"
echo "Installing LHAPDF6 (Core Library & Data Sets)"
echo "------------------------------------------------------"

# --- Configuration ---
INSTALL_BASE="$HOME/Dependencies"
VERSION="6.5.5"
FILENAME="LHAPDF-${VERSION}.tar.gz"
SOURCE_URL="https://lhapdf.hepforge.org/downloads/$FILENAME"

PDF_SET="cteq6l1"
PDF_URL="http://lhapdfsets.web.cern.ch/lhapdfsets/current/${PDF_SET}.tar.gz"

# Ensure the Dependencies folder exists and navigate to it
mkdir -p "$INSTALL_BASE"
cd "$INSTALL_BASE"

# Clean up any previous failed attempts
rm -rf LHAPDF-src LHAPDF-install "$FILENAME"

echo "Downloading LHAPDF source code..."
wget -nc "$SOURCE_URL"

echo "Extracting LHAPDF..."
tar -zxvf "$FILENAME"
rm "$FILENAME"

# Organize Folders
mv "LHAPDF-$VERSION" LHAPDF-src
mkdir -p LHAPDF-install

# Configure and Compile
cd LHAPDF-src
echo "Configuring LHAPDF..."
./configure --prefix="$INSTALL_BASE/LHAPDF-install"

echo "Compiling LHAPDF (This may take a few minutes)..."
make -j"$(nproc)"

echo "Installing LHAPDF..."
make install

echo "------------------------------------------------------"
echo "Part 1 Complete: Core Library Installed."
echo "------------------------------------------------------"
echo "Part 2: Downloading PDF Data Sets ($PDF_SET)..."

DATA_PATH="$INSTALL_BASE/LHAPDF-install/share/LHAPDF"

# Navigate to the data directory created by the installation
if [ ! -d "$DATA_PATH" ]; then
    echo "Error: Directory $DATA_PATH does not exist. Installation may have failed."
    exit 1
fi

cd "$DATA_PATH"
wget -nc "$PDF_URL"
tar -zxvf "${PDF_SET}.tar.gz"
rm "${PDF_SET}.tar.gz"

echo "------------------------------------------------------"
echo "LHAPDF6 Installation Complete!"
echo "Check version by running: ~/Dependencies/LHAPDF-install/bin/lhapdf-config --version"
echo "------------------------------------------------------"
