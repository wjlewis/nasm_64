; A procedure that computes the factorial of its input. Note that we
; mark the procedure as "global" (so that it may be referenced by other
; files).
; We've used the C calling convention, and this procedure may be tested
; using the file `fact_test.c`.
;
; Assemble with `nasm -felf64 fact.asm`
; Link with `gcc fact_test.c fact.o`
		global	fact

		section	.text
fact:
		cmp		rdi, 1
		jle		fact_base
		push	rdi				; We save `rdi`, since we're going to
								; need it after (recursively) calling
								; `fact`. In the process, we realign
								; `rsp`. Serendipity.
		dec		rdi
		call	fact
		pop		rdi				; Now `rsp` points to the return address
		imul	rax, rdi
		ret

fact_base:
		mov		rax, 1
		ret
