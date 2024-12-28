#include "string.h"
#include "stdint.h"

void *memset(void *dest, int c, uint64_t n) {
    char *s = (char *)dest;
    for (uint64_t i = 0; i < n; ++i) {
        s[i] = c;
    }
    return dest;
}

void *memcpy(void *dest, const void *src, uint64_t n) {
    const uint8_t *source = (const uint8_t *)src;
    uint8_t *target = (uint8_t *)dest;
    for (uint64_t i = 0; i < n; i++) {
        target[i] = source[i];
    }
    return dest;
}

int memcmp(const void *str1, const void *str2, uint64_t n) {
    unsigned char *p1 = (unsigned char *)str1;
    unsigned char *p2 = (unsigned char *)str2;
    
    for (uint64_t i = 0; i < n; i++) {
        if (p1[i] != p2[i]) {
            return p1[i] - p2[i];
        }
    }
    return 0;
}

int strlen(const char *str) {
    int len = 0;
    while (*str++)
        len++;
    return len;
}