// #include <stdio.h>


// int main() {
//     size_t len = ft_strlen("Hello, World!");
//     printf("Length: %zu\n", len);
// }

#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>


#include "libasm/libasm.h"
extern size_t ft_strlen(const char *s);

int main() {
    // printf("hello is %zu lang\n", ft_strlen("hello"));
    // printf("empty string is %zu chars\n", ft_strlen(""));
    // printf("%zu\n", ft_strlen(NULL));

    int fd = open("text.txt", O_RDONLY);
    if (fd == -1) {
        perror("Error opening file");
        return 1;
    }
    char buffer[100];
    ssize_t bytesRead = ft_read(fd, buffer, 4);
    if (bytesRead == -1) {
        perror("Error reading file");
        close(fd);
        return 1;
    }
    printf("Bytes read: %zd\n", bytesRead);
    write(1, buffer, bytesRead); // Write to standard output
    write(1, "\n", 1); // Newline for clarity
    close(fd);

    char *src = "Hello, World!";
    char dest[5];
    ft_strcpy(dest, src);
    printf("Copied string: %s\n", dest);

    return 0;
}