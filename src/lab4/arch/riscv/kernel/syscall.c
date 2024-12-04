#include "syscall.h"
#include "stdint.h"
#include "stddef.h"

extern struct task_struct *current;

extern struct sbiret sbi_debug_console_write_byte(uint8_t byte);

uint64_t sys_write(unsigned int fd, const char* buf, size_t count){
    uint64_t cnt = 0;
    while (cnt < count){
        printk("%c", buf[cnt]);
        cnt++;
    }
    return cnt;
}

uint64_t sys_getpid(){
    return current->pid;
}
