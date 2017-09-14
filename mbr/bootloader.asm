
;; bootloader这种程序需要编译成plain flat binary格式
;; CS DS等段寄存器需要自行设置维护
;;

org 07c00h   ; 告诉编译器程序加载到7c00处

 mov ax, cs    ;以下三行指令,使得ds和es两个段寄存器指向与CS相同的段，以便在
 mov ds, ax   ;以后进行数据操作的时候能够定位到正确的位
 mov es, ax
 call DispStr   ; 调用显示字符串例程
 jmp $   ; 无限循环

DispStr:
 mov ax, BootMessage
 mov bp, ax   ; ES:BP = 串地址
 mov cx, 16   ; CX = 串长度
 mov ax, 01301h  ; AH = 13,  AL = 01h
 mov bx, 000ch  ; 页号为0(BH = 0) 黑底红字(BL = 0Ch,高亮)
 mov dl, 0
 int 10h   ; 10h 号中断
 ret

BootMessage:  db "Hello, OS world!"
times  510-($-$$) db 0 ; 填充剩下的空间，使生成的二进制代码恰好为512字节
dw  0xaa55    ; 结束标志
