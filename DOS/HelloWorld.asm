
;; HelloWorld.asm
;;
;; Print "Hello World!" on screen.
;;
;; Build with below command:
;; $ nasm -f bin -o HelloWorld.com -l HelloWorld.lst HelloWorld.asm

[bits 16]

org 100h

section .data
	msg db 'Hello World!', 13, 10, '$'
	crlf db 13,10,'$' ;; 回车换行
	
section .bss
	
section .text
start:
	mov ax, msg
	mov dx, ax
	mov ah, 09h
	int 21h
	
	;; RETURN TO DOS
	mov ah, 4Ch
	int 21h
