.text
.global _strcmp

// strcmp(const char *s1, const char *s2)
// ------------------------------------------
// Compares the two strings s1 and s2.
// Arguments are passed via registers by the caller:
//   x0: pointer to first string (s1)
//   x1: pointer to second string (s2)
// Returns: an integer less than, equal to, or greater than zero if s1 is
// respectively found to be less than, to match, or be greater than s2.

_strcmp:
    // Check if both pointers are NULL
    orr x2, x0, x1
    cbz x2, .ret_zero
    
.loop:
    ldrb w2, [x0]           // Load byte from s1
    ldrb w3, [x1]           // Load byte from s2
    
    cmp w2, w3              // Compare characters
    bne .not_equal          // If not equal, calculate difference
    
    cbz w2, .ret_zero       // If both are null terminators, strings are equal
    
    add x0, x0, #1          // Move to next char in s1
    add x1, x1, #1          // Move to next char in s2
    b .loop                 // Continue loop
    
.not_equal:
    sub w0, w2, w3          // Calculate difference (s1[i] - s2[i])
    ret
    
.ret_zero:
    mov w0, #0              // Return 0 (strings are equal)
    ret
