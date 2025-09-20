section	.text
global	ft_list_push_front

extern malloc

ft_list_push_front:
	test	rdi, rdi
	je	.L4
	push	rbp
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
.L4:
	ret
