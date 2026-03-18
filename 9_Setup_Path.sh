#!/bin/bash

# ==============================================================================
# --- PART 1: THE INSTALLER (Runs when the user types 'bash setup_env.sh') ---
# ==============================================================================

# Check if the script is being executed directly rather than sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "------------------------------------------------------"
    echo "🛠️  Installing HEP Environment to ~/.bashrc..."
    echo "------------------------------------------------------"

    # Get the absolute path of wherever the user downloaded this script
    SCRIPT_PATH="$(realpath "$0")"
    BASHRC_FILE="$HOME/.bashrc"
    SOURCE_LINE="source \"$SCRIPT_PATH\""

    # Check if it's already installed to prevent duplicate lines
    if grep -Fxq "$SOURCE_LINE" "$BASHRC_FILE"; then
        echo "✅ Already installed in ~/.bashrc! You are good to go."
    else
        # Inject the path into the user's .bashrc
        echo "" >> "$BASHRC_FILE"
        echo "# Auto-load JUNO HEP Environment" >> "$BASHRC_FILE"
        echo "$SOURCE_LINE" >> "$BASHRC_FILE"
        echo "✅ Successfully added to ~/.bashrc!"
    fi

    echo "------------------------------------------------------"
    echo "🎉 ALL DONE! Your paths are permanently set."
    echo "To apply changes right now, close this terminal and open a new one."
    echo "Or run: source ~/.bashrc"
    echo "------------------------------------------------------"
    
    # Stop the script here so it doesn't try to load everything in the temporary installer shell
    exit 0
fi

# ==============================================================================
# --- PART 2: THE ENVIRONMENT (Runs automatically every time a terminal opens) ---
# ==============================================================================

# Only print UI messages if this is an interactive terminal (a human is watching)
if [[ $- == *i* ]]; then
    echo "------------------------------------------------------"
    echo "⚛️  Loading High Energy Physics Environment..."
fi

export DEPS_DIR="$HOME/Dependencies"

# 1. ROOT Setup
if [ -f "$DEPS_DIR/root-install/bin/thisroot.sh" ]; then
    source "$DEPS_DIR/root-install/bin/thisroot.sh"
    [[ $- == *i* ]] && echo "  ✅ ROOT Loaded"
else
    [[ $- == *i* ]] && echo "  ❌ ROOT NOT FOUND!"
fi

# 2. Geant4 Setup
if [ -f "$DEPS_DIR/geant4-install/bin/geant4.sh" ]; then
    source "$DEPS_DIR/geant4-install/bin/geant4.sh"
    [[ $- == *i* ]] && echo "  ✅ Geant4 Loaded"
else
    [[ $- == *i* ]] && echo "  ❌ Geant4 NOT FOUND!"
fi

# 3. GENIE & External Libraries Setup
export GENIE="$DEPS_DIR/genie-install"
export PYTHIA8_DIR="$DEPS_DIR/pythia8-install"
export LHAPDF_DIR="$DEPS_DIR/LHAPDF-install"
export LIBXML2_DIR="$DEPS_DIR/libxml2-install"

if [ -d "$GENIE/bin" ]; then
    export PATH="$GENIE/bin:$PATH"
    export LD_LIBRARY_PATH="$GENIE/lib:$PYTHIA8_DIR/lib:$LHAPDF_DIR/lib:$LIBXML2_DIR/lib:/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH"
    [[ $- == *i* ]] && echo "  ✅ GENIE & External Libraries Loaded"
else
    [[ $- == *i* ]] && echo "  ❌ GENIE NOT FOUND!"
fi

# 4. CMake Prefix Path
export CMAKE_PREFIX_PATH="$DEPS_DIR/geant4-install:$DEPS_DIR/root-install:$CMAKE_PREFIX_PATH"

# 5. Python Environment Instructions
if [[ $- == *i* ]]; then
    echo "------------------------------------------------------"
    echo "🐍 Python Analysis Environment:"
    echo "   To ACTIVATE, type:   source ~/hep-env/bin/activate"
    echo "   To DEACTIVATE, type: deactivate"
    echo "------------------------------------------------------"
fi
