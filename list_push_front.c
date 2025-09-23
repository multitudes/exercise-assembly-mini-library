#include <stddef.h>
#include <stdlib.h>

/**
 * struct s_list - A node in a singly linked list
 * @data: Generic pointer to the data stored in this node
 * @next: Pointer to the next node in the list, or NULL if this is the last node
 *
 * Description:
 *   This structure represents a single node in a singly linked list.
 *   The list can store any type of data through the generic void pointer.
 *   
 *   Memory layout (64-bit system):
 *   - data: 8 bytes (offset 0) - pointer to actual data
 *   - next: 8 bytes (offset 8) - pointer to next s_list node
 *   - Total size: 16 bytes
 *
 * Usage:
 *   - data can point to integers, strings, structures, or any other data type
 *   - next forms the chain connecting nodes together
 *   - A NULL next pointer indicates the end of the list
 *   - The actual data is stored separately; this struct only holds pointers
 *
 * Example:
 *   [Node1: data->int(42), next]->[Node2: data->str("hello"), next]->[NULL]
 */
typedef struct      s_list {
    void            *data;
    struct s_list   *next;
}                   t_list;


/**
 * list_push_front - Add a new node at the beginning of a linked list.
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
void	list_push_front(t_list **begin_list, void *data)
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
