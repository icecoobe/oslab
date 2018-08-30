#!/bin/bash

if [ ! -d bin ]
then
	mkdir -v bin
fi

#if [ ! -d bin ]; then
#	mkdir -v bin
#fi

nasm -f bin -o bin/$1.bin $1.asm
nasm -f bin -o bin/$2.bin $2.asm

#~/c/mbr bin/$1.bin
#dd if=bin/$1.bin of="/media/luke/vm/VirtualBox VMs/dos2/dos2.vhd" bs=512 count=1 conv=notrunc

#vboxmanage startvm dos2

# dd if=bin/$1.bin of=bin/c.img seek=0 bs=512 count=1 conv=notrunc
# dd if=bin/boot of=/dev/sdc count=1 bs=446
# dd if=bin/sector2 of=/dev/sdc count=1 bs=512 seek=1

dd if=bin/$1.bin of=bin/c.img seek=0 bs=446 count=1 conv=notrunc
dd if=bin/$2.bin of=bin/c.img seek=1 bs=512 count=1 conv=notrunc

cd bin
bochs -f bochsrc.txt
