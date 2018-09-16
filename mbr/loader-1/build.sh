#!/bin/bash

if [ ! -d bin ]
then
	mkdir -v bin
fi

nasm -f bin loader-1.asm -o bin/loader-1.bin -l bin/loader-1.lst
nasm -f bin -o bin/user.bin user_program.asm -l bin/user.lst

if [ ! -e system.img ]
then
	bximage -mode=create -hd=10 -q system.img
fi

dd if=bin/loader-1.bin of=bin/system.img seek=0 bs=512 count=1 conv=notrunc
dd if=bin/user.bin  of=bin/system.img seek=5 bs=512 count=2 conv=notrunc

rm -rf system.img.lock

cd bin
bochs -q -f bochsrc
cd ..