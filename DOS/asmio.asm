;; asmio.asm
;;
;; 包含一些实模式汇编使用的Input/Output接口
;; 
;;

segment .text

;;----------------------------------------------------------------------
;; [名称]
;; clear
;; 清屏,类似Linux的clear, Windows下的cls等命令
;;
;; [影响]
;; 改变ax内容
clear:
	mov ax, 0003h
	int 10h

;;----------------------------------------------------------------------
;; [名称]
;; putc
;; 显示字符,仅支持ASCII码
;;
;; [输入]
;; al:待输出的字符
;;
;; [影响]
;; 改变ax内容, dl内容
putc:
	mov dl, al
	mov ah, 2	; single char use
	int 21h
	ret
	
;;----------------------------------------------------------------------
;; [名称]
;; puts
;; 显示字符串
;;
;; [输入]
;; ax:字符串的EA(effective address)
;;
;; [影响]
;; 改变ah内容, dx内容
puts:
	mov dx, ax
	mov ah, 09h
	int 21h
	ret
