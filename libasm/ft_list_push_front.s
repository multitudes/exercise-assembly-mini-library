section	.text
global	ft_list_push_front

extern malloc

; ft_list_push_front(t_list **begin_list, void *data)
; ------------------------------------------
; Adds a new element at the beginning of the list.
; Arguments are passed via registers by the caller:
;   rdi: pointer to the head of the list (t_list **begin_list)
;   rsi: pointer to the data to be stored in the new element (void *data)
; Returns: nothing

ft_list_push_front:
	test	rdi, rdi		; null pointer check for begin_list
	je		.ret			; if null, just return
	push	rbp				;
	push	rbx
	sub	rsp, 8
	mov	rbx, rdi
	mov	rbp, rsi
	mov	edi, 16
	call	malloc wrt ..plt
	test	rax, rax
	je	.L1
	mov	qword  [rax], rbp
	mov	rdx, qword  [rbx]
	mov	qword  8[rax], rdx
	mov	qword  [rbx], rax
.L1:
	add	rsp, 8
	pop	rbx
	pop	rbp
	ret
.ret:
	ret
