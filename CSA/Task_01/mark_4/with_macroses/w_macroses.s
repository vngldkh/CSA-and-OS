	.file	"main.c"
	.intel_syntax noprefix
	.text
	.section	.rodata
.LC0:
	.string	"length? "
.LC1:
	.string	"%d"
.LC2:
	.string	"A[%d]? "
.LC3:
	.string	"%lf"
.LC6:
	.string	"A[%d] = %lfs; B[%d] = %lfm\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	r15
	push	r14
	push	r13
	push	r12
	push	rbx
	sub	rsp, 104
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -56[rbp], rax
	xor	eax, eax
	mov	DWORD PTR -100[rbp], 0
.L2:
	lea	rax, .LC0[rip]
	mov	rdi, rax
	mov	eax, 0
	call	printf@PLT
	lea	rax, -100[rbp]
	mov	rsi, rax
	lea	rax, .LC1[rip]
	mov	rdi, rax
	mov	eax, 0
	call	__isoc99_scanf@PLT
	mov	eax, DWORD PTR -100[rbp]
	test	eax, eax
	jg	.L3
	jmp	.L2
.L3:
	mov	eax, DWORD PTR -100[rbp]
	mov	rdx, rsp
	mov	rbx, rdx
	movsx	rdx, eax
	sub	rdx, 1
	mov	QWORD PTR -88[rbp], rdx
	movsx	rdx, eax
	mov	QWORD PTR -128[rbp], rdx
	mov	QWORD PTR -120[rbp], 0
	movsx	rdx, eax
	mov	QWORD PTR -144[rbp], rdx
	mov	QWORD PTR -136[rbp], 0
	cdqe
	lea	rdx, 0[0+rax*8]
	mov	eax, 16
	sub	rax, 1
	add	rax, rdx
	mov	esi, 16
	mov	edx, 0
	div	rsi
	imul	rax, rax, 16
	mov	rcx, rax
	and	rcx, -4096
	mov	rdx, rsp
	sub	rdx, rcx
.L4:
	cmp	rsp, rdx
	je	.L5
	sub	rsp, 4096
	or	QWORD PTR 4088[rsp], 0
	jmp	.L4
.L5:
	mov	rdx, rax
	and	edx, 4095
	sub	rsp, rdx
	mov	rdx, rax
	and	edx, 4095
	test	rdx, rdx
	je	.L6
	and	eax, 4095
	sub	rax, 8
	add	rax, rsp
	or	QWORD PTR [rax], 0
.L6:
	mov	rax, rsp
	add	rax, 7
	shr	rax, 3
	sal	rax, 3
	mov	QWORD PTR -80[rbp], rax
	mov	eax, DWORD PTR -100[rbp]
	movsx	rdx, eax
	sub	rdx, 1
	mov	QWORD PTR -72[rbp], rdx
	movsx	rdx, eax
	mov	r14, rdx
	mov	r15d, 0
	movsx	rdx, eax
	mov	r12, rdx
	mov	r13d, 0
	cdqe
	lea	rdx, 0[0+rax*8]
	mov	eax, 16
	sub	rax, 1
	add	rax, rdx
	mov	edi, 16
	mov	edx, 0
	div	rdi
	imul	rax, rax, 16
	mov	rcx, rax
	and	rcx, -4096
	mov	rdx, rsp
	sub	rdx, rcx
.L7:
	cmp	rsp, rdx
	je	.L8
	sub	rsp, 4096
	or	QWORD PTR 4088[rsp], 0
	jmp	.L7
.L8:
	mov	rdx, rax
	and	edx, 4095
	sub	rsp, rdx
	mov	rdx, rax
	and	edx, 4095
	test	rdx, rdx
	je	.L9
	and	eax, 4095
	sub	rax, 8
	add	rax, rsp
	or	QWORD PTR [rax], 0
.L9:
	mov	rax, rsp
	add	rax, 7
	shr	rax, 3
	sal	rax, 3
	mov	QWORD PTR -64[rbp], rax
	mov	DWORD PTR -96[rbp], 0
	jmp	.L10
.L11:
	mov	eax, DWORD PTR -96[rbp]
	mov	esi, eax
	lea	rax, .LC2[rip]
	mov	rdi, rax
	mov	eax, 0
	call	printf@PLT
	mov	eax, DWORD PTR -96[rbp]
	cdqe
	lea	rdx, 0[0+rax*8]
	mov	rax, QWORD PTR -80[rbp]
	add	rax, rdx
	mov	rsi, rax
	lea	rax, .LC3[rip]
	mov	rdi, rax
	mov	eax, 0
	call	__isoc99_scanf@PLT
	mov	rax, QWORD PTR -80[rbp]
	mov	edx, DWORD PTR -96[rbp]
	movsx	rdx, edx
	movsd	xmm1, QWORD PTR [rax+rdx*8]
	movsd	xmm0, QWORD PTR .LC4[rip]
	mulsd	xmm1, xmm0
	mov	rax, QWORD PTR -80[rbp]
	mov	edx, DWORD PTR -96[rbp]
	movsx	rdx, edx
	movsd	xmm0, QWORD PTR [rax+rdx*8]
	mulsd	xmm0, xmm1
	movsd	xmm1, QWORD PTR .LC5[rip]
	divsd	xmm0, xmm1
	mov	rax, QWORD PTR -64[rbp]
	mov	edx, DWORD PTR -96[rbp]
	movsx	rdx, edx
	movsd	QWORD PTR [rax+rdx*8], xmm0
	add	DWORD PTR -96[rbp], 1
.L10:
	mov	eax, DWORD PTR -100[rbp]
	cmp	DWORD PTR -96[rbp], eax
	jl	.L11
	mov	DWORD PTR -92[rbp], 0
	jmp	.L12
.L13:
	mov	rax, QWORD PTR -64[rbp]
	mov	edx, DWORD PTR -92[rbp]
	movsx	rdx, edx
	movsd	xmm0, QWORD PTR [rax+rdx*8]
	mov	rax, QWORD PTR -80[rbp]
	mov	edx, DWORD PTR -92[rbp]
	movsx	rdx, edx
	mov	rcx, QWORD PTR [rax+rdx*8]
	mov	edx, DWORD PTR -92[rbp]
	mov	eax, DWORD PTR -92[rbp]
	movapd	xmm1, xmm0
	movq	xmm0, rcx
	mov	esi, eax
	lea	rax, .LC6[rip]
	mov	rdi, rax
	mov	eax, 2
	call	printf@PLT
	add	DWORD PTR -92[rbp], 1
.L12:
	mov	eax, DWORD PTR -100[rbp]
	cmp	DWORD PTR -92[rbp], eax
	jl	.L13
	mov	eax, 0
	mov	rsp, rbx
	mov	rdx, QWORD PTR -56[rbp]
	sub	rdx, QWORD PTR fs:40
	je	.L15
	call	__stack_chk_fail@PLT
.L15:
	lea	rsp, -40[rbp]
	pop	rbx
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.section	.rodata
	.align 8
.LC4:
	.long	-1717986918
	.long	1076074905
	.align 8
.LC5:
	.long	0
	.long	1073741824
	.ident	"GCC: (Ubuntu 11.2.0-19ubuntu1) 11.2.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
