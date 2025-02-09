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
git checkout 411c0633a3d542ac20ea8cb47c9578f22fb19854
pip install -r requirements.txt

# Install ComfyUI_Comfyroll_CustomNodes
cd ../..
git clone https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes.git custom_nodes/ComfyUI_Comfyroll_CustomNodes
cd custom_nodes/ComfyUI_Comfyroll_CustomNodes
git checkout d78b780ae43fcf8c6b7c6505e6ffb4584281ceca

# Install ComfyUI-BRIA_AI-RMBG
cd ../..
git clone https://github.com/ZHO-ZHO-ZHO/ComfyUI-BRIA_AI-RMBG.git custom_nodes/ComfyUI-BRIA_AI-RMBG
cd custom_nodes/ComfyUI-BRIA_AI-RMBG
git checkout 827fcd63ff0cfa7fbc544b8d2f4c1e3f3012742d

# Move snapshot file to startup-scripts
#mv /snapshot.json snapshots/restore-snapshot.json

cd ../..

# Trigger restoring of the snapshot by performing a quick test run
# Note: We need to use `yes` as some custom nodes may try to install dependencies with pip
/usr/bin/yes | python3 main.py --cpu --quick-test-for-ci