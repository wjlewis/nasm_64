; Here's a more complicated example of interfacing with the C standard
; library, this time using the `printf` function. This illustrates
; another piece of the C ABI, namely that before calling a varargs
; function, the number of arguments passed must be stored in `al` (or
; `rax`).
;
; Assemble with `nasm -felf64 c_printf.asm`
; Link with `gcc -no-pie c_printf.o`
		global	main
		extern	printf

		section	.text
main:
		mov		rdi, format_str
		mov		rsi, 1
		mov		rdx, 1
		mov		rcx, 2
		mov		rax, 4

		sub		rsp, 8			; Realign stack (comment out for segfault)
		call	printf

		add		rsp, 8
		ret

		section	.data
format_str:
		db		"%d + %d = %d", 10, 0	; `10` is ASCII newline
