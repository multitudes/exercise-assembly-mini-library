#ifndef LIBASM_H
#define LIBASM_H

size_t  strlen(const char *s);
char*   strcpy(char *dest, const char *src);
int     strcmp(const char *s1, const char *s2);
ssize_t write(int fd, const void *buf, size_t count);
ssize_t read(int fd, void *buf, size_t count);
char *  strdup(const char *s);


#endif