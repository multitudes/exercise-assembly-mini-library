#ifndef LIBASM_BONUS_H
#define LIBASM_BONUS_H

#include <stdlib.h>

typedef struct      s_list {
    void            *data;
    struct s_list   *next;
}                   t_list;

void    putnbr_base(int nbr, char *base);
void    list_push_front(t_list **begin_list, void *data);
int     list_size(t_list *begin_list);
void    list_sort(t_list **begin_list, int (*cmp)());
void    list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(), void (*free_fct)(void *));

#endif