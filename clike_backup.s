	.file	"t3.cpp"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$144, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movabsq	$2338328219631577204, %rax
	movq	%rax, -144(%rbp)
	movabsq	$8030798266425702765, %rax
	movq	%rax, -136(%rbp)
	movabsq	$7956016061199967597, %rax
	movq	%rax, -128(%rbp)
	movabsq	$7310503770996482151, %rax
	movq	%rax, -120(%rbp)
	movabsq	$11439350314099, %rax
	movq	%rax, -112(%rbp)
	leaq	-104(%rbp), %rdx
	movl	$0, %eax
	movl	$11, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	-144(%rbp), %rax
	movq	%rax, %rdi
	call	_Z5checkPc
	movl	$0, %eax
	movq	-8(%rbp), %rsi
	xorq	%fs:40, %rsi
	je	.L3
	call	__stack_chk_fail@PLT
.L3:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.section	.rodata
	.align 8
.LC0:
	.string	"str has two similar words together"
	.align 8
.LC1:
	.string	"str does not contain two similar words together"
	.text
	.globl	_Z5checkPc
	.type	_Z5checkPc, @function
_Z5checkPc:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-40(%rbp), %rax
	movq	%rax, -16(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, -24(%rbp)
	movl	$0, -28(%rbp)
.L6:
	movq	-24(%rbp), %rax
	addq	$1, %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$32, %al
	je	.L5
	jmp	.L6
.L5:
	movq	-24(%rbp), %rax
	addq	$1, %rax
	movq	%rax, -24(%rbp)
.L16:
	movq	-24(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$10, %al
	je	.L20
	movb	$1, -29(%rbp)
.L10:
	movq	-24(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$32, %al
	je	.L9
	movq	-16(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$32, %al
	je	.L9
	movzbl	-29(%rbp), %edx
	movq	-24(%rbp), %rax
	movzbl	(%rax), %ecx
	movq	-16(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	%al, %cl
	sete	%al
	movzbl	%al, %eax
	andl	%edx, %eax
	testl	%eax, %eax
	setne	%al
	movb	%al, -29(%rbp)
	movq	-24(%rbp), %rax
	addq	$1, %rax
	movq	%rax, -24(%rbp)
	addq	$1, -16(%rbp)
	jmp	.L10
.L9:
	movzbl	-29(%rbp), %edx
	movq	-16(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$32, %al
	jne	.L11
	movq	-24(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$32, %al
	jne	.L11
	movl	$1, %eax
	jmp	.L12
.L11:
	movl	$0, %eax
.L12:
	movzbl	%al, %eax
	andl	%edx, %eax
	testl	%eax, %eax
	setne	%al
	movb	%al, -29(%rbp)
	cmpb	$0, -29(%rbp)
	je	.L13
	movl	$1, -28(%rbp)
	jmp	.L8
.L13:
	addq	$1, -16(%rbp)
	movq	-16(%rbp), %rax
	subq	$1, %rax
	movzbl	(%rax), %eax
	cmpb	$32, %al
	je	.L14
	jmp	.L13
.L14:
	movq	-24(%rbp), %rax
	addq	$1, %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	subq	$1, %rax
	movzbl	(%rax), %eax
	cmpb	$32, %al
	je	.L16
	jmp	.L14
.L20:
	nop
.L8:
	cmpl	$0, -28(%rbp)
	je	.L17
	leaq	.LC0(%rip), %rdi
	call	puts@PLT
	jmp	.L21
.L17:
	leaq	.LC1(%rip), %rdi
	call	puts@PLT
.L21:
	nop
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L19
	call	__stack_chk_fail@PLT
.L19:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	_Z5checkPc, .-_Z5checkPc
	.ident	"GCC: (Ubuntu 6.2.0-5ubuntu12) 6.2.0 20161005"
	.section	.note.GNU-stack,"",@progbits
