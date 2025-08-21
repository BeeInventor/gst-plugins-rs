#!/bin/sh

set -e

echo "Building Docker image..."
docker build --platform=linux/amd64 -t gst-plugins-rs-build .

echo "Creating temporary container..."
ID=$(docker create gst-plugins-rs-build)

# Clean up the container on exit
trap 'docker rm -v $ID > /dev/null' EXIT

echo "Copying plugin artifacts..."
mkdir -p ./output

# The webrtc plugin library
docker cp "$ID:/gst-plugins-rs/build.log" ./output/
docker cp "$ID:/usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstrswebrtc.so" ./output/
