#include <stdlib.h>
#include <string.h>
#include <stdio.h>

typedef struct      s_list {
    void            *data;
    struct s_list   *next;
}                   t_list;


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

/**
 * list_remove_if - Remove nodes from a linked list that match a condition.
 *
 * Arguments:
 *   begin_list: The address of a pointer to the first link of a list.
 *   data_ref: The reference data to compare against each node's data.
 *   cmp: Function pointer for comparison logic (returns 0 for match).
 *   free_fct: Function pointer to free the data stored in matching nodes.
 *
 * Returns:
 *   None.
 *
 * Description:
 *   Removes all nodes whose data matches data_ref according to cmp.
 *   Frees node data using free_fct and frees the node itself.
 *   Updates the head pointer if the first node(s) are removed.
 */
void    list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(), void (*free_fct)(void *))
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

int cmp(void *a, void *b) {
    return (strcmp((char *)a, (char *)b));
}

void no_free(void *ptr) {
    // Do nothing - string literals don't need freeing
    (void)ptr;
}
// test code
int main()
{
    t_list *list = NULL;
    void *data1 = "Node 1";
    void *data2 = "Node 2";
    void *data3 = "Node 3";
    void *data4 = "Node 4";
    void *data5 = "Node 2";
    list_push_front(&list, data5);
    list_push_front(&list, data4);
    list_push_front(&list, data3);
    list_push_front(&list, data2);
    list_push_front(&list, data1);   

    t_list *current = list;
    while (current) {
        printf("Node data: %s\n", (char *)current->data);
        current = current->next;
    }
    printf("----- FT_LIST_REMOVE_IF -----\n");
    // void (*free_fct)(void *) = free;
    list_remove_if(&list, "Node 2", (int (*)())cmp, no_free);
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
    return (0);
}
