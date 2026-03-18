#!/bin/bash

echo "------------------------------------------------------"
echo "Installing GENIE (R-3_06_02)"
echo "------------------------------------------------------"

# --- 1. Define Library Locations ---
export INSTALL_BASE="$HOME/Dependencies"
export ROOT_DIR="$INSTALL_BASE/root-install"
export LHAPDF_DIR="$INSTALL_BASE/LHAPDF-install"
export LIBXML2_DIR="$INSTALL_BASE/libxml2-install"
export PYTHIA8_DIR="$INSTALL_BASE/pythia8-install"
export GEANT4_DIR="$INSTALL_BASE/geant4-install"

# --- 2. Source ROOT and GEANT4 (CRITICAL) ---
source "$ROOT_DIR/bin/thisroot.sh"
source "$GEANT4_DIR/bin/geant4.sh"

# --- 3. Export Libraries so the compiler can find them ---
export LD_LIBRARY_PATH="$PYTHIA8_DIR/lib:$GEANT4_DIR/lib:$LHAPDF_DIR/lib:$LIBXML2_DIR/lib:/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH"

# --- 4. Clean and Download ---
cd "$INSTALL_BASE"
rm -rf genie-src genie-install

git clone https://github.com/GENIE-MC/Generator.git genie-src
cd genie-src
git checkout "R-3_06_02"

# --- 5. COMPILER SETUP & EXPORT GENIE (CRITICAL FIX 1) ---
export CXX=g++
export CC=gcc
export GENIE="$INSTALL_BASE/genie-src"

# Explicitly link GSL
export LDFLAGS="-L/usr/lib/x86_64-linux-gnu -lgsl -lgslcblas"

# --- 6. Configure Array ---
GENIE_FLAGS=(
  "--prefix=$INSTALL_BASE/genie-install"
  "--disable-pythia6"
  "--enable-gsl"
  "--with-gsl-inc=/usr/include"
  "--with-gsl-lib=/usr/lib/x86_64-linux-gnu"
  "--enable-rwght"
  "--enable-lhapdf6"
  "--with-lhapdf6-lib=$LHAPDF_DIR/lib"
  "--with-lhapdf6-inc=$LHAPDF_DIR/include"
  "--with-libxml2-inc=$LIBXML2_DIR/include/libxml2"
  "--with-libxml2-lib=$LIBXML2_DIR/lib"
  "--with-log4cpp-inc=/usr/include"
  "--with-log4cpp-lib=/usr/lib/x86_64-linux-gnu"
  "--enable-pythia8"
  "--with-pythia8-lib=$PYTHIA8_DIR/lib"
  "--with-pythia8-inc=$PYTHIA8_DIR/include"
  "--enable-geant4"
  "--with-geant4-lib=$GEANT4_DIR/lib"
  "--with-geant4-inc=$GEANT4_DIR/include"
  "--enable-flux-drivers"
  "--enable-geom-drivers"
  "--enable-nucleon-decay"
  "--enable-nnbar-oscillation"
  "--enable-boosted-dark-matter"
  "--enable-heavy-neutral-lepton"
  "--enable-dark-neutrino"
  "--enable-atmo"
  "--enable-validation-tools"
  "--enable-test"
)

# --- 7. Configure, Build, and Install ---
./configure "${GENIE_FLAGS[@]}"

mkdir -p "$GENIE/bin"

# THE RACE CONDITION FIX: Chain Build
echo "Building GENIE (Engaging Race Condition Failsafes)..."
make all -j"$(nproc)" || make all -j"$(nproc)" || make all -j1

if [ ! -f "$GENIE/bin/gevgen" ]; then
    echo "CRITICAL ERROR: 'gevgen' was not created. GENIE silently skipped building the Apps."
    exit 1
fi

make install

echo "Applying post-installation patches..."
cp -r "$INSTALL_BASE/genie-src/config" "$INSTALL_BASE/genie-install/"
cp -r "$INSTALL_BASE/genie-src/data" "$INSTALL_BASE/genie-install/"
sed -i 's/Pythia6/Pythia8/g' "$INSTALL_BASE/genie-install/config/"*.xml

echo "------------------------------------------------------"
echo "GENIE Installation Complete!"
echo "------------------------------------------------------"
