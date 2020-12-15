; Exits with code 42
; Written for Linux on x86-64
;
; Assemble with `nasm -felf64 exit.asm`
; Link with `ld exit.o`
;
; We can then test it as follows:
;
; $ ./a.out
; $ echo $?
;
; The result of second command should be `42`.
		global	_start

		section	.text
_start:
		mov		rax, 60			; Syscall number for `exit`
		mov		rdi, 42			; Exit code
		syscall
