# Learning Assembly: libasm Project

These are my personal notes.
Note: I am compiling with `gcc`, but `clang` works just as well. In fact, I switched to `clang` for the last part of my work.

## Creating a Static Library

I am building a **static library** (`.a` archive) using the `ar` (archiver) command. This library contains my assembly implementations and is linked into my executable at compile time.
All x86-64 assembly code is written in Intel syntax, specifically for the `nasm` assembler.


**Static Library (`.a`):**

- Code is embedded into your executable at link time
- Larger executable size
- No external dependencies at runtime

**Dynamic Library (`.so` on Linux, `.dll` on Windows):**
- Code remains separate, loaded at runtime
- Smaller executable size
- Requires the library to be present on the target system

**Makefile Example:**
```makefile
$(NAME): $(OBJS)
	ar rcs $@ $^
```

The `ar rcs` command:
- `ar` = archiver tool
- `r` = insert files into archive
- `c` = create archive if it doesn't exist
- `s` = write an index (equivalent to running `ranlib`)

I will rewrite the following C functions in assembly:
- strlen (man 3 strlen)
- strcpy (man 3 strcpy)
- strcmp (man 3 strcmp)
- write (man 2 write)
- read (man 2 read)
- strdup (man 3 strdup, I will call malloc)

```c
typedef struct s_list {
	void *data;
	struct s_list *next;
} t_list;
```

You will also implement these bonus functions:
- atoi_base (see Annex V.1)
- list_push_front (see Annex V.2)
- list_size (see Annex V.3)
- list_sort (see Annex V.4)
- list_remove_if (see Annex V.5)

Error handling:
- Check for errors during syscalls and handle them properly
- Set the variable `errno` as needed
- Call the external `__errno_location` (or `___error` on some systems)

## What is the --no-pie Flag?

The `--no-pie` compilation flag disables Position Independent Executable (PIE) generation. By default, modern compilers produce PIE binaries, which can be loaded at random memory addresses for security (ASLR).

If you use `--no-pie`, the binary is not position-independent, meaning its code and data are loaded at fixed addresses. This can make certain assembly code easier to write, especially when using absolute addresses, but it reduces security and is not allowed in many coding standards.

## ATT vs Intel Assembly Formats

In the book "Computer Systems: A Programmer's Perspective" they write:
> In our presentation, we show assembly code in ATT format (named after AT&T, the company that operated Bell Laboratories for many years), the default format for gcc, objdump, and the other tools we will consider.  
Other programming tools, including those from Microsoft as well as the documentation from Intel, show assembly code in Intel format. The two formats differ in a number of ways. As an example, gcc can generate code in Intel format for the sum function using the following command line:
```bash
gcc -Og -S -masm=intel mstore.c
```
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

The Intel and ATT formats differ in the following ways:
- The Intel code omits the size designation suffixes. We see instruction push and mov instead of pushq and movq.
- The Intel code omits the ‘%’ character in front of register names, using rbx instead of %rbx.
- The Intel code has a different way of describing locations in memory—for example, QWORD PTR [rbx] rather than (%rbx).
- Instructions with multiple operands list them in the reverse order. This can be very confusing when switching between the two formats.


## Starting with strlen

Example C implementation:
```c
#include <stddef.h>
size_t strlen(const char *s) {
	size_t len = 0;
	while (s && s[len]) {
		len++;
	}
	return len;
}
```

Note: Like the original `strlen`, this does not check for NULL pointers and will fail with invalid input.

Compile with:
```bash
gcc -Og -S strlen.c
```

The `-Og` option disables optimizations for easier reading.

Essential ATT-style assembly:
```assembly
.text          # Executable code section
.globl strlen  # Function visible to linker
strlen:
	xor  %eax, %eax         # Clear counter
	jmp .L2
.L4:
	addq $1, %rax           # Increment counter
.L2:
	testq %rdi, %rdi        # Check pointer for NULL
	je .L1                  # If NULL, return
	cmpb $0, (%rdi,%rax)    # Compare byte at s[len]
	jne .L4                 # Loop if not zero
.L1:
	ret
```

## NASM Style

Minimal NASM-compatible code for `strlen`:
```nasm
section .text
global strlen
strlen:
	xor rax, rax            ; Initialize counter
.loop:
	cmp byte [rdi + rax], 0 ; Compare character at s[rax]
	je .end                 ; If null terminator, end
	inc rax                 ; Increment counter
	jmp .loop               ; Repeat
.end:
	ret                     ; Return count in rax
```
Note: No NULL pointer check, matching the original `strlen` behavior.

## NASM vs GCC

NASM (Netwide Assembler) is a standalone assembler for x86 and x86-64 architectures, using Intel syntax. GCC uses the GNU assembler (GAS), which defaults to AT&T syntax.

**Key differences:**
- NASM: explicit section/global declarations, strict syntax
- GCC/GAS: AT&T syntax, more high-level features and debugging info

## Linking and Testing

To compile and link your assembly code:
```bash
# Compile C to assembly (ATT style)
gcc -Og -S strlen.c

# Compile main and link object file
gcc main.c strlen.o -o test_strlen

# For NASM style
nasm -f elf64 strlen.s -o strlen.o

gcc main.c strlen.o -o test_strlen
./test_strlen
```

## PIE (Position-Independent Executable) Compatibility

PIE-compatible code is much safer. Without PIE (`--no-pie`), your program loads at a fixed address, making it easier for attackers to exploit vulnerabilities. With PIE, the OS can randomize your program's memory location (ASLR), making attacks much harder.

**Why PIE is safer:**
- Fixed addresses are predictable and easier to exploit
- PIE enables ASLR, randomizing addresses each run

**How to call external functions in PIE:**
```nasm
	; Get the memory address of the global `errno` variable from libc.
	; The 'wrt ..plt' syntax is essential for PIE compatibility.
	call __errno_location wrt ..plt
```
This uses the Procedure Linkage Table (PLT) to resolve the address at runtime.

## Loading 1 Byte vs 8 Bytes

- `mov cl, [r15]` loads 1 byte (8 bits) into the lower part of `rcx`
- `mov rcx, [r15]` loads 8 bytes (64 bits) into the entire `rcx` register

The size of the move depends on the register:
- `cl` → 8 bits
- `cx` → 16 bits
- `ecx` → 32 bits
- `rcx` → 64 bits

## Reading Data from a Pointer

NASM size specifiers:
- `byte [addr]` = 8 bits (1 byte)
- `word [addr]` = 16 bits (2 bytes)
- `dword [addr]` = 32 bits (4 bytes)
- `qword [addr]` = 64 bits (8 bytes)
- `tword [addr]` = 80 bits (10 bytes)
- `oword [addr]` = 128 bits (16 bytes)
- `yword [addr]` = 256 bits (32 bytes)
- `zword [addr]` = 512 bits (64 bytes)

Example:
```nasm
mov qword [rax], rbp    ; store 64-bit data pointer
mov qword 8[rax], rdx   ; store 64-bit next pointer
```

The progression is: `byte` → `word` → `dword` → `qword` → `tword` → `oword` → `yword` → `zword`. 

## The Meaning of 0xFFF

`0xfff` (4095 decimal) is significant in low-level programming:

**1. Memory Alignment & Page Boundaries**
- Used as a page size mask for 4KB pages
- `address & 0xfff` gives offset within a page
- `address & ~0xfff` gives page-aligned base address

**2. Buffer Overflow & Exploitation**
- Return addresses, stack canaries, heap metadata, shellcode addresses

**3. Hardware Register Masks**
- Masks out lower 12 bits, common in MMUs and interrupt controllers

**4. Assembly Context**
```assembly
; Align stack to 16-byte boundary
and rsp, 0xfffffffffffffff0
; Check if address is page-aligned
test rdi, 0xfff
jz page_aligned
; Get page offset
mov rax, rdi
and rax, 0xfff
```

**5. Exploitation Techniques**
- ASLR bypass, heap manipulation, format string attacks

**6. Security Research**
- Memory corruption, fuzzing, reverse engineering

`0xfff` is a natural boundary in computer systems, often used for alignment and security analysis.
# Learning some assembly code

## creating a static library
Yes, absolutely! You are creating a **static library**.

## **What makes it a static library:**

1. **File extension**: `.a` (archive)
2. **Creation method**: Using `ar` (archiver) command
3. **Linking behavior**: Code is copied into the final executable at compile time

```makefile
$(NAME): $(OBJS)
	ar rcs $@ $^
```

The `ar rcs` command:
- `ar` = archiver tool
- `r` = insert files into archive
- `c` = create archive if it doesn't exist
- `s` = write an index (equivalent to running `ranlib`)

## **Static vs Dynamic Libraries:**

**Static Library (`.a`):**
- Code is **embedded** into your executable at link time
- Larger executable size
- No external dependencies at runtime
- Your `libasm.a` is this type

**Dynamic Library (`.so` on Linux, `.dll` on Windows):**
- Code remains separate, loaded at runtime
- Smaller executable size
- Requires the library to be present on the target system

## **Your linking process:**
```bash
gcc main.c -Llibasm -lasm -o test_strlen
```
- `-L` specifies library search path
- `-l` links with `libasm.a` (static linking)
- The object code from your assembly functions gets copied into the final `test_strlen` executable

`libasm.a` is a static library.

I will rewrite the following C functions in assembly:
◦ strlen (man 3 strlen)
◦ strcpy (man 3 strcpy)
◦ strcmp (man 3 strcmp)
◦ write (man 2 write)
◦ read (man 2 read)
◦ strdup (man 3 strdup, I will call malloc)

```
typedef struct s_list
{
void *data;
struct s_list *next;
} t_list;
```

• atoi_base (see Annex V.1)
• list_push_front (see Annex V.2)
• list_size (see Annex V.3)
• list_sort (see Annex V.4)
• list_remove_if (see Annex V.5)

I will check for errors during syscalls and handle them properly when needed.
My code will set the variable errno properly.
I will call the extern ___error or errno_location

## what is the --no-pie flag?
The compilation flag --no-pie disables Position Independent Executable (PIE) generation. By default, modern compilers produce PIE binaries, which can be loaded at random memory addresses for security (ASLR).

If you use -no-pie, the binary is not position-independent, meaning its code and data are loaded at fixed addresses. This can make certain assembly code easier to write, especially when using absolute addresses, but it reduces security and is not allowed in many coding standards.

## The compilation

ATT versus Intel assembly-code formats
In the book "systems: a programmers perspective"
> In our presentation, we show assembly code in ATT format (named after AT&T, the company that
operated Bell Laboratories for many years), the default format for gcc, objdump, and the other tools we will consider. Other programming tools, including those from Microsoft as well as the documentation from Intel, show assembly code in Intel format. The two formats differ in a number of ways. As an example, gcc can generate code in Intel format for the sum function using the following command line:
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

## starting with strlen

my first function in C it would be written like:
```
#include <stddef.h>

size_t strlen(const char *s) {
    size_t len = 0;
    while (s && s[len]) {
        len++;
    }
    return len;
}
```
Yes I know there is no cheeck for the NULL pointer for s exactly like the original strlen this will fail miserably with the wrong input!

compiling with:
```
gcc -Og -S strlen.c
```
The Og option here it sto disable compiler optimisations

With the above, I get the ATT style
```
	.file	"strlen.c"
	.text
	.globl	strlen
	.type	strlen, @function
strlen:
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
	.size	strlen, .-strlen
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
but most of it is metadata (the lines starting with the dot) so I can remove them and just keep the essential to better understand what the assembly does.
this would give me the assembly representation (ATT style)

```
    .text          # Specifies this is the executable code section
    .globl strlen # Makes the function visible to the linker

strlen:
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

## The Intel style and nasm
I get the code, but this is ATT style. To get it into intel and nasm compatible style I use these options:
```
cc -Og -S -masm=intel  strlen.c
```

Lets see how it looks like now, this is the minimum required:
```
	.intel_syntax noprefix
	.text
	.globl	strlen
strlen:
	xor	eax, eax
	jmp	.L2
.L1:
	add	rax, 1
.L2:
	cmp	BYTE PTR [rdi+rax], 0
	jne	.L1
    ret
```

but this is not the end because if I want to use nasm the code will be different again even if it is in the same intel family. This is the minimal code required for strlen which will compile with nasm:
```
section .text
global strlen

strlen:
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

## NASM
NASM (Netwide Assembler) is a standalone assembler for x86 and x86-64 architectures. It uses Intel syntax and is designed for writing low-level assembly code directly.

GCC (GNU Compiler Collection) is a C/C++ compiler that can also assemble code, but it uses the GNU assembler (GAS), which defaults to AT&T syntax and supports different directives and conventions.

**Key differences:**
- nasm (e.g., `mov bl, [rdi + rax]`), while GCC/GAS uses AT&T syntax (e.g., `movb (%rdi,%rax), %bl`).
- NASM requires explicit section and global declarations (`section .text`, `global`).
- GCC can compile C and link with assembly, but expects GAS/AT&T syntax in `.s` files by default.
- NASM is more strict and minimal, while GCC/GAS supports more high-level features and debugging info.


## linking
to compile into an object in machine code AT&T style
```
gcc -Og -S strlen.c 
```

then compiling with a fake main like 
```
#include <stdio.h>
extern size_t strlen(const char *s);

int main() {
    printf("%zu\n", strlen("hello"));
    return 0;
}
```

using
```
gcc main.c strlen.o -o test_strlen
```

I get the code working. But this is ATT style. To get it into nasm style I use `-masm=intel` option with clang or gcc
```
gcc -Og -S -masm=intel  strlen.c
```

to link and test i use now:
```
# create the object file in machine code
nasm -f elf64 strlen.s -o strlen.o
# using gcc to compile the main and link the objeck file
gcc main.c strlen.o -o test_strlen 
# run
./test_strlen 
```

## PIE (Position-Independent Executable) compatibility

This is a big one. It would be easy to declare the 
```
extern __errno_location
```
in our code and then use the --no-pie flag to call the function directly but we are not going to use the flag. why? because the PIE is better.
PIE-compatible code is considered much safer.

Here’s a breakdown of why:

1. The Old Way: Predictable Memory Addresses

Without PIE (i.e., when you use --no-pie), your program is compiled to load at a fixed, predictable memory address every single time it runs. An attacker who finds a vulnerability in your program (like a buffer overflow) knows exactly where your functions and data are in memory.

This makes it dangerously easy for them to hijack the program's execution by overwriting a return address on the stack to point to a specific known location, a technique used in many exploits.

2. The New Way (PIE): Address Space Layout Randomization (ASLR)

Modern operating systems use a security feature called Address Space Layout Randomization (ASLR). ASLR randomizes the memory locations of a program's key areas—like the stack, heap, and linked libraries—each time it's launched.

However, for ASLR to be fully effective, the main program executable itself must also be loaded at a random address. This is only possible if the executable is a Position-Independent Executable (PIE).

## Why PIE is Safer

By compiling your code as a PIE, you allow the operating system to load your entire program at a different memory address every time.

    Before (with --no-pie): An attacker knows your read function is always at address 0x400510.

    After (with PIE): An attacker has no idea where read is. It could be at 0x55c3a19e8000 on one run and 0x56a4b28f7000 on the next.

This randomization makes it incredibly difficult for an attacker to successfully execute malicious code. If they try to jump to a hardcoded address, the program will most likely just crash instead of being exploited.

In summary, you are encouraged to write PIE-compatible code (and avoid --no-pe) because it opts your program into a critical, modern security feature that protects it from a large class of common memory-corruption attacks.

But it requires some tewaks in our code.  not much. 
```
    ; Get the memory address of the global `errno` variable from libc.
    ; The 'wrt ..plt' syntax on the call is essential for PIE compatibility.
    call __errno_location wrt ..plt
```
This memory address is passed at runtime
The line call __errno_location wrt ..plt is precisely the mechanism that finds the address of the __errno_location function and executes it at runtime.

Here's a slightly more detailed breakdown of why this is necessary:

    Dynamic Linking: Your program doesn't contain the code for __errno_location; that code lives in the C standard library (libc), which is loaded into memory separately when your program starts.

    Unknown Address: Because of ASLR (Address Space Layout Randomization), neither your program nor the C library knows its own final memory address until the OS loader puts them there at runtime.

    The PLT's Job: The PLT (Procedure Linkage Table) acts as a middleman. Your call instruction doesn't jump directly to the final address (which it can't know). Instead, it jumps to a small stub of code in the PLT. This stub's job is to look up the current, real-time address of __errno_location and then jump to it.

## loading 1 byte vs 8 bytes
- `mov cl, [r15]` loads 1 byte (8 bits) into the lower part of `rcx`.
- `mov rcx, [r15]` loads 8 bytes (64 bits) from memory into the entire `rcx` register.

So, the size of the move depends on the register you use:
- `cl` → 8 bits
- `cx` → 16 bits
- `ecx` → 32 bits
- `rcx` → 64 bits


## reading the data from a pointer


**NASM size specifiers:**
- `byte [addr]` = 8 bits (1 byte)
- `word [addr]` = 16 bits (2 bytes) 
- `dword [addr]` = 32 bits (4 bytes) - "double word"
- `qword [addr]` = 64 bits (8 bytes) - "quad word"
- `tword [addr]` = 80 bits (10 bytes) - "ten bytes" (for x87 floating point)
- `oword [addr]` = 128 bits (16 bytes) - "octa word" (for SSE)
- `yword [addr]` = 256 bits (32 bytes) - for AVX
- `zword [addr]` = 512 bits (64 bytes) - for AVX-512

example
```nasm
mov qword [rax], rbp    ; store 64-bit data pointer
mov qword 8[rax], rdx   ; store 64-bit next pointer
```

The progression is: `byte` → `word` → `dword` → `qword` → `tword` → `oword` → `yword` → `zword`. 

## the meaning of 0XFFF
`0xfff` has several special meanings in hacking and low-level programming:

## **1. Memory Alignment & Page Boundaries**
- `0xfff` = 4095 in decimal = 111111111111 in binary (12 bits all set to 1)
- Common use: **Page size mask** for 4KB pages (4096 bytes = 0x1000)
- `address & 0xfff` gives you the **offset within a page**
- `address & ~0xfff` gives you the **page-aligned base address**

## **2. Buffer Overflow & ROP Exploitation**
- **Return addresses** often end in `0xfff` when targeting specific memory regions
- **Stack canaries** and **heap metadata** manipulation
- **Shellcode addresses** in exploit development

## **3. Hardware Register Masks**
- Many hardware registers use 12-bit fields
- `0xfff` masks out everything except the lower 12 bits
- Common in **memory management units (MMU)** and **interrupt controllers**

## **4. Assembly & Reverse Engineering Context**
In your libasm project, you might encounter `0xfff` when:

```assembly
; Example: Aligning stack to 16-byte boundary
and rsp, 0xfffffffffffffff0    ; Clear lower 4 bits

; Example: Checking if address is page-aligned
test rdi, 0xfff               ; Test lower 12 bits
jz page_aligned               ; Jump if zero (aligned)

; Example: Getting page offset
mov rax, rdi
and rax, 0xfff                ; Keep only offset within page
```

## **5. Exploitation Techniques**
- **ASLR bypass**: Using known offsets with `0xfff` patterns
- **Heap feng shui**: Controlling allocation patterns
- **Format string attacks**: Address manipulation

## **6. Security Research**
- **Vulnerability research**: Memory corruption patterns
- **Fuzzing**: Boundary condition testing
- **Reverse engineering**: Pattern recognition in binaries

The "hacker significance" comes from `0xfff` being a **natural boundary** in computer systems - it's where pages, permissions, and memory layouts often align, making it a critical value for understanding and exploiting system behavior!

In your assembly functions, you might use similar patterns for memory alignment, bounds checking, or when interfacing with system calls that expect page-aligned addresses.

## the last function - the remove_ifs

## My Last Function: `list_remove_if`

This function can be tricky to understand at first. Here is the relevant assembly, compiled from C and adapted for NASM:

```nasm
lea rax, [rbp + 8]         ; rax = address of prev->next (if prev is not NULL)
test rbp, rbp              ; test if prev is NULL
cmove rax, r12             ; if prev is NULL, rax = r12 (address of *begin_list)
mov rcx, qword [rbx + 8]   ; rcx = current->next
mov qword [rax], rcx       ; update pointer
```

This matches the C logic:

```c
if (prev)
    prev->next = current->next;
else
    *begin_list = current->next;
```

Before removing a node, I check if there is a previous node. If not, the node to remove is the head of the list. In assembly, I first calculate the address for `prev->next` and store it in `rax`. If `prev` is NULL, this would be a garbage address, but the conditional move (`cmove`) updates `rax` to the correct address (`*begin_list`). I then update the pointer to skip the node being removed.

### Case 1: `rbp != NULL` (removing a middle or end node)
```nasm
lea rax, [rbp + 8]      ; rax = address of prev->next
test rbp, rbp           ; rbp is NOT NULL
cmove rax, r12          ; does NOT execute (condition false)
mov qword [rax], rcx    ; prev->next = current->next
```

### Case 2: `rbp == NULL` (removing the first node)
```nasm
lea rax, [rbp + 8]      ; rax = 0 + 8 = 8 (garbage address)
test rbp, rbp           ; rbp IS NULL (zero flag set)
cmove rax, r12          ; executes! rax = r12 = &(*begin_list)
mov qword [rax], rcx    ; *begin_list = current->next
```

**Why this is clever:**

- When `rbp != NULL`, `rax` keeps the correct address from `lea`.
- When `rbp == NULL`, `cmove` overwrites `rax` with the correct address (`r12`).

The initial `lea` result (8) when `rbp` is NULL is garbage, but it is immediately replaced by `cmove` with the proper value. This way, both cases end up with `rax` containing the right address to update, and I avoid any segfaults or undefined behavior.


## Resources
["Computer Systems: A Programmer's Perspective](https://csapp.cs.cmu.edu/)  
