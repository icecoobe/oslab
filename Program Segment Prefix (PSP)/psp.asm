
;;----------------------------------------------------------------------
;; Demo of PSP
;; read the command line bytes from PSP
;; 2015/01/22
;;----------------------------------------------------------------------


org 100h

section .data
	copyright db '---------------------------------------', 13, 10, '$'
	info1 db 'The Command Line is:', 13, 10, '$'
	info2 db 'Program terminated!', 13, 10, '$'
	crlf db 13,10,'$'
	
section .bss
	n3 resb 1 
	n2 resb 1
	n1 resb 1
	n0 resb 1
	
section .text
; 暂时实验结果如下:
;it makes no sense for plain binary format
;global start
;hehe:
;	mov ax, 1
;	sar ax,2

start:
	mov ax, copyright
	call DispStr
	
	mov ax, info1
	call DispStr
	
	mov al, [80h]	; 80h的偏移位置存储的是命令行的字节数，ah部分存储的是该数值，占一个字节
	;mov cl, al	; 与NOTE-2有一个即可,确保循环正确结束
	xor ax, ax
	xor di, di
	mov di, 1		;; 略过80h,从下标1开始
readpsp:
	xor ax, ax
	mov al, [80h+di]
	cmp al, 0D		;; [NOTE-2]
	je end
	call DispChar
	
	;add di, 2 		;; 上述部分一次读取两个字节，所以不需要这样每次以一个字节为单位来操作
	inc di
	loop readpsp

end:
	MOV AX, crlf
	CALL DispStr
	
	MOV AX, COPYRIGHT
	CALL DispStr
	
	MOV AX, INFO2
	CALL DispStr
	
	;; RETURN TO DOS
	MOV AH, 4CH
	INT 21H
	
	
DispStr:
	MOV DL, AL
	Mov ah, 2	; single char use
	int 21h
	ret

DispStr:
	mov dx, ax
	mov ah, 09h
	int 21h
	ret