FROM docker.io/library/ubuntu:20.10

RUN apt update -y \
    && apt install -y --no-install-recommends software-properties-common \
    curl wget pkg-config locales git clang build-essential \
    openssl libssl-dev libjsoncpp-dev uuid-dev zlib1g-dev libc-ares-dev\
    postgresql-server-dev-all libmariadbclient-dev libsqlite3-dev nano npm \
    libsodium-dev && locale-gen en_US.UTF-8 && npm install -g n && n latest

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    CC=/usr/bin/clang \
    CXX=/usr/bin/clang++ \
    AR=llvm-ar \
    RANLIB=llvm-ranlib \
    BOOST_INCLUDE_DIR="${HOME}/opt/boost_1_67_0" \  
    IROOT=/install

WORKDIR /root

# The version of CMake installed by apt is 3.16; I would like 3.19 so it is compiled manually.	
RUN git clone https://github.com/Kitware/CMake.git --branch v3.19.4 --single-branch
WORKDIR /root/CMake
RUN ./bootstrap && make && make install

RUN git clone https://github.com/an-tao/drogon && \ 
    cd drogon && \
    git submodule update --init && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && make install 
	
ARG DEBIAN_FRONTEND=noninteractive
