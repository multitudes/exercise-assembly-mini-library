#include <stddef.h>
#include <stdlib.h>

typedef struct      s_list {
    void            *data;
    struct s_list   *next;
}                   t_list;


/**
 * ft_list_push_front - Add a new node at the beginning of a linked list.
 *
 * Arguments:
 *   begin_list: The address of a pointer to the first link of a list.
 *   data: The data to store in the new node.
 *
 * Returns:
 *   None.
 *
 * Description:
 *   Creates a new node with 'data' and adds it at the beginning of the list.
 */
void	ft_list_push_front(t_list **begin_list, void *data)
{
	t_list *new_node;
	if (!begin_list)
		return;

	new_node = (t_list *)malloc(sizeof(t_list));
	if (!new_node)
		return;
	new_node->data = data;
	new_node->next = *begin_list;
	*begin_list = new_node;
}
