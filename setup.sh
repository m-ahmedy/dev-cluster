#!/bin/bash

# Ensure registry data directory exists and has proper permissions

pushd $PWD/proxy

echo "🐳 Starting universal registry proxy..."

docker compose down

sudo rm -rf configs
python generate.py

docker compose up -d
popd 

# Create k3d cluster

pushd $PWD/k3d

echo "🏗️ Creating k3d cluster with universal proxy..."

k3d cluster delete dev-cluster 2>/dev/null || true

k3d cluster create --config k3d-dev-cluster.yaml

popd

echo "✅ Setup complete!"
echo ""
echo "🎯 Universal Registry Proxy is running:"
echo ""
echo "🧪 Test with different registries:"
echo "   kubectl create deployment nginx --image=nginx:alpine"
echo "   kubectl create deployment prometheus --image=quay.io/prometheus/prometheus:latest"
echo "   kubectl create deployment pause --image=registry.k8s.io/pause:3.8"
echo ""
