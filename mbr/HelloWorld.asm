
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

section .data
	msg db 'Hello World!'
	crlf db 13,10,'$' ;; 回车换行

	mov ax, msg
	call func_puts
	hlt
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