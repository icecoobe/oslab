
@echo off

nasm -f bin -o mbr.bin -l mbr.lst mbr.asm

if not exist system.img (
    :: Create a 10MB-HD image named "system.img" which will be used by bochsrc.bxrc
    bximage -mode=create -hd=10 -q system.img
)

:: Remove temp files which may prevent starting a new bochs instance
del /s /q system.img.lock

dd if=mbr.bin of=system.img bs=512 count=1

:: Run
bochs -q -f bochsrc.bxrc

pause