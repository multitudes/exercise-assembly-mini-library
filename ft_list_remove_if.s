	.text
	.intel_syntax noprefix
	.file	"ft_list_remove_if.c"
	.globl	ft_list_remove_if               # -- Begin function ft_list_remove_if
	.p2align	4, 0x90
	.type	ft_list_remove_if,@function
ft_list_remove_if:                      # @ft_list_remove_if
	.cfi_startproc
# %bb.0:
	push	rbp
	.cfi_def_cfa_offset 16
	push	r15
	.cfi_def_cfa_offset 24
	push	r14
	.cfi_def_cfa_offset 32
	push	r13
	.cfi_def_cfa_offset 40
	push	r12
	.cfi_def_cfa_offset 48
	push	rbx
	.cfi_def_cfa_offset 56
	push	rax
	.cfi_def_cfa_offset 64
	.cfi_offset rbx, -56
	.cfi_offset r12, -48
	.cfi_offset r13, -40
	.cfi_offset r14, -32
	.cfi_offset r15, -24
	.cfi_offset rbp, -16
	mov	qword ptr [rsp], rcx            # 8-byte Spill
	test	rdi, rdi
	je	.LBB0_7
# %bb.1:
	mov	r12, rdi
	mov	rbx, qword ptr [rdi]
	test	rbx, rbx
	je	.LBB0_7
# %bb.2:
	mov	r15, rdx
	mov	r13, rsi
	xor	ebp, ebp
	jmp	.LBB0_3
	.p2align	4, 0x90
.LBB0_5:                                #   in Loop: Header=BB0_3 Depth=1
	mov	r14, qword ptr [rbx + 8]
	mov	rbp, rbx
.LBB0_6:                                #   in Loop: Header=BB0_3 Depth=1
	mov	rbx, r14
	test	r14, r14
	je	.LBB0_7
.LBB0_3:                                # =>This Inner Loop Header: Depth=1
	mov	rdi, qword ptr [rbx]
	mov	rsi, r13
	xor	eax, eax
	call	r15
	test	eax, eax
	jne	.LBB0_5
# %bb.4:                                #   in Loop: Header=BB0_3 Depth=1
	lea	rax, [rbp + 8]
	test	rbp, rbp
	cmove	rax, r12
	mov	rcx, qword ptr [rbx + 8]
	mov	qword ptr [rax], rcx
	mov	rdi, qword ptr [rbx]
	mov	r14, qword ptr [rbx + 8]
	call	qword ptr [rsp]                 # 8-byte Folded Reload
	mov	rdi, rbx
	call	free
	jmp	.LBB0_6
.LBB0_7:
	add	rsp, 8
	.cfi_def_cfa_offset 56
	pop	rbx
	.cfi_def_cfa_offset 48
	pop	r12
	.cfi_def_cfa_offset 40
	pop	r13
	.cfi_def_cfa_offset 32
	pop	r14
	.cfi_def_cfa_offset 24
	pop	r15
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	ret
.Lfunc_end0:
	.size	ft_list_remove_if, .Lfunc_end0-ft_list_remove_if
	.cfi_endproc
                                        # -- End function
	.ident	"Ubuntu clang version 12.0.1-19ubuntu3"
	.section	".note.GNU-stack","",@progbits
	.addrsig
