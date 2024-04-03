#!/bin/bash

IMAGE_TAG="$1"  # Use the first command-line argument as image tag

# Check if image tag is provided
if [ -z "$IMAGE_TAG" ]; then
  echo "Error: Image tag not provided."
  exit 1
fi

# Check if kubectl is installed
if ! [ -x "$(command -v kubectl)" ]; then
  echo 'Error: kubectl is not installed.' >&2
  exit 1
fi

# Check if Helm is installed
if ! [ -x "$(command -v helm)" ]; then
  echo 'Error: Helm is not installed.' >&2
  exit 1
fi

# Step 1: Add Helm repository
helm repo add bgs https://tienpa2896.github.io/charts/java-app

# Step 2: Update Helm repositories
helm repo update

# Step 3: Define variables
RELEASE_NAME=$2
CHART_NAME="bgs/java-app"
VALUES_FILE="${RELEASE_NAME}/${RELEASE_NAME}.yaml"

# Step 4: Install or upgrade chart with values
helm upgrade --install $RELEASE_NAME -f $VALUES_FILE $CHART_NAME  --set image.tag=$IMAGE_TAG

# Step 5: Wait for pods to be deployed
echo "Waiting for pods to be deployed..."

# Step 6: Check deployment status with interval and timeout
TIMEOUT=120  # 2 minutes timeout
INTERVAL=10  # Check interval in seconds

elapsed_time=0
while true; do
  if [[ $elapsed_time -gt $TIMEOUT ]]; then
    echo "Deployment timed out."
    kubectl logs deployment/$RELEASE_NAME  # Show deployment logs
    exit 1
  fi

  if kubectl get pods | grep $RELEASE_NAME | grep -q '1/1'; then
    echo "Deployment succeeded."
    exit 0
  fi

  sleep $INTERVAL
  elapsed_time=$((elapsed_time + INTERVAL))
done