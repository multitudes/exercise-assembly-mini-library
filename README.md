# libasm-42

## the library

The library must be called libasm.a.

You must rewrite the following functions in assembly:
◦ ft_strlen (man 3 strlen)
◦ ft_strcpy (man 3 strcpy)
◦ ft_strcmp (man 3 strcmp)
◦ ft_write (man 2 write)
◦ ft_read (man 2 read)
◦ ft_strdup (man 3 strdup, you can call to malloc)

You must check for errors during syscalls and handle them properly when needed.
• Your code must set the variable errno properly.
• For that, you are allowed to call the extern ___error or errno_location

## Bonus part
You can rewrite these functions in assembly. The linked list functions will use the follow-
ing structure:
```
typedef struct s_list
{
void *data;
struct s_list *next;
} t_list;
```

• ft_atoi_base (see Annex V.1)
• ft_list_push_front (see Annex V.2)
• ft_list_size (see Annex V.3)
• ft_list_sort (see Annex V.4)
• ft_list_remove_if (see Annex V.5)

## why the no pie?
The compilation flag -no-pie disables Position Independent Executable (PIE) generation. By default, modern compilers produce PIE binaries, which can be loaded at random memory addresses for security (ASLR).

If you use -no-pie, the binary is not position-independent, meaning its code and data are loaded at fixed addresses. This can make certain assembly code easier to write, especially when using absolute addresses, but it reduces security and is not allowed in many coding standards (like 42's libasm) to ensure your code works with modern, secure practices.

## The compilation
Aside
ATT versus Intel assembly-code formats
In our presentation, we show assembly code in ATT format (named after AT&T, the company that
operated Bell Laboratories for many years), the default format for gcc, objdump, and the other tools we
will consider. Other programming tools, including those from Microsoft as well as the documentation
from Intel, show assembly code in Intel format. The two formats differ in a number of ways. As an
example, gcc can generate code in Intel format for the sum function using the following command line:
linux> gcc -Og -S -masm=intel mstore.c
This gives the following assembly code:
```
multstore:
    push rbx
    mov rbx, rdx
    call mult2
    mov QWORD PTR [rbx], rax
    pop rbx
    ret
```
We see that the Intel and ATT formats differ in the following ways:
- The Intel code omits the size designation suffixes. We see instruction push and mov instead of pushq and movq.
- The Intel code omits the ‘%’ character in front of register names, using rbx instead of %rbx.
- The Intel code has a different way of describing locations in memory—for example, QWORD PTR [rbx] rather than (%rbx).
- Instructions with multiple operands list them in the reverse order. This can be very confusing when switching between the two formats.
Although we will not be using Intel format in our presentation, you will encounter it in documentation from Intel and Microsoft.

my first function:
```
#include <stddef.h>

size_t ft_strlen(const char *s) {
    size_t len = 0;
    while (s && s[len]) {
        len++;
    }
    return len;
}
```

compiling with 
```
gcc -Og -S ft_strlen.c
```

I get 
```
	.file	"ft_strlen.c"
	.text
	.globl	ft_strlen
	.type	ft_strlen, @function
ft_strlen:
.LFB0:
	.cfi_startproc
	endbr64
	movl	$0, %eax
	jmp	.L2
.L4:
	addq	$1, %rax
.L2:
	testq	%rdi, %rdi
	je	.L1
	cmpb	$0, (%rdi,%rax)
	jne	.L4
.L1:
	ret
	.cfi_endproc
.LFE0:
	.size	ft_strlen, .-ft_strlen
	.ident	"GCC: (Ubuntu 10.5.0-1ubuntu1~22.04.2) 10.5.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
```
but most of it is metadata so I can just keep the essential.
so this would give me the assembly representation (ATT style)

```
    .text          # Specifies this is the executable code section
    .globl ft_strlen # Makes the function visible to the linker

ft_strlen:
    xor  %eax, %eax         # Clears the counter register %eax to 0. 
                            # writing to a 32-bit register (like %eax) 
                            # automatically zeroes the upper 32 bits of %rax.
	jmp .L2
.L4:
	addq $1, %rax           # Increment the counter
.L2:
	testq %rdi, %rdi        # Check if the pointer is NULL - equivalent to cmpq
	je .L1                  # If NULL, jump to return  
	cmpb $0, (%rdi,%rax)    # Compare byte at address (rdi + rax) with 0
	jne .L4                 # if not equal keep looping
.L1:
	ret
```
to compile into an object in machine code
```
gcc -Og -S ft_strlen.c 
```

then compiling with a fake main like 
```
#include <stdio.h>
extern size_t ft_strlen(const char *s);

int main() {
    printf("%zu\n", ft_strlen("hello"));
    return 0;
}
```

using
```
gcc main.c ft_strlen.o -o test_strlen
```

I get the code working. But this is ATT style.

Lets see how it looks like with the intel style, this is the minimum required:
```
	.intel_syntax noprefix
	.text
	.globl	ft_strlen
ft_strlen:
	xor	eax, eax
	jmp	.L2
.L1:
	add	rax, 1
.L2:
	cmp	BYTE PTR [rdi+rax], 0
	jne	.L1
    ret
```

but this is not the end because the subject wants to use nasm so the code will be different again even if it is in the same intel family. This is the minimal code required for strlen:
```
section .text
global ft_strlen

ft_strlen:
    xor rax, rax            ; Initialize counter 'rax' to 0

.loop:
    cmp byte [rdi + rax], 0 ; Compare the character at s[rax] with the null terminator
    je .end                 ; If it's the end of the string, jump to .end
    inc rax                 ; Otherwise, increment the counter
    jmp .loop               ; Repeat the loop

.end:
    ret                     ; Return the count in 'rax'
```
NB:  
I dont handle the case if str is NULL because not handled in the orig strlen().


NASM (Netwide Assembler) is a standalone assembler for x86 and x86-64 architectures. It uses Intel syntax and is designed for writing low-level assembly code directly.

GCC (GNU Compiler Collection) is a C/C++ compiler that can also assemble code, but it uses the GNU assembler (GAS), which defaults to AT&T syntax and supports different directives and conventions.

**Key differences:**
- NASM uses Intel syntax (e.g., `mov bl, [rdi + rax]`), while GCC/GAS uses AT&T syntax (e.g., `movb (%rdi,%rax), %bl`).
- NASM requires explicit section and global declarations (`section .text`, `global`).
- GCC can compile C and link with assembly, but expects GAS/AT&T syntax in `.s` files by default.
- NASM is more strict and minimal, while GCC/GAS supports more high-level features and debugging info.

to compile i use now:
```
nasm -f elf64 ft_strlen.s -o ft_strlen.o
# using gcc to compile
cc main.c ft_strlen.o -o test_strlen 
./test_strlen 
```