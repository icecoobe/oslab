
@echo off

nasm -f bin -o bin\%1.bin %1.asm

rem .\bin\mbr bin\%1.bin
bin\dd if=bin\%1.bin of="G:\VirtualBox VMs\dos2\dos2.vhd" bs=512 count=1 conv=notrunc


vboxmanage startvm dos2