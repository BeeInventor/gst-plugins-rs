FROM rust:1.82-slim

RUN apt update && apt install -y \
    git \
    pkg-config \
    libssl-dev \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libgstreamer-plugins-bad1.0-dev

RUN git clone https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs.git
WORKDIR /gst-plugins-rs

RUN cargo install cargo-c
RUN cargo cbuild -p gst-plugin-webrtc
RUN cargo cinstall -p gst-plugin-webrtc

WORKDIR /usr/local/lib64/gstreamer-1.0

ENTRYPOINT [ "/bin/sh" ]
