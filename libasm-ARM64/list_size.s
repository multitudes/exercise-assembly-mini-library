.text
.global	_list_size

// list_size(t_list *lst)
// ------------------------------------------
// Counts the number of elements in a linked list.
// Arguments are passed via registers by the caller:
//   x0: pointer to the head of the list (t_list *lst)
// Returns: the number of elements in the list (in x0)

_list_size:
    mov w1, #0                  // Initialize counter to 0
    cbz x0, .end                // Check if lst is NULL and return if so
    
.loop:
    ldr x0, [x0, #8]            // Access the next pointer (lst->next)
    add w1, w1, #1              // Increment counter
    cbnz x0, .loop              // If lst->next is not NULL, continue the loop
    
.end:
    mov w0, w1                  // Return counter value
    ret

