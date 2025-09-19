// need change to void
// ft_list_push_front(t_list **begin_list, void *data);


/**
 * ft_lstadd_front - Add a new node at the beginning of a linked list.
 *
 * Arguments:
 *   lst:  The address of a pointer to the first link of a list.
 *   new_node: The address of a pointer to the node to be added to the list.
 *
 * Returns:
 *   None.
 *
 * Description:
 *   Adds the node 'new_node' at the beginning of the list.
 */
void	ft_lstadd_front(t_list **lst, t_list *new_node)
{
	if (new_node != NULL && *lst != NULL)
	{
		(*lst)->prev = new_node;
		new_node->next = *lst;
	}
	*lst = new_node;
}
