// #include <stdio.h>


// int main() {
//     size_t len = ft_strlen("Hello, World!");
//     printf("Length: %zu\n", len);
// }

#include <stdio.h>
extern size_t ft_strlen(const char *s);

int main() {
    printf("%zu\n", ft_strlen("hello"));
    return 0;
}