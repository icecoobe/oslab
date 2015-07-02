#!/usr/bin/nodejs


nasm -f bin -o $1 $1.asm

~/c/mbr $1

vboxmanage startvm dos2
