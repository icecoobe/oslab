# https://docs.docker.com/reference/dockerfile/#overview
# https://docs.docker.com/build/building/best-practices/

FROM ubuntu:22.04

LABEL Name=oslab \
      Version=0.0.1

ENV HOSTNAME=docker-oslab

ENV MY_PROXY_URL=http://host.docker.internal:3128
ENV HTTP_PROXY=$MY_PROXY_URL \
    HTTPS_PROXY=$MY_PROXY_URL \
    FTP_PROXY=$MY_PROXY_URL \
    http_proxy=$MY_PROXY_URL \
    https_proxy=$MY_PROXY_URL \
    ftp_proxy=$MY_PROXY_URL

RUN apt-get -y update && apt install -y \
    build-essential \
    bison \
    flex \
    libgmp3-dev \
    libmpc-dev \
    libmpfr-dev \
    texinfo \ 
    libisl-dev \
    wget \
    make \
    libncurses-dev \
    xorg-dev \
    glew-utils \
    unzip \
    x11-utils \
    x11-common \
    qemu-system-i386 \
    nasm \
    git \
    gdb \
    dos2unix \
    netcat-traditional \ 
    binutils \
    gcc

# RUN wget https://ftp.gnu.org/gnu/binutils/binutils-2.43.tar.xz
# RUN wget https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz
# RUN wget https://github.com/bochs-emu/Bochs/archive/refs/tags/REL_2_8_FINAL.zip

# RUN tar -xf binutils-2.43.tar.xz
# RUN tar -xf gcc-14.2.0.tar.xz

# RUN mkdir build-binutils && \
#     cd build-binutils && \
#     ../binutils-2.43/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror &&\
#     make && \
#     make install

# RUN mkdir build-gcc && \
#     cd build-gcc && \
#     ../gcc-14.2.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers --disable-multilib && \
#     make all-gcc && \
#     make all-target-libgcc && \
#     make install-gcc && \
#     make install-target-libgcc

RUN wget https://github.com/bochs-emu/Bochs/archive/refs/tags/REL_2_8_FINAL.zip && \
    unzip REL_2_8_FINAL.zip -d /tmp && \
    rm -rf REL_2_8_FINAL.zip

# Comment these lines, cause unzip doesn't support reading from stdin.
# while busybox unzip does
# ## The single '-' in wget means write to stdout
# ## The single '-' in unzip means read from stdin
# ## /bin/sh doesn't support pipefail
# SHELL ["/bin/bash", "-c"]
# RUN set -o pipefail && \
#     wget --quiet -O - https://github.com/bochs-emu/Bochs/archive/refs/tags/REL_2_8_FINAL.zip | \
#     unzip - -d /tmp

WORKDIR /tmp/Bochs-REL_2_8_FINAL/bochs

RUN ./configure \
        --build=x86_64 \
        --host=x86_64 \
        --target=x86_64 \
        --enable-cpu-level=6 \
        --enable-pci \
        --enable-gdb-stub \
        --enable-logging \
        --enable-fpu \
        --enable-sb16=dummy \
        --enable-cdrom \
        --enable-x86-debugger \
        --enable-iodebug \
        --disable-docbook \
        --with-x11

RUN make && make install

# if we don't change the workdir, we cannot remove /tmp/Bochs-REL_2_8_FINAL
WORKDIR /
RUN rm -rf /tmp/Bochs-REL_2_8_FINAL

CMD ["/bin/bash", "-c"]
# CMD ["sh", "-c", "/usr/games/fortune -a | cowsay"]
