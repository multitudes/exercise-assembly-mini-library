#include <stdio.h>
#include <unistd.h>
#include "libasm/libasm_bonus.h"


int main() {
    printf("----- FT_PUTNBR_BASE -----\n");
    printf("Testing ft_putnbr_base with -2147483648:\n");
    ft_putnbr_base(-2147483648, "0123456789ABCDEF");
    printf("\n");
    printf("Testing ft_putnbr_base with 42:\n"); 
    ft_putnbr_base(42, "0123456789");
    printf("\n");
    printf("Testing ft_putnbr_base with -42:\n");
    ft_putnbr_base(-42, "0123456789");
    printf("\n");
    printf("Testing ft_putnbr_base with 255:\n");
    ft_putnbr_base(255, "01");
    printf("\n");
    printf("Testing ft_putnbr_base with 100:\n");
    ft_putnbr_base(100, "poneyvif");
    printf("\n");

    printf("----- FT_LIST_PUSH_FRONT -----\n");
    t_list *list = NULL;
    ft_list_push_front(&list, "Node FAIL");
    *list = (t_list){ .data = "Node start", .next = NULL };
    ft_list_push_front(&list, "Node 1");
    ft_list_push_front(&list, "Node 2");
    ft_list_push_front(&list, "Node 3");
    t_list *current = list;
    while (current) {
        printf("Node data: %s\n", (char *)current->data);
        current = current->next;
    } 
    printf("----- FT_LIST_SIZE -----\n");
    int size = ft_list_size(list);
    printf("List size: %d\n", size);
    size = ft_list_size(NULL);
    printf("Size of NULL list: %d\n", size);
    
    return 0;
}