	.intel_syntax noprefix
	.text
	.globl	ft_strlen
ft_strlen:
.LFB0:
	mov	eax, 0
	jmp	.L2
.L4:
	add	rax, 1
.L2:
	test	rdi, rdi
	je	.L1
	cmp	BYTE PTR [rdi+rax], 0
	jne	.L4
.L1:
	ret
