
;; HelloWorld.asm
;;
;; Print "Hello World!" on screen when booting PC.
;;
;; Build with below command:
;; $ nasm -f bin -o HelloWorld -l HelloWorld.lst HelloWorld.asm

;; TODO:
;; 1.添加CLI, STI等暂停处理中断的指令

;;[bits 16]

;%define DOS

;%ifdef DOS
;org 100h
;%else
;org 7c00h
;%endif

org 7c00h

;; Q1: 为什么使用了section之类的字样之后, 编译的目标文件大小不为512
;; 试一下生成list文件, 看看
;; 应该是跟($ - $$)有关系
;;section .data
	msg db 'Hello World!'
	crlf db 13,10,'$' ;; 回车换行

;; Q2: 同Q1
;;section .text
start:
	;; 将DS ES与CS保持一致, 指向相同的段
	;; 在数据操作时候, 能够正确定位到.
	mov ax, cs
	mov ds, ax
	mov es, ax

	mov ax, 000Eh
	int 10h
	
	mov di, 320h ;画个矩形
	mov bp, 100h  
	mov cx, 10h  
	mov dx, 10h  
Q1:
	mov ax,0c1Ch;02h
	int 10h
	
	inc dx  
	dec bp  
	jnz Q1  
@11c:
	mov ah,0ch  
	int 10h  
	inc cx  
	dec di  
	jnz @11c  
@124:
	mov ah,0ch  
	int 10h  
	dec dx  
	cmp dx,18h  
	jnl @124  
@12f:
	mov ah,0ch  
	int 10h  
	dec cx  
	cmp cx,18h  
	jnz @12f  
	mov ah,0  
	int 16h  
	cmp al,1bh
	jz quit
	inc si
	inc si
quit:	
	;;hlt
	mov ax, msg
	call func_puts
	jmp $

;; func_puts
;; 使用ax传递字符串的首地址
func_puts:
	;;mov ax, BootMessage
	mov bp, ax   ; ES:BP = 串地址
	mov cx, 12   ; CX = 串长度
	mov ax, 1301h  ; AH = 13,  AL = 01h
	;;mov bx, 000ch  ; 页号为0(BH = 0) 黑底红字(BL = 0Ch,高亮)
	mov bx, 00AFh  ; 页号为0(BH = 0) 绿底白字(BL = AFh,高亮)
	mov dl, 0
	int 10h   ; 10h 号中断
	ret

%warning Nasm ver: __NASM_VER__ __FILE__ __LINE__ __line__
;; 不影响编译结果
%warning 'warning-1'
;; 影响编译结果,不会生成结果文件, 后续编译会继续
;;%error 'error-1'
%warning 'warning-2'
	
times (512-($-$$) - 2)	db 0 
;;size   equ $ - start
;;%if size+2 >512
;;%error "code is too large forboot sector"
;;%endif
db   0x55, 0xAA          ;2 byte boot signature