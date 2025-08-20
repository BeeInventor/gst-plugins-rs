FROM rust:1.87-slim

# https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/tree/main/net/webrtc?ref_type=heads
RUN apt update && apt install -y \
    git \
    pkg-config \
    libssl-dev \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libgstreamer-plugins-bad1.0-dev

RUN git clone https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs.git
WORKDIR /gst-plugins-rs

RUN git checkout 0.14.1

RUN cargo install cargo-c
RUN cargo cbuild -p gst-plugin-webrtc --features livekit
RUN cargo cinstall -p gst-plugin-webrtc --features livekit

WORKDIR /usr/local/lib/gstreamer-1.0

ENTRYPOINT [ "/bin/sh" ]
