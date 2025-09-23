#include <stddef.h>
#include <stdlib.h>

typedef struct      s_list {
    void            *data;
    struct s_list   *next;
}                   t_list;

void	list_sort(t_list **begin_list, int (*cmp)())
{
    t_list	*i;
    t_list	*j;
    void	*temp;

    if (!begin_list || !*begin_list)
        return ;
    i = *begin_list;
    while (i->next)
    {
        j = i->next;
        while (j)
        {
            if (cmp(i->data, j->data) > 0)
            {
                temp = i->data;
                i->data = j->data;
                j->data = temp;
            }
            j = j->next;
        }
        i = i->next;
    }
}