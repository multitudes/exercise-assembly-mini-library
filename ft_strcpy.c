#include <string.h>

char *strcpy(char *dest, const char *src) {
    char *orig_dest = dest;
    while ((*dest++ = *src++) != '\0');
    return orig_dest;
}