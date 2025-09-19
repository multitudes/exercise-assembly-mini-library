section text
global	ft_strdup                       

; char *ft_strdup(const char *s);
; ------------------------------------------
; Duplicates the string s by allocating sufficient memory for a copy of s,
; copying the string, and returning a pointer to it.
; Arguments are passed via registers by the caller:
;   rdi: pointer to the source string (s)
; Returns: pointer to the duplicated string (or NULL if insufficient memory)

ft_strdup:                              
; push the register on the stack, r15, r14 and rbx are callee saved registers
; their value will be later reinstated before returning.
	push	r15 
	push	r14
	push	rbx

	mov	r15, rdi
	xor	ebx, ebx

; -- Find the length of the string (including null terminator) --
.len_loop:                              
	cmp	byte [r15 + rbx], 0
	; why use lea here? add rbx, 1 and inc rbx 
	; also increment rbx by 1, but they do affect the CPU flags.
	lea	rbx, [rbx + 1]
	jne	.len_loop
	; move the length of the string (in rbx) to rdi for malloc
	; rbx already includes space for the null terminator.
	mov	rdi, rbx
	call	malloc
	test	rax, rax
	je	.exit_error
	; before calling memcpy save the source string pointer (in r14)
	mov	r14, rax
	; If rbx is zero, there is nothing to copy, 
	test	rbx, rbx
	je	.ret
	; prepare the arguments for memcpy
	mov	rdi, r14
	mov	rsi, r15
	mov	rdx, rbx
	call	memcpy@PLT
	jmp	.ret
.exit_error:
	xor	r14d, r14d
.ret:
	mov	rax, r14
	pop	rbx
	pop	r14
	pop	r15
	ret

