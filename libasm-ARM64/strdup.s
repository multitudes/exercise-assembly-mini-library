.text
.global	_strdup
.extern _malloc

// char *strdup(const char *s);
// ------------------------------------------
// Duplicates the string s by allocating sufficient memory for a copy of s,
// copying the string, and returning a pointer to it.
// Arguments are passed via registers by the caller:
//   x0: pointer to the source string (s)
// Returns: pointer to the duplicated string (or NULL if insufficient memory)

_strdup:
    // Save callee-saved registers
    stp x19, x20, [sp, #-16]!   // Push x19, x20 onto stack
    stp x21, lr, [sp, #-16]!    // Push x21, lr onto stack
    
    mov x19, x0                 // Save source string pointer
    mov x20, #0                 // Initialize length counter
    
    // -- Find the length of the string (including null terminator) --
.len_loop:
    ldrb w21, [x19, x20]        // Load byte from string[length]
    add x20, x20, #1            // Increment length counter
    cbnz w21, .len_loop         // Continue if not null terminator
    
    // Allocate memory: x20 contains the length including null terminator
    mov x0, x20                 // Length to allocate
    bl _malloc                  // Call malloc
    cbz x0, .exit_error         // If malloc failed, return NULL
    
    mov x21, x0                 // Save destination pointer
    mov x1, x19                 // Source pointer
    mov x2, x0                  // Destination pointer for copying
    
    // Copy the string manually
.loop:
    ldrb w3, [x1]               // Load byte from source
    strb w3, [x2]               // Store byte to destination  
    add x1, x1, #1              // Advance source pointer
    add x2, x2, #1              // Advance destination pointer
    cbnz w3, .loop              // Continue if not null terminator
    
    mov x0, x21                 // Return destination pointer
    b .ret
    
.exit_error:
    mov x0, #0                  // Return NULL
    
.ret:
    // Restore callee-saved registers
    ldp x21, lr, [sp], #16      // Pop x21, lr from stack
    ldp x19, x20, [sp], #16     // Pop x19, x20 from stack
    ret

