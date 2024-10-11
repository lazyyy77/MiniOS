#include "stdint.h"
#include "printk.h"
#include "clock.h"
#include "defs.h"
#include <stdint.h>

void trap_handler(uint64_t scause, uint64_t sepc) {

    // char high = (scause >> 60) & 0xf;
    // char low = scause & 0xf;
    // const char* ch = high;
    // const char* cl = low;
    // printk(ch);
    // printk(cl);
    uint64_t myscause;
    
    // asm volatile("csrr %0, scause" : "=r"(myscause)); 
    myscause = csr_read(scause);
    if (myscause & (1ull << 63)) {
        if (myscause & 0x5) {
            printk("[S] is time interrupt\n");
            clock_set_next_event();
            uint64_t ss = csr_read(sstatus);
            printk("sstatus is: %ld", ss);
            csr_write(sscratch, 0x0001001001001000);
            return;
        } else {
            printk("not time interrupt\n");
            return;
        }
    } else {
        printk("not interrupt\n");
        return;
    }
    // 通过 `scause` 判断 trap 类型
    // 如果是 interrupt 判断是否是 timer interrupt
    // 如果是 timer interrupt 则打印输出相关信息，并通过 `clock_set_next_event()` 设置下一次时钟中断
    // `clock_set_next_event()` 见 4.3.4 节
    // 其他 interrupt / exception 可以直接忽略，推荐打印出来供以后调试
    return;
}