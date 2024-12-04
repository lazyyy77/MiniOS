#include "stdint.h"
#include "printk.h"
#include "clock.h"
#include "defs.h"
#include "proc.h"
#include <stdint.h>
#include "syscall.h"

struct pt_regs{
    uint64_t ra;
    uint64_t gp;
    uint64_t tp;
    uint64_t t0;
    uint64_t t1;
    uint64_t t2;
    uint64_t s0;
    uint64_t s1;
    uint64_t a0;
    uint64_t a1;
    uint64_t a2;
    uint64_t a3;
    uint64_t a4;
    uint64_t a5;
    uint64_t a6;
    uint64_t a7;
    uint64_t s2;
    uint64_t s3;
    uint64_t s4;
    uint64_t s5;
    uint64_t s6;
    uint64_t s7;
    uint64_t s8;
    uint64_t s9;
    uint64_t s10;
    uint64_t s11;
    uint64_t t3;
    uint64_t t4;
    uint64_t t5;
    uint64_t t6;
    uint64_t sepc;
    uint64_t sstatus;
};

extern uint64_t sys_write(unsigned int fd, const char* buf, size_t count);

extern uint64_t sys_getpid();



void trap_handler(uint64_t scause, uint64_t sepc, struct pt_regs *regs) {

    uint64_t myscause;
    
    // asm volatile("csrr %0, scause" : "=r"(myscause)); 
    // myscause = csr_read(scause);
    myscause = scause;
    if (myscause & (1ull << 63)) {
        if (myscause & 0x5) {
            // printk("[S] is time interrupt\n");
            clock_set_next_event();
            do_timer();
            // uint64_t ss = csr_read(sstatus);
            // printk("sstatus is: %ld", ss);
            // csr_write(sscratch, 0x0001001001001000);
            return;
        } else {
            printk("not time interrupt\n");
            return;
        }
    } else {
        // printk("[S] not interrupt\n");
        if (myscause & 0x8) {
            // printk("[S] is ecall from U-mode\n");
            if (regs->a7 == SYS_GETPID){
                regs->a0 = sys_getpid();
                // printk("return of sys_getpid: %lx\n", regs->a0);
                regs->sepc += 4;
            } else if (regs->a7 == SYS_WRITE){
                regs->a0 = sys_write((uint64_t)regs->a0, (char*)regs->a1, (uint64_t)regs->a2);
                // printk("return of sys_write: %lx\n", regs->a0);
                regs->sepc += 4;
            }
        }
        return;
    }
    // 通过 `scause` 判断 trap 类型
    // 如果是 interrupt 判断是否是 timer interrupt
    // 如果是 timer interrupt 则打印输出相关信息，并通过 `clock_set_next_event()` 设置下一次时钟中断
    // `clock_set_next_event()` 见 4.3.4 节
    // 其他 interrupt / exception 可以直接忽略，推荐打印出来供以后调试
    return;
}