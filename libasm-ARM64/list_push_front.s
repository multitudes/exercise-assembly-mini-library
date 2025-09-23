.text
.global	_list_push_front

.extern _malloc

// list_push_front(t_list **begin_list, void *data)
// ------------------------------------------
// Adds a new element at the beginning of the list.
// Arguments are passed via registers by the caller:
//   x0: pointer to the head of the list (t_list **begin_list)
//   x1: pointer to the data to be stored in the new element (void *data)
// Returns: nothing

_list_push_front:    
    cbz x0, .ret                // null pointer check for begin_list
    
    // Save callee-saved registers
    stp x19, x20, [sp, #-16]!   // Push x19, x20 onto stack
    stp lr, x21, [sp, #-16]!    // Push lr, x21 onto stack
    
    mov x19, x0                 // save begin_list pointer in x19
    mov x20, x1                 // save data pointer in x20
    
    mov x0, #16                 // size of new t_list node (2 pointers of 8 bytes each)
    bl _malloc                  // call malloc to allocate memory for new node
    cbz x0, .prepare_exit       // if malloc returned NULL, exit
    
    str x20, [x0]               // set new_node->data = data
    ldr x21, [x19]              // x21 = *begin_list (the old head)
    str x21, [x0, #8]           // set new_node->next = *begin_list (the old head)
    str x0, [x19]               // set *begin_list = new_node (update head)
    
.prepare_exit:
    // Restore callee-saved registers
    ldp lr, x21, [sp], #16      // Pop lr, x21 from stack
    ldp x19, x20, [sp], #16     // Pop x19, x20 from stack
    ret
    
.ret:
    ret
