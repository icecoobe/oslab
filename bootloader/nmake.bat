
@echo off

nasm -f bin -o %1 %1.asm

mbr %1

vboxmanage startvm dos2
