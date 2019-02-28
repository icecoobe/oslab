#!/bin/bash

if [ ! -d bin ]
then
	mkdir -v bin
fi

nasm -f bin -o bin/$1.bin -l bin/$1.lst $1.asm

cp -v ../template/bochsrc.unix bin/

cd bin

if [ ! -e system.img ]
then
        bximage -mode=create -hd=10 -q system.img
fi

dd if=$1.bin of=system.img seek=0 bs=512 count=1 conv=notrunc

bochs -q -f bochsrc.unix

cd ..
