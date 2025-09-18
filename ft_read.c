#include <unistd.h>

ssize_t ft_read(int fd, void *buf, size_t count) {
    ssize_t res = read(fd, buf, count);
    return res;
}