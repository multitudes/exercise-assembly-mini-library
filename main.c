#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

#include "libasm/libasm.h"

int main() {
    printf("----- MY_STRLEN -----\n");

    const char *testStr = "Hello, World!";
    size_t len = strlen(testStr);
    printf("Length of \"%s\" is %zu\n", testStr, len);
    len = strlen("");
    printf("Length of empty string is %zu\n", len);

    printf("----- MY_READ -----\n");
    int fd = open("text.txt", O_RDONLY);
    if (fd == -1) {
        perror("Error opening file");
        return 1;
    }
    char buffer[100];
    ssize_t bytesRead = read(fd, buffer, 4);
    if (bytesRead == -1) {
        perror("Error reading file");
        close(fd);
        return 1;
    }
    printf("Bytes read: %zd\n", bytesRead);
    printf("----- MY_WRITE -----\n");

    write(1, buffer, bytesRead); // Write to standard output
    write(1, "\n", 1); 
    close(fd);

    printf("----- MY_STRCPY -----\n");
    char *src = "Hello, World!";
    char dest[5];
    strcpy(dest, src);
    printf("Copied string: %s\n", dest);

    printf("----- MY_STRCMP -----\n");
    char *s1 = "abcde";
    char *s2 = "abcdf";
    int cmpResult = strcmp(s1, s2);
    if (cmpResult < 0) {
        printf("\"%s\" is less than \"%s\"\n", s1, s2);
    } else if (cmpResult > 0) {
        printf("\"%s\" is greater than \"%s\"\n", s1, s2);
    } else {
        printf("\"%s\" is equal to \"%s\"\n", s1, s2);
    }
    // int fail = strcmp(NULL, "NULL");
    int fail = strcmp(NULL, NULL);
    printf("fail is %d\n", fail);

    printf("----- MY_STRDUP -----\n");
    char *res;
    res = strdup("Hello, World!");
    printf("Duplicated string: %s\n", res);
    free(res);
    // res = strdup(NULL);
    // printf("Duplicated NULL string: %s\n", res);
  
    res = strdup("Welcome to 42 Berlin !!!");
    printf("Duplicated string: %s\n", res);
    free(res);
    // res = strdup(NULL);
    // printf("Duplicated NULL string: %s\n", res);
    // free(res);


    return 0;
}