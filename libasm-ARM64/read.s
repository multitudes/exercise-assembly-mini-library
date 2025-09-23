.text
.global _read

// External function for error handling
.extern ___error

// read(int fd, void *buf, size_t count)
// ------------------------------------------
// Behaves like the C read() function.
// Arguments are passed via registers by the caller:
//   x0: file descriptor to read from
//   x1: pointer to buffer where read data will be stored
//   x2: number of bytes to read
// returns: number of bytes read (in x0) or -1 on error

_read:
    mov x16, #3                 // System call number for read on macOS ARM64
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
