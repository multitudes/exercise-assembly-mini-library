/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_list_size.c                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lbrusa <lbrusa@student.42.fr>              +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/11/11 18:00:45 by lbrusa            #+#    #+#             */
/*   Updated: 2025/09/19 14:38:07 by lbrusa           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

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

	i = 1;
	if (lst == NULL)
		return (0);
	while (lst->next != NULL)
	{
		lst = lst->next;
		i++;
	}
	return (i);
}
