
;;
;;
;; nasm -f bin -o printreg -l printreg.lst printreg.asm
;;
;;

section .data
	hr db '---------------------------------------', 13, 10, '$'
	info1 db '1.Print The Command Line Information', 13, 10, '$'
	info2 db 'Program terminated!', 13, 10, '$'
	argcInfo db '- The argc: ', 13, 10, '$'
	argvInfo db '- The argv: ', 13, 10, '$'
	crlf db 13,10,'$'
	
section .bss
	m_n3 resb 1 
	m_n2 resb 1
	m_n1 resb 1
	m_n0 resb 1