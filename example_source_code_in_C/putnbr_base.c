
#include <unistd.h>
// #include <stdio.h>
// #include <string.h>

// #define BASE10 "0123456789"
// #define BASE2 "01"
// #define BASE16 "0123456789ABCDEF"
// #define BASE8 "poneyvif"
// #define MINUS "-"
// #define INT_MAX 2147483647
// #define PRINTABLE_INT_MIN "-2147483648"

// need to reverse my string at the very end bef printing
// the results
void	reverse(char *res, int len)
{
	int	j;
	int	c;

	j = 0;
	len--;
	while (j < len)
	{
		c = res[j];
		res[j++] = res[len];
		res[len--] = c;
	}
}

// does get the length of the base as needed for the
// next calcs and checks if the base contains + or - chars
// and double chars - also returns 0 if the base len is 0 or 1
int	check_base_len(char *base)
{
	int		i;
	int		j;

	i = 0;
	while (base[i])
	{
		j = 0;
		if (base[i] == '+' || base[i] == '-')
			return (0);
		while (j < i)
			if (base[j++] == base[i])
				return (0);
		i++;
	}
	if (i == 1 || i <= 0)
		return (0);
	return (i);
}

//passing all pointers to mutate the original values
// in case of INT_MIN I will divide the num by base length to remain
// in the int boundaries and keep the val of the modulo
// to add it the the end -  otherwise it set the val of the int number
// to positive keeing track of the sign
int	get_num_and_base(int *nbr, char *overfl_remainder, char *base, int *len)
{
	*len = check_base_len(base);
	if (!(*len))
		return (0);
	if (*nbr < 0 && *nbr != -2147483647 - 1)
		*nbr = -(*nbr);
	if (*nbr == -2147483647 - 1)
	{
		*overfl_remainder = base[-(*nbr % *len)];
		*nbr /= *len;
		*nbr = -(*nbr);
	}
	return (1);
}

// printf("checking nbr %d, &overfl_remainder %c, base %s,
// &len %d\n", nbr, overfl_remainder, base, len);
void	putnbr_base(int nbr, char *base)
{
	int		i;
	int		sign;
	int		len;
	char	overfl_remainder;
	char	res[33];

	i = 0;
	sign = nbr;
	overfl_remainder = '\0';
	if (!get_num_and_base(&nbr, &overfl_remainder, base, &len))
		return ;
	if (nbr == 0)
		res[i++] = '0';
	while (nbr > 0)
	{
		res[i++] = base[nbr % len];
		nbr /= len;
	}
	if (sign < 0)
		res[i++] = '-';
	reverse(res, i);
	write(1, res, i);
	if (overfl_remainder)
		write(1, &overfl_remainder, 1);
	return ;
}

//  #define INT_MIN (-2147483647 - 1)
// int	main()
// {
// 	putnbr_base(INT_MIN, "01");
// 	return (0);
// }
// // -10000000000000000000000000000000%
// // -10000000000000000000000000000000
