debug.exe
WindowsXP及以下的版本、dosbox下可以使用，用来调试16位程序。

fixvhdwr.exe
将文件填充到vhd文件的引导扇区部分

HexView.exe
以十六进制的方式查看目标文件

mbr.exe
与fixvhdwr.exe类似，只因我不喜欢打开图形界面，再进行复杂的文件选择等操作。
本目录下的mbr程序针对我个人机器环境所定制，目标文件锁定为G盘的dos2虚拟机("G:\\VirtualBox VMs\\dos2\\dos2.vhd")
如果你需要，可以使用tools\src\mbr内的代码编译一份自用，那里的代码是通用的。

dd.exe
this is dd for windows