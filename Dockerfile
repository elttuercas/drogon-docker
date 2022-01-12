FROM docker.io/ubuntu:21.10

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends gcc-11 g++-11 \
    software-properties-common curl wget pkg-config locales \
    git build-essential openssl libssl-dev libjsoncpp-dev \
    uuid-dev zlib1g-dev libc-ares-dev postgresql-server-dev-all\
    libmariadb-dev libbrotli-dev libhiredis-dev libsqlite3-dev \
    npm libsodium-dev && locale-gen en_US.UTF-8 && \
    npm install -g n && n latest

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    CC=/usr/bin/gcc-11 \
    CXX=/usr/bin/g++-11 \
    AR=/usr/bin/gcc-ar-11 \
    RANLIB=/usr/bin/ranlib-11

WORKDIR /root

RUN git clone --depth 1 --branch v3.22.1 https://github.com/Kitware/CMake && \
    cd CMake && ./bootstrap && make install

RUN git clone https://github.com/an-tao/drogon && \
    cd drogon && \
    git submodule update --init && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_CXX_FLAGS="-fcoroutines" .. && \
    make install

