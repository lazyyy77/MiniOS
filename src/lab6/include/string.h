#ifndef __STRING_H__
#define __STRING_H__

#include "stdint.h"

void *memset(void *, int, uint64_t);

void *memcpy(void *dest, const void *src, uint64_t n);

int memcmp(const void *str1, const void *str2, uint64_t n);

int strlen(const char *str);

#endif
