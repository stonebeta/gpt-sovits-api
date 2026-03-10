#!/bin/sh
set -e

CONFIG_DIR=$(dirname "$CONFIG_PATH")

if [ ! -f "$CONFIG_PATH" ]; then
    echo "Config not found, copying default..."
    mkdir -p "$CONFIG_DIR"
    cp /GPT-SoVITS/GPT_SoVITS/configs/tts_infer.yaml "$CONFIG_PATH"
    chown ${PUID}:${PGID} "$CONFIG_DIR" "$CONFIG_PATH"
fi

exec python api_v2.py -a 0.0.0.0 -p 9880 -c "$CONFIG_PATH"

