#!/bin/bash

echo "------------------------------------------------------"
echo "Setting up Python 3 for High Energy Physics"
echo "------------------------------------------------------"

# Define the generic environment name
ENV_NAME="hep-env"
ENV_PATH="$HOME/$ENV_NAME"

# --- 1. Install System Python Dependencies ---
echo "Installing Python 3 development headers and venv (requires sudo)..."
sudo apt-get update
sudo apt-get install -y python3 python3-pip python3-dev python3-venv

# --- 2. Create the Virtual Environment ---
echo "Creating isolated Python environment named '$ENV_NAME'..."
# Clean up any broken previous attempts
rm -rf "$ENV_PATH"
python3 -m venv "$ENV_PATH"

# --- 3. Install Physics Packages inside the Virtual Environment ---
echo "Installing standard physics libraries (uproot, awkward, etc.)..."
echo "This will install safely into the sandbox, keeping your core OS clean."

# We explicitly use the pip inside the new environment to guarantee isolation
"$ENV_PATH/bin/pip" install --upgrade pip
"$ENV_PATH/bin/pip" install numpy scipy matplotlib pandas uproot awkward

echo "------------------------------------------------------"
echo "Python 3 Setup Complete!"
echo "------------------------------------------------------"
echo ""
echo "To ACTIVATE your new physics environment, run this command:"
echo "    source ~/$ENV_NAME/bin/activate"
echo ""
echo "When activated, your terminal prompt will start with ($ENV_NAME)."
echo "To DEACTIVATE and return to normal Ubuntu, simply type:"
echo "    deactivate"
echo ""
echo "------------------------------------------------------"
