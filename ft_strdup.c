#include <stdlib.h>

char *ft_strdup(const char *s) {
    size_t len = 0;
    while (s[len++]);
    char *dup = malloc(len);
    if (!dup)
        return NULL;
    for (size_t i = 0; i < len; i++)
        dup[i] = s[i];
    return dup;
}