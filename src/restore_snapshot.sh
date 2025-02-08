#!/usr/bin/env bash

set -e 

# Quit script if snapshot file doesn't exist

if [ ! -f /snapshot.json ]; then
    echo "runpod-worker-comfy: No snapshot file found. Exiting..."
    exit 0
fi

cd /comfyui/

# Install ComfyUI-Manager
git clone https://github.com/ltdrdata/ComfyUI-Manager.git custom_nodes/ComfyUI-Manager
cd custom_nodes/ComfyUI-Manager
git checkout 22878f4ef848b93f908e2a938e27b09ec0630224
pip install -r requirements.txt

# Install ComfyUI_Comfyroll_CustomNodes
cd ..
git clone https://github.com/ltdrdata/ComfyUI_Comfyroll_CustomNodes.git custom_nodes/ComfyUI_Comfyroll_CustomNodes
cd ComfyUI_Comfyroll_CustomNodes
git checkout d78b780ae43fcf8c6b7c6505e6ffb4584281ceca

# Move snapshot file to startup-scripts
mv /snapshot.json snapshots/restore-snapshot.json

cd ../..

# Trigger restoring of the snapshot by performing a quick test run
# Note: We need to use `yes` as some custom nodes may try to install dependencies with pip
/usr/bin/yes | python3 main.py --cpu --quick-test-for-ci