.text
.global _write

// write(int fd, void *buf, size_t count)
// ------------------------------------------
// Behaves like the C write() function.
// Arguments are passed via registers by the caller:
//   x0: file descriptor to write to
//   x1: pointer to buffer where data to write is stored
//   x2: number of bytes to write
// returns: number of bytes written (in x0) or -1 on error

// External function for error handling
.extern ___error

_write:
    mov x16, #4                 // System call number for write on macOS ARM64
    svc #0x80                   // Make the system call
    
    cmp x0, #0                  // Check return value
    bge .ret                    // If x0 >= 0, return it
    
// --- Error Handling Path ---
// The syscall failed. x0 contains a negative error code.
.error:
    neg x0, x0                  // Make it positive
    mov x19, x0                 // Save error code in callee-saved register
    
    // Get the memory address of the global `errno` variable
    bl ___error                 // Call ___error (macOS equivalent of __errno_location)
    
    str w19, [x0]               // Store the error code into errno
    mov x0, #-1                 // Return -1
    
.ret:
    ret