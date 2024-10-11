#include "stdint.h"
#include "printk.h"
#include "clock.h"
#include "sbi.h"

// QEMU 中时钟的频率是 10MHz，也就是 1 秒钟相当于 10000000 个时钟周期
uint64_t TIMECLOCK = 10000000;

uint64_t get_cycles() {
    // 编写内联汇编，使用 rdtime 获取 time 寄存器中（也就是 mtime 寄存器）的值并返回
    uint64_t mtime = 0;
    asm volatile (
        "rdtime %[mtime]\n"
        : [mtime] "=r"(mtime)
        :
        : "memory"
    );
    return mtime;
}

void clock_set_next_event() {

    // 下一次时钟中断的时间点
    uint64_t next = get_cycles() + TIMECLOCK;
    // 使用 sbi_set_timer 来完成对下一次时钟中断的设置
    struct sbiret res;
    res = sbi_set_timer(next);
    if (res.error)
        printk("bad\n");
    return;

    // asm volatile (
    //     "li a7, 0x54494D45\n"
    //     "li a6, 0x0\n"
    //     "rdtime a0\n"
    //     "li a1, 10000000\n"
    //     "add a0, a0, a1\n"
    //     "li a1, 0\n"
    //     "li a2, 0\n"
    //     "li a3, 0\n"
    //     "li a4, 0\n"
    //     "li a5, 0\n"
    //     "ecall\n"
    //     :
    //     :
    //     : "memory"
    // );

}