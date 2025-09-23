.text
.global _my_strcpy

// my_strcpy(char *dest, const char *src)
// ------------------------------------------
// Copies the string pointed to by src (including the null terminator)
// to the buffer pointed to by dest.
// Arguments are passed via registers by the caller:
//   x0: pointer to destination buffer (dest)
//   x1: pointer to source string (src)
// Returns: pointer to destination buffer (dest) in x0

_my_strcpy:
    mov x2, x0              // Save original destination pointer for return value
    
.loop:
    ldrb w3, [x1]           // Load one byte from source (src) into w3
    strb w3, [x0]           // Store that byte in destination (dest)
    add x1, x1, #1          // Increment src pointer
    add x0, x0, #1          // Increment dest pointer
    cbnz w3, .loop          // If byte is not zero, repeat the loop
    
    mov x0, x2              // Restore original destination pointer
    ret                     // Return
