# --- HEP Environment Setup ---
echo "------------------------------------------------------"
echo "Loading High Energy Physics Environment"
echo "------------------------------------------------------"

export DEPS_DIR="$HOME/Dependencies"

# 1. ROOT Setup
if [ -f "$DEPS_DIR/root-install/bin/thisroot.sh" ]; then
    source "$DEPS_DIR/root-install/bin/thisroot.sh"
    echo "✅ ROOT Loaded"
else
    echo "❌ ROOT NOT FOUND!"
fi

# 2. Geant4 Setup
if [ -f "$DEPS_DIR/geant4-install/bin/geant4.sh" ]; then
    source "$DEPS_DIR/geant4-install/bin/geant4.sh"
    echo "✅ Geant4 Loaded"
else
    echo "❌ Geant4 NOT FOUND!"
fi

# 3. GENIE & External Libraries Setup
export GENIE="$DEPS_DIR/genie-install"
export PYTHIA8_DIR="$DEPS_DIR/pythia8-install"
export LHAPDF_DIR="$DEPS_DIR/LHAPDF-install"
export LIBXML2_DIR="$DEPS_DIR/libxml2-install"

if [ -d "$GENIE/bin" ]; then
    export PATH="$GENIE/bin:$PATH"
    
    # Bundle all custom libraries and the Ubuntu system path
    export LD_LIBRARY_PATH="$GENIE/lib:$PYTHIA8_DIR/lib:$LHAPDF_DIR/lib:$LIBXML2_DIR/lib:/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH"
    echo "✅ GENIE & External Libraries Loaded"
else
    echo "❌ GENIE NOT FOUND!"
fi

# 4. CMake Prefix Path (For future physics software compilation)
# Note: xerces-c is handled natively by Ubuntu apt packages
export CMAKE_PREFIX_PATH="$DEPS_DIR/geant4-install:$DEPS_DIR/root-install:$CMAKE_PREFIX_PATH"

# 5. Python Environment Instructions
echo "------------------------------------------------------"
echo "🐍 Python Analysis Environment:"
echo "   To activate, type:   source ~/hep-env/bin/activate"
echo "   To deactivate, type: deactivate"
echo "------------------------------------------------------"
