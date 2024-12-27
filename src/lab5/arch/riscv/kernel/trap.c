#include "stdint.h"
#include "printk.h"
#include "clock.h"
#include "defs.h"
#include "../include/proc.h"
#include <stdint.h>
#include "syscall.h"

#define MAX(a, b) (((a) > (b)) ? (a) : (b))
#define MIN(a, b) (((a) < (b)) ? (a) : (b))
extern char _sramdisk[];
extern struct task_struct *current;
// extern struct vm_area_struct *find_vma(struct mm_struct *mm, uint64_t addr);
extern void create_mapping(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t sz, uint64_t perm);
extern uint64_t sys_write(unsigned int fd, const char* buf, size_t count);
extern uint64_t do_fork(struct pt_regs *regs);
extern uint64_t sys_getpid();
void do_page_fault(struct pt_regs *regs, uint64_t scause);

void trap_handler(uint64_t scause, uint64_t sepc, struct pt_regs *regs) {

    Log("[S] the scause is %lx\n", scause);
    if (scause & (0x8000000000000000)) {
        if (scause == 0x8000000000000005) {
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
        if (scause == 0x8) {
            // printk("[S] is ecall from U-mode\n");
            if (regs->a7 == SYS_GETPID){
                regs->a0 = sys_getpid();
                // printk("return of sys_getpid: %lx\n", regs->a0);
                regs->sepc += 4;
            } else if (regs->a7 == SYS_WRITE){
                regs->a0 = sys_write((uint64_t)regs->a0, (char*)regs->a1, (uint64_t)regs->a2);
                // printk("return of sys_write: %lx\n", regs->a0);
                regs->sepc += 4;
            } else if (regs->a7 == SYS_CLONE){
                regs->a0 = do_fork(regs);
                regs->sepc += 4;
            } else {
                Err("Unimplemented Syscall!\n");
            }
        } else if (scause == 0xc){
            // Err("Unhandled Exception, scause=%d", myscause);
            do_page_fault(regs, scause);
        } else if (scause == 0xd){
            // Err("Unhandled Exception, scause=%d", myscause);
            do_page_fault(regs, scause);
        } else if (scause == 0xf){
            // Err("Unhandled Exception, scause=%d", myscause);
            do_page_fault(regs, scause);
        } else {
            Err("Other Unhandled Exception, scause=%d", scause);
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

void do_page_fault(struct pt_regs *regs, uint64_t scause) {
    uint64_t stval = csr_read(stval);
    struct vm_area_struct* tmp_vma = find_vma(&(current->mm), stval);
    if (tmp_vma == NULL){
        Err("Unexpected virtual address: %lx\n", stval);
    } else {
        if (regs->a0 == 0xc && !(tmp_vma->vm_flags & VM_EXEC)){
            Err("VMA doesn't support EXEC\n");
        }else {
            Log("[pid = %d, PC = %lx], valid page fault at '%lx' with scause %lx\n", current->pid, regs->sepc, stval, scause);
            if (tmp_vma->vm_flags & VM_ANON){
                uint64_t *tmp_page = alloc_page();
                memset(tmp_page, 0, PGSIZE);
                // for (uint64_t i = 0; i < PGSIZE; i++)   *((char*)tmp_page + i) = 0; 
                create_mapping(current->pgd, PGROUNDDOWN(stval), (uint64_t)tmp_page - PA2VA_OFFSET, PGSIZE, 0x17);
            } else {

                uint64_t *paddr = alloc_page();
                memset(paddr, 0, PGSIZE);

                uint64_t VUP = PGROUNDUP(stval);
                uint64_t VDOWN = PGROUNDDOWN(stval);
                uint64_t badvaddr = stval;
                struct vm_area_struct *vma = tmp_vma;
                void *page = paddr;
                uint64_t page_start;
                uint64_t file_start;

                uint64_t map_start = MAX(vma->vm_start, PGROUNDDOWN(badvaddr));
                uint64_t map_end = MIN(vma->vm_start + vma->vm_filesz, PGROUNDDOWN(badvaddr)+PGSIZE);
                if (map_start < map_end) {
                    page_start = map_start - PGROUNDDOWN(badvaddr);
                    file_start = vma->vm_pgoff + map_start - vma->vm_start;
                    memcpy(page + page_start, _sramdisk + file_start, map_end - map_start);
                    create_mapping(current->pgd, PGROUNDDOWN(badvaddr), (uint64_t)(page - PA2VA_OFFSET), PGSIZE, 0x1f);
                } else {
                    if (vma->vm_end >= PGROUNDDOWN(stval))
                        create_mapping(current->pgd, PGROUNDDOWN(badvaddr), (uint64_t)(page - PA2VA_OFFSET), PGSIZE, 0x1f);
                    else 
                        Err("absolute wrong addr");
                }

                // uint64_t VSTART = tmp_vma->vm_start;
                // uint64_t VEND = tmp_vma->vm_end;
                // uint64_t VUP = PGROUNDUP(stval);
                // uint64_t VDOWN = PGROUNDDOWN(stval);
                // if (VSTART < VDOWN){
                //     if (VEND < VDOWN){
                //         Err("wrong\n");
                //         // alloc PGSIZE and give zero
                //         // for(uint64_t i = 0; i < PGSIZE; i++)    *((char*)paddr + i) = 0;
                //         // create_mapping(current->pgd, VDOWN, (uint64_t)paddr - PA2VA_OFFSET, PGSIZE, 0x1f);
                //     } else if (VEND >= VUP){
                //         // alloc PGSIZE
                //         uint64_t *addr = (uint64_t*)(_sramdisk + tmp_vma->vm_pgoff+(VDOWN-VSTART));
                //         for(uint64_t i = 0; i < PGSIZE; i++)    *((char*)paddr + i) = *((char*)addr + i);
                //         create_mapping(current->pgd, VDOWN, (uint64_t)paddr - PA2VA_OFFSET, PGSIZE, 0x1f);
                //     } else {
                //         // alloc PGSIZE but clear the > memsize part
                //         uint64_t *addr = (uint64_t*)(_sramdisk + tmp_vma->vm_pgoff+(VDOWN-VSTART));
                //         uint64_t size = VEND - VDOWN;
                //         for(uint64_t i = 0; i < PGSIZE; i++)    *((char*)paddr + i) = 0;
                //         for(uint64_t i = 0; i < size; i++)  *((char*)paddr + i) = *((char*)addr + i);
                //         create_mapping(current->pgd, VDOWN, (uint64_t)paddr - PA2VA_OFFSET, size, 0x1f);
                //     }
                // } else if (VSTART >= VUP) {
                //     Err("wrong addr with high vstart!\n");
                // } else {
                //     if (VEND < VUP) {
                //         // alloc PGSIZE but start from offset and clear the > memsize part
                //         uint64_t *addr = (uint64_t*)(_sramdisk + tmp_vma->vm_pgoff);
                //         uint64_t offset = VSTART - VDOWN;
                //         uint64_t size = VEND - VSTART;
                //         for(uint64_t i = 0; i < PGSIZE; i++)    *((char*)paddr + i) = 0;
                //         for(uint64_t i = 0; i < size; i++)  *((char*)paddr + i + offset) = *((char*)addr + i);
                //         create_mapping(current->pgd, VDOWN, (uint64_t)paddr - PA2VA_OFFSET, VEND - VDOWN, 0x1f);  
                //     } else {
                //         //alloc PGSIZE but start from offset
                //         uint64_t *addr = (uint64_t*)(_sramdisk + tmp_vma->vm_pgoff);
                //         uint64_t offset = VSTART - VDOWN;
                //         for(uint64_t i = 0; i < PGSIZE; i++)    *((char*)paddr + i) = 0;
                //         for(uint64_t i = 0; i < PGSIZE; i++)  *((char*)paddr + i + offset) = *((char*)addr + i);
                //         create_mapping(current->pgd, VDOWN, (uint64_t)paddr - PA2VA_OFFSET, PGSIZE, 0x1f);                        
                //     }
                // }
            }
            asm volatile ("sfence.vma zero, zero");
        }
    }

    
}