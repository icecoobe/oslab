#!/bin/bash

if [ ! -d bin ]
then
	mkdir -v bin
fi

nasm -f bin -o bin/$1.bin -l bin/$1.lst $1.asm

dd if=bin/$1.bin of=bin/c.img seek=0 bs=512 count=1 conv=notrunc
cd bin
bochs -q -f bochsrc
cd ..