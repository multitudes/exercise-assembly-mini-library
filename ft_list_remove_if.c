

typedef struct     s_list
{
    struct s_list   *next;
    void            *data;
}                   t_list;

void    ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(), void (*free_fct)(void *))
{
    t_list *current;
    t_list *temp;
    t_list *prev;

    if (!begin_list || !*begin_list)
        return;
    current = *begin_list;
    prev = NULL;
    while (current)
    {
        if (cmp(current->data, data_ref) == 0) {
            if (prev)
                prev->next = current->next;
            else 
                *begin_list = current->next;  // if no prev then I am on the head and I move it to next
            temp = current;
            current = current->next;
            free_fct(temp->data);
            free(temp);
        } else {
            prev = current;
            current = current->next;

        }
    }

}
