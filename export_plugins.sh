#!/bin/sh

set -e

echo "Building Docker image..."
docker build -t gst-plugins-rs-build .

echo "Creating temporary container..."
ID=$(docker create gst-plugins-rs-build)

# Clean up the container on exit
trap 'docker rm -v $ID > /dev/null' EXIT

echo "Copying plugin artifacts..."
mkdir -p ./output

# The webrtc plugin library
docker cp "$ID:/usr/local/lib/gstreamer-1.0/libgstrswebrtc.so" ./output/

# The livekit plugin library (contains livekitwebrtcsrc element)
# docker cp "$ID:/usr/local/lib/gstreamer-1.0/libgstlivekit.so" ./output/

echo "Plugins successfully exported to ./output directory."
