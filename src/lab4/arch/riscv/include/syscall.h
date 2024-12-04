#include "stddef.h"
#include "stdint.h"
#include "proc.h"
#include "sbi.h"

#define SYS_WRITE   64
#define SYS_GETPID  172

uint64_t sys_write(unsigned int fd, const char* buf, size_t count);

uint64_t sys_getpid();
