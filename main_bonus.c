#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include "libasm/libasm_bonus.h"

/**
 * If I pass strings as data which have not malloqued then i pass a no op free function
 * If I pass malloced strings then I pass free as free function
*/
void free_fct(void *ptr) {
    // Do nothing - string literals don't need freeing
    (void)ptr;
}

int main() {
    printf("----- MY_PUTNBR_BASE -----\n");
    printf("Testing putnbr_base with -2147483648:\n");
    putnbr_base(-2147483648, "0123456789ABCDEF");
    printf("\n");
    printf("Testing putnbr_base with 42:\n"); 
    putnbr_base(42, "0123456789");
    printf("\n");
    printf("Testing putnbr_base with -42:\n");
    putnbr_base(-42, "0123456789");
    printf("\n");
    printf("Testing putnbr_base with 255:\n");
    putnbr_base(255, "01");
    printf("\n");
    printf("Testing putnbr_base with 100:\n");
    putnbr_base(100, "poneyvif");
    printf("\n");

    printf("----- MY_LIST_PUSH_FRONT -----\n");
    t_list *list = NULL;
    list_push_front(&list, "Node FAIL");
    *list = (t_list){ .data = "Node start", .next = NULL };
    list_push_front(&list, "Node 1");
    list_push_front(&list, "Node 2");
    list_push_front(&list, "Node 3");
    t_list *current = list;
    while (current) {
        printf("Node data: %s\n", (char *)current->data);
        current = current->next;
    } 
    printf("----- MY_LIST_SIZE -----\n");
    int size = list_size(list);
    printf("List size: %d\n", size);
    size = list_size(NULL);
    printf("Size of NULL list: %d\n", size);

    printf("----- MY_LIST_SORT -----\n");
    int (*cmp)(const char *, const char *) = (int (*)(const char *, const char *))strcmp;
    list_sort(&list, (int (*)())cmp);
    current = list;
    while (current) {
        printf("Node data: %s\n", (char *)current->data);
        current = current->next;
    }

    printf("----- MY_LIST_REMOVE_IF -----\n");
    // void (*free_fct)(void *) = free;
    list_remove_if(&list, "Node 2", (int (*)())cmp, free_fct);
    current = list;
    printf("After removing 'Node 2':\n");
    while (current) {
        printf("Node data: %s\n", (char *)current->data);
        current = current->next;
    }
    // Free remaining nodes
    while (list) {
        t_list *temp = list;
        list = list->next;
        free(temp);
    }
    return 0;
}