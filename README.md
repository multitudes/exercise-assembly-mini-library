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

- atoi_base - convert an integer to different bases
- list_push_front
- list_size 
- list_sort 
- list_remove_if - remove a node if a compare function says the node is same

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
> The Intel and ATT formats differ in the following ways:
>- The Intel code omits the size designation suffixes. We see instruction push and mov instead of pushq and movq.
>- The Intel code omits the ‘%’ character in front of register names, using rbx instead of %rbx.
>- The Intel code has a different way of describing locations in memory—for example, QWORD PTR [rbx] rather than (%rbx).
>- Instructions with multiple operands list them in the reverse order. This can be very confusing when switching between the two formats.

Yes it is quite confusing! 

## Starting with my version of strlen

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
