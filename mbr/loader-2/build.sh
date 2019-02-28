#!/bin/bash

if [ ! -d bin ]
then
	mkdir -v bin
fi

nasm -f bin loader.asm -o bin/loader.bin -l bin/loader.lst
nasm -f bin -o bin/user.bin user_program.asm -l bin/user.lst

cp -r -v bxshare/ bin/
cp -v bochsrc.unix bin/

cd bin

if [ ! -e system.img ]
then
	bximage -mode=create -hd=10 -q system.img
fi

dd if=loader.bin of=system.img seek=0 bs=512 count=1 conv=notrunc
dd if=user.bin  of=system.img seek=5 bs=512 count=2 conv=notrunc

rm -rf system.img.lock

bochs -q -f bochsrc.unix

cd ..
