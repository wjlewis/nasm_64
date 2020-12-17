; A procedure that computes the element of the fibonacci sequence
; indicated by its input. It may not be immediately clear how to
; translate the classic recursive definition into this procedure; it is
; immediately clear if we look at a transformation of the definition
; into A-Normal Form / SSA / CPS.
;
; // A possible definition in C
; int64_t fib(int64_t n) {
;     if (n < 2) {
;         return n;
;     }
;
;     return fib(n-1) + fib(n-2);
; }
;
; // The same defition, transformed to ANF
; int64_t fib(int64_t n) {
;     bool tmp1 = n < 2;
;     if (tmp1) {
;         return n;
;     }
;
;     int64_t tmp2 = n - 1;
;     int64_t tmp3 = fib(tmp2);
;
;     int64_t tmp4 = n - 2;
;     int64_t tmp5 = fib(tmp4);
;
;     int64_t tmp6 = tmp3 + tmp5;
;     return tmp6;
; }
;
; Assemble with `nasm -felf64 fib.asm`
; Link with `gcc fib_test.c fib.o`
		global	fib

		section	.text
fib:
		cmp		rdi, 2
		jl		fib_base
		push	rdi				; Save for later AND realign `rsp`
		sub		rdi, 1
		call	fib

		pop		rdi
		push	rax				; Save answer for `fib(n-1)`, and realign
		sub		rdi, 2
		call	fib

		pop		rdi				; Answer for `fib(n-1)`; now `rsp` is
								; ready for `ret`
		add		rax, rdi
		ret

fib_base:
		mov		rax, rdi
		ret
