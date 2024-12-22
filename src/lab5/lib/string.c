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
