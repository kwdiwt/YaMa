FROM ubuntu:24.04 AS stage1

WORKDIR /root

# 源
# COPY sources.list /etc/apt/sources.list
# DEB822 格式源
COPY ubuntu.sources /etc/apt/sources.list.d/

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y git curl unzip python3 python3-pip build-essential lib32stdc++-9-dev \
    libc6-dev-i386 nodejs npm

# 进程名和文件名
ARG NAME

RUN git config --global user.email "you@example.com" && \
    git config --global user.name "Your Name" && \
    npm config set registry http://mirrors.cloud.tencent.com/npm/ && \
    pip config set global.index-url http://mirrors.aliyun.com/pypi/simple/ && \
    \
    git clone https://github.com/frida/frida-core.git && \
    cd frida-core && \
    git checkout 16.3.1 -b buildFrida && \
    git submodule update --init --recursive && \
    \
    cd && git clone https://github.com/Ylarod/Florida.git && \
    cd Florida && \
    git checkout 9172e84ad3954e808638152539f70eb6bc079bac -b buildFrida && \
    mkdir ~/frida-core/patch && \
    cp -r patches/frida-core ~/frida-core/patch && \
    \
    cd ~/frida-core && \
    git am patch/frida-core/*.patch && \
    sed -i "s/ggbond/${NAME:-kjlk}/" src/frida-glue.c && \
    \
    cd && curl -O https://dl.google.com/android/repository/android-ndk-r25c-linux.zip && \
    unzip android-ndk-r25c-linux.zip

ENV ANDROID_NDK_ROOT=/root/android-ndk-r25c

RUN cd frida-core && ./configure --host=android-arm64 && make

RUN pip install lief --break-system-packages --trusted-host mirrors.aliyun.com && \
    mkdir end && cd end && \
    cp ~/frida-core/src/anti-anti-frida.py ~/frida-core/build/server/frida-server ./ && \
    python3 anti-anti-frida.py frida-server

FROM scratch AS export-stage
ARG NAME
COPY --from=stage1 /root/end/frida-server ./$NAME