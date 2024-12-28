#include "stdint.h"
#include "sbi.h"
#define write_csr(reg, val) ({ asm volatile ( "csrw " #reg ", %0" :: "r"(val)); })
#define read_csr(csr) ({ uint64_t __v; asm volatile("csrr %0, " #csr : "=r"(__v) : : "memory"); __v;                                \})
struct sbiret sbi_ecall(uint64_t eid, uint64_t fid,
                        uint64_t arg0, uint64_t arg1, uint64_t arg2,
                        uint64_t arg3, uint64_t arg4, uint64_t arg5) {
    struct sbiret res;
    long error;
    long value;
    asm volatile (
        "mv a7, %[eid]\n"
        "mv a6, %[fid]\n"
        "mv a0, %[arg0]\n"
        "mv a1, %[arg1]\n"
        "mv a2, %[arg2]\n"
        "mv a3, %[arg3]\n"
        "mv a4, %[arg4]\n"
        "mv a5, %[arg5]\n"
        "ecall\n"
        "mv %[error], a0\n"
        "mv %[value], a1\n"
        : [error] "=r"(error),[value] "=r"(value)
        : [eid] "r"(eid), [fid] "r"(fid), [arg0] "r"(arg0), [arg1] "r"(arg1), [arg2] "r"(arg2), [arg3] "r"(arg3), [arg4] "r"(arg4), [arg5] "r"(arg5)
        : "memory", "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7"
    );
    //顺序问题 -- 绑定依然需要顺序 -- 为什么倒序不行
    res.error = error;
    res.value = value;
    return res;
}

struct sbiret sbi_set_timer(uint64_t stime) {
    return sbi_ecall(0x54494D45, 0x0, stime, 0, 0, 0, 0, 0);
}

struct sbiret sbi_debug_console_write_byte(uint8_t byte) {
    return sbi_ecall(0x4442434E, 0x2, byte, 0, 0, 0, 0, 0);
}

struct sbiret sbi_system_reset(uint32_t reset_type, uint32_t reset_reason) {
    return sbi_ecall(0x53525354, 0x0, 0, 0, 0, 0, 0, 0);
}

struct sbiret sbi_debug_console_read(uint64_t num_bytes, uint64_t base_addr_lo, uint64_t base_addr_hi){
    return sbi_ecall(0x4442434E, 0x1, num_bytes, base_addr_lo, base_addr_hi, 0,0,0);
}