; A procedure that sorts its numerical arguments, and prints them out.
;
; Assemble with `nasm -felf64 sort_args.asm`
; Link with `gcc -no-pie sort_args.o`
		global	main
		extern	atol
		extern	printf

		section	.text
main:
		sub		rsp, 8

		dec		rdi				; Move past first arg (program name)
		add		rsi, 8

		call	read_nums
		mov		r12, rax		; Save length for later calculations

		mov		rdi, 0
		mov		rsi, r12
		call	quicksort

		mov		rdi, r12
		call	print_nums

		add		rsp, 8
		ret

; int64_t read_nums(int argc, char **argv);
; Reads command line arguments into the `nums` array as numbers. Returns
; the length of the used portion of the array.
read_nums:
		sub		rsp, 8
		mov		rcx, 0			; Our index into the sortable array
		push	rdi				; Save length (it's the return value)
read_nums_loop:
		cmp		rdi, 0
		je		read_nums_done

		push	rcx
		push	rdi
		push	rsi

		mov		rdi, [rsi]
		call	atol

		pop		rsi
		pop		rdi
		pop		rcx

		mov		[nums + rcx * 8], rax
		inc		rcx

		dec		rdi
		add		rsi, 8
		jmp		read_nums_loop

read_nums_done:
		pop		rax				; Return length
		add		rsp, 8
		ret

; void quicksort(int64_t low, int64_t high);
; Sorts the `nums` array using quicksort with the Lomuto partition
; scheme.
quicksort:
		sub		rsp, 8
		dec		rsi						; Now index of last element

		cmp		rdi, rsi
		jge		quicksort_done
	
		mov		r8, [nums + rsi * 8]	; Pivot element
		mov		rcx, rdi				; Free slot index
		mov		rdx, rdi				; Current element index

quicksort_partition:
		cmp		rdx, rsi
		je		quicksort_move_pivot

		mov		r9, [nums + rdx * 8]
		cmp		r9, r8
		jl		quicksort_swap

		inc		rdx
		jmp		quicksort_partition

; Need to swap elements at `nums + rcx * 8` and `nums + rdx * 8`
; Element at `rdx` is already in `r9`
quicksort_swap:
		push	r8
		mov		r8, [nums + rcx * 8]
		mov		[nums + rcx * 8], r9
		mov		[nums + rdx * 8], r8
		pop		r8

		inc		rcx
		inc		rdx
		jmp		quicksort_partition

quicksort_move_pivot:
		mov		r9, [nums + rcx * 8]
		mov		[nums + rcx * 8], r8
		mov		[nums + rdx * 8], r9

		; Now sort sub-arrays
		; Note that the pivot index is in `rcx`
		push	rcx		; Save pivot index
		inc		rsi		; Restore original high index
		push	rsi		; Save high index

		; Sort first subarray
		mov		rsi, rcx
		dec		rcx
		call	quicksort

		; Sort second subarray
		pop		rsi
		pop		rdi
		inc		rdi
		call	quicksort

quicksort_done:
		add		rsp, 8
		ret


; void print_nums(int64_t length);
print_nums:
		mov		rcx, 0
		mov		rdx, rdi

print_nums_loop:
		cmp		rcx, rdi
		je		print_nums_done
		
		push	rdi
		push	rcx
		push	rdx

		mov		rdi, format_str
		mov		rsi, [nums + rcx * 8]
		mov		rax, 2
		call	printf

		pop		rdx
		pop		rcx
		pop		rdi

		inc		rcx
		jmp		print_nums_loop

print_nums_done:
		ret


		section	.data
format_str:
		db		"%ld", 10, 0


		section	.bss
maxlen			equ		1024			; Maximum length of sortable array
nums			resq	maxlen
