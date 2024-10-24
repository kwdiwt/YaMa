FROM ubuntu:24.04

# 清华源
COPY ubuntu.sources /etc/apt/sources.list.d/

RUN apt-get update && apt-get install -y git
RUN git config --global user.email "you@example.com" && git config --global user.name "Your Name"

RUN git clone https://github.com/frida/frida-core.git
RUN cd frida-core && \
    git checkout 16.3.1 -b buildFrida && \
    git submodule update --init --recursive

RUN cd .. && git clone https://github.com/Ylarod/Florida.git && \
    cd Florida && \
    git checkout 9172e84ad3954e808638152539f70eb6bc079bac -b buildFrida && \
    mkdir /frida-core/patch && \
    cp -r patches/frida-core /frida-core/patch

RUN cd /frida-core && git am patch/frida-core/*.patch

RUN ./configure --host=android-arm64
RUN make