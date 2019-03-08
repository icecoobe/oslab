
@echo off

if not exist bin (
    mkdir bin
)

nasm -f bin loader.asm -o bin\loader.bin -l bin\loader.lst
nasm -f bin -o bin\user.bin user_program.asm -l bin\user.lst

if not exist bin\bochsrc.win (
    xcopy /Y bochsrc.win bin\
    xcopy /E /Y bxshare bin\bxshare\
)

cd bin
if not exist system.img (
    :: Create a 10MB-HD image named "system.img" which will be used by bochsrc.bxrc
    bximage -mode=create -hd=10 -q system.img
)

dd if=loader.bin of=system.img seek=0 bs=512 count=1
dd if=user.bin  of=system.img seek=5 bs=512 count=2

if exist system.img.lock (
    :: Remove temp files which may prevent starting a new bochs instance
    del /s /q system.img.lock
)

rem for debugging
rem bochsdbg -q -f bochsrc.win
bochs -q -f bochsrc.win
cd ..
