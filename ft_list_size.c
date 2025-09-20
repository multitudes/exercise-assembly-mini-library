
#include <stddef.h>

typedef struct      s_list {
    void            *data;
    struct s_list   *next;
}                   t_list;


/**
 * ft_lstsize - Count the number of nodes in a linked list.
 *
 * Arguments:
 *   lst: The beginning of the list.
 *
 * Returns:
 *   The length of the list (number of nodes).
 *
 * Description:
 *   Iterates through the list and returns the total number of nodes.
 */
int	ft_list_size(t_list *lst)
{
	int	i;

	if (lst == NULL)
		return (0);
	i = 1;
	while (lst->next)
	{
		lst = lst->next;
		i++;
	}
	return (i);
}
