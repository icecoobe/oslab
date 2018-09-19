
@echo off

if not exist bin (
    mkdir bin
)

nasm -f bin loader-1.asm -o bin\loader-1.bin -l bin\loader-1.lst
nasm -f bin -o bin\user.bin user_program.asm -l bin\user.lst

if not exist bin\bochsrc.bxrc (
    xcopy /Y bochsrc.bxrc bin\
    xcopy /E /Y bxshare bin\bxshare\
)

cd bin
if not exist system.img (
    :: Create a 10MB-HD image named "system.img" which will be used by bochsrc.bxrc
    bximage -mode=create -hd=10 -q system.img
)

dd if=loader-1.bin of=system.img seek=0 bs=512 count=1
dd if=user.bin  of=system.img seek=5 bs=512 count=2

:: Remove temp files which may prevent starting a new bochs instance
del /s /q system.img.lock

rem for debugging
rem bochsdbg -q -f bochsrc.bxrc
bochs -q -f bochsrc.bxrc
cd ..