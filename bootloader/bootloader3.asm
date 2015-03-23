;----------------------------------------------------------------------
org 0x7c00    
;--------------------------------------------
;启动程序代码开始
;--------------------------------------------
begin:
xor ax, ax            
mov ds, ax            ; set data segment to base of RAM
mov ah,0FH  
   int    10H  
   mov   ah,0  
   int    10H  
 
mov si, msg1
call putstr            
call   getcmd  
 
mov si, msg2
call putstr           
call   getcmd
 
mov si, msg3
call putstr            
call   getcmd
call   shutdown
;--------------------------------------------
 
msg1 db   10,13,'Hello?', 10,13,0
msg2 db   10,13,'Are u hungry?',10,13,0
msg3 db   10,13,'Is it amazing?', 10,13,0
;---------------------------------------------
putstr:
lodsb             ; AL = [DS:SI]
or al, al  
jz putstrd
mov ah, 0eH  
mov bx, 0007H     
int 10H
jmp putstr
;---------------------------------------------
putstrd:
retn
;---------------------------------------------
getcmd:            ; 获取输入
 
.getkey:
mov ah,0H    
int 16H
.key_in_buffer:
cmp al,13        ; 检查回车键
je .execcmd     ; 跳至执行命令
jmp echochar     ; 显示字符
.execcmd:
ret
 
echochar:
mov ah, 0EH     ; 显示字符
mov bx, 0007H   
int 10h
jmp getcmd
 
shutdown:
mov  AX,  5307h  
mov  BX,  1  
mov  CX,  3  
int  15h
 
 
;size   equ$ - begin
;%if size+2 >512
;%error "code is too large forboot sector"
;%endif
;times      (512 - size - 2) db 0
times (512-($-$$) - 2)	db 0 
db   0x55, 0xAA          ;2 byte boot signature
