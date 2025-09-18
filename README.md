# libasm-42

## the library

The library must be called libasm.a.

You must rewrite the following functions in assembly:
◦ ft_strlen (man 3 strlen)
◦ ft_strcpy (man 3 strcpy)
◦ ft_strcmp (man 3 strcmp)
◦ ft_write (man 2 write)
◦ ft_read (man 2 read)
◦ ft_strdup (man 3 strdup, you can call to malloc)

You must check for errors during syscalls and handle them properly when needed.
• Your code must set the variable errno properly.
• For that, you are allowed to call the extern ___error or errno_location

## Bonus part
You can rewrite these functions in assembly. The linked list functions will use the follow-
ing structure:
```
typedef struct s_list
{
void *data;
struct s_list *next;
} t_list;
```

• ft_atoi_base (see Annex V.1)
• ft_list_push_front (see Annex V.2)
• ft_list_size (see Annex V.3)
• ft_list_sort (see Annex V.4)
• ft_list_remove_if (see Annex V.5)

## why the no pie?
The compilation flag -no-pie disables Position Independent Executable (PIE) generation. By default, modern compilers produce PIE binaries, which can be loaded at random memory addresses for security (ASLR).

If you use -no-pie, the binary is not position-independent, meaning its code and data are loaded at fixed addresses. This can make certain assembly code easier to write, especially when using absolute addresses, but it reduces security and is not allowed in many coding standards (like 42's libasm) to ensure your code works with modern, secure practices.

