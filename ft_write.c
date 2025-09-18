#include <unistd.h>

ssize_t ft_write(int fd, const void *buf, size_t count) {
    ssize_t res = write(fd, buf, count);
    return res;
}