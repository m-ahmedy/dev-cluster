#!/bin/bash

cluster_name="${1:-dev-cluster}"
cluster_config_file="${2:-k3d-dev-cluster.yaml}"

# Create k3d cluster

pushd $PWD/k3d

echo "🏗️ Creating k3d cluster with universal proxy..."

k3d cluster delete $cluster_name 2>/dev/null || true

k3d cluster create --config $cluster_config_file

popd
