; This program is a small improvement on `exit.asm`.
; It uses the `puts` function from the C standard library to print the
; value `"42"` to the console.
;
; Assemble with `nasm -felf64 c_puts.asm`
; Link (with C standard library) with `gcc -no-pie c_puts.o`
		global	main
		extern	puts

		section	.text
main:
		mov		rdi, message
		call	puts
		ret

		section	.data
message:
		db		"42", 0
