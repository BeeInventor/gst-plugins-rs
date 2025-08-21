ARG TARGETPLATFORM
FROM rust:1.87-slim

# https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/tree/main/net/webrtc?ref_type=heads
RUN apt update && apt install -y \
    git \
    pkg-config \
    gstreamer1.0-tools \
    libssl-dev \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libgstreamer-plugins-bad1.0-dev \
    libnice-dev \
    libsoup2.4-dev

# Set environment variables for build and runtime
ENV PKG_CONFIG_PATH="/usr/lib/$(uname -m)-linux-gnu/pkgconfig:/usr/share/pkgconfig:/usr/local/lib/pkgconfig"
ENV LD_LIBRARY_PATH="/usr/lib/$(uname -m)-linux-gnu:/usr/local/lib"

RUN git clone https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs.git
WORKDIR /gst-plugins-rs

RUN git checkout 0.14.1

RUN rm -f build.log && cargo build -p gst-plugin-webrtc --features livekit --release >> build.log 2>&1
RUN cp target/release/libgstrswebrtc.so /usr/lib/x86_64-linux-gnu/gstreamer-1.0/
RUN gst-inspect-1.0 rswebrtc >> build.log 2>&1

ENTRYPOINT [ "/bin/sh" ]
