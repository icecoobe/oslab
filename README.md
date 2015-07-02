# Nasm - Netwide ...


## Editor
- Emacs
- Vim
- Sublime
- Radasm (Windows)
- Whatever you feel comfortable with.

## Emulator
- VirtualBox
- DosBox
Mainly for dos program, you can debug your *.COM file with debug.exe
- QEMU
- Bochs
It's useful for debugging. However, you shouldn't expect the performance.

## Build && Run
- Use nmake.sh
>	$ cd bootloader
>	$ sh ./nmake.sh gos

It's fully automatic. After building, the vm will start.

- Makefile
>	$ cd bootloader
>	$ make name=gos
>	$ cd bin
>	$ ~/c/mbr gos
>	$ vboxmanage startvm dos2

Assume we have a vm named "dos2", and the mbr program(I put it under ~/c) will write gos into vhd of dos2.
You can change the mbr source code to meet your needs.

## 文件夹说明
1.bootloader
以bootloader的形式来运行我们的16位实模式程序。可以采用virtualbox虚拟机作为运行环境，也可以刻录到u盘的引导扇区，在真机上进行实验。
[注]
*大部分的引导程序稍经调整，或者使用编译技巧，均可以在dosbox环境下使用。
引导程序无非几个要求，大小不能超过512字节，511和512字节处为55AA，
不能使用dos中断等。*

2.Build
编译使用的相关脚本

3.Program Segment Prefix
玩过DOS的都应该知道的，简称psp的玩意。参见内部的readme

4.QA
问题和感悟的记录

5.Shift
移位操作的代码

6.Template
nasm能够支持的文件格式的模板，也会包含常见的程序模板

7.Tools
开发中可能会使用到的工具，它们都很实用。
改写vbox磁盘文件的工具mbr的代码就在该文件夹下。
mbr也就是nmake.sh中使用的一个工具