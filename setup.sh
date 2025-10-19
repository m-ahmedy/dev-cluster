#!/bin/bash

./setup-proxy.sh
./setup-kind-cluster.sh

echo "✅ Setup complete!"
echo ""
echo "🎯 Universal Registry Proxy is running:"
echo ""
echo "🧪 Test with different registries:"
echo "   kubectl create deployment nginx --image=nginx:alpine"
echo "   kubectl create deployment prometheus --image=quay.io/prometheus/prometheus:latest"
echo "   kubectl create deployment pause --image=registry.k8s.io/pause:3.8"
echo ""
