#!/bin/bash

if [ ! -d bin ]
then
	mkdir -v bin
fi

#if [ ! -d bin ]; then
#	mkdir -v bin
#fi

nasm -f bin -o bin/$1.bin $1.asm

#~/c/mbr bin/$1.bin
#dd if=bin/$1.bin of="/media/luke/vm/VirtualBox VMs/dos2/dos2.vhd" bs=512 count=1 conv=notrunc

#vboxmanage startvm dos2

dd if=bin/$1.bin of=bin/c.img seek=0 bs=512 count=1 conv=notrunc
cd bin
bochs -f bochsrc
