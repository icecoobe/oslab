#!/usr/bin/bash


nasm -f bin -o bin/$1 $1.asm

~/c/mbr bin/$1

vboxmanage startvm dos2
