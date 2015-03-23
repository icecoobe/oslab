
;; binary_format.asm
;;
;; This is an example source code of flat binary format object.
;;
;; Build with below command:
;; $ nasm -f bin -o binary_format.com -l binary_format.lst binary_format.asm

[bits 16]

org 100h

section .data
	msg db 'Hello World!', 13, 10, '$'
	crlf db 13,10,'$' ;; 回车换行
	
section .text
start:
	mov ax, msg
	mov dx, ax
	mov ah, 09h
	int 21h
	
	;; return to DOS.
	mov ah, 4Ch
	int 21h
