#include "mm.h"
#include "sbi.h"
#include "defs.h"
#include "proc.h"
#include "string.h"
#include "printk.h"
#include "stddef.h"
#include "stdint.h"
#include "printk.h"



#define SYS_WRITE   64
#define SYS_GETPID  172
#define SYS_CLONE   220

uint64_t sys_write(unsigned int fd, const char* buf, uint64_t len);
uint64_t sys_read(unsigned int fd, const char* buf, uint64_t len);

uint64_t do_fork(struct pt_regs *regs);

uint64_t sys_getpid();
