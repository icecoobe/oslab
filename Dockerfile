FROM docker/ubuntu:latest
LABEL Name=oslab Version=0.0.1


RUN apt-get -y update && apt install -y build-essential bison flex libgmp3-dev \
                        libmpc-dev libmpfr-dev texinfo libisl-dev wget make \
                        libncurses-dev xorg-dev glew-utils unzip x11-utils x11-common \
                        qemu-system-i386 nasm git gdb dos2unix netcat-traditional

RUN wget https://ftp.gnu.org/gnu/binutils/binutils-2.43.tar.xz
RUN wget https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz
RUN wget https://github.com/bochs-emu/Bochs/archive/refs/tags/REL_2_8_FINAL.zip

RUN tar -xf binutils-2.43.tar.xz
RUN tar -xf gcc-14.2.0.tar.xz

RUN mkdir build-binutils && \
    cd build-binutils && \
    ../binutils-2.43/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror &&\
    make && \
    make install

RUN mkdir build-gcc &&\
    cd build-gcc && \
    ../gcc-14.2.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers && \
    make all-gcc && \
    make all-target-libgcc && \
    make install-gcc && \
    make install-target-libgcc

RUN unzip REL_2_8_FINAL.zip
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

RUN make
RUN make install

RUN rm -rf /tmp
# CMD ["sh", "-c", "/usr/games/fortune -a | cowsay"]
