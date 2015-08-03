#!/usr/bin/bash


nasm -f bin -o bin/$1.bin $1.asm

~/c/mbr bin/$1.bin

vboxmanage startvm dos2
