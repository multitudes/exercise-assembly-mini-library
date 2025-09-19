	.text
	.intel_syntax noprefix
	.file	"ft_strcmp.c"
	.globl	ft_strcmp                       # -- Begin function ft_strcmp
	.p2align	4, 0x90
	.type	ft_strcmp,@function
ft_strcmp:                              # @ft_strcmp
	.cfi_startproc
# %bb.0:
	xor	eax, eax
	mov	rcx, rdi
	or	rcx, rsi
	je	.LBB0_6
# %bb.1:
	mov	al, byte ptr [rdi]
	test	al, al
	je	.LBB0_5
# %bb.2:
	add	rdi, 1
	.p2align	4, 0x90
.LBB0_3:                                # =>This Inner Loop Header: Depth=1
	cmp	al, byte ptr [rsi]
	jne	.LBB0_5
# %bb.4:                                #   in Loop: Header=BB0_3 Depth=1
	add	rsi, 1
	movzx	eax, byte ptr [rdi]
	add	rdi, 1
	test	al, al
	jne	.LBB0_3
.LBB0_5:
	movzx	eax, al
	movzx	ecx, byte ptr [rsi]
	sub	eax, ecx
.LBB0_6:
	ret
.Lfunc_end0:
	.size	ft_strcmp, .Lfunc_end0-ft_strcmp
	.cfi_endproc
                                        # -- End function
	.ident	"Ubuntu clang version 12.0.1-19ubuntu3"
	.section	".note.GNU-stack","",@progbits
	.addrsig
