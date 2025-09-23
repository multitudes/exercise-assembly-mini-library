.text
.global _strlen

_strlen:
    mov x1, #0              // Initialize counter to 0
    
.loop:
    ldrb w2, [x0, x1]       // Load byte from string[counter] into w2
    cbz w2, .end            // If zero, branch to end
    add x1, x1, #1          // Increment counter
    b .loop                 // Branch back to loop
    
.end:
    mov x0, x1              // Return counter value in x0
    ret                     // Return