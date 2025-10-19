#!/bin/bash

# Ensure registry data directory exists and has proper permissions

pushd $PWD/proxy

echo "🐳 Starting universal registry proxy..."

docker compose down

sudo rm -rf configs
python generate.py

docker compose up -d
popd 
