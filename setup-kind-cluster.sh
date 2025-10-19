#!/bin/bash

cluster_config_file="${2:-kind-dev-cluster.yaml}"

# Create kind cluster

pushd $PWD/kind

echo "🏗️ Creating kind cluster with universal proxy..."

kind delete cluster --config $cluster_config_file 2>/dev/null || true

kind create cluster --config $cluster_config_file --retain

popd
