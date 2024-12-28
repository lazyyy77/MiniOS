#include "syscall.h"
#include "stdint.h"
#include "stddef.h"
#include "defs.h"
#include "../include/proc.h"
#include "fs.h"

extern void __ret_from_fork();
extern uint64_t swapper_pg_dir[];
extern struct task_struct *current;
extern uint64_t nr_tasks;
extern struct task_struct *task[NR_TASKS];


extern struct sbiret sbi_debug_console_write_byte(uint8_t byte);
extern void create_mapping(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t sz, uint64_t perm);


uint64_t sys_write(unsigned int fd, const char* buf, uint64_t len){
    int64_t ret;
    struct file *file = &(current->files->fd_array[fd]);
    if (file->opened == 0) {
        printk("file not opened\n");
        return ERROR_FILE_NOT_OPEN;
    } else {
        if (file->perms == FILE_WRITABLE){
            file->write(file, buf, len);
        }
    }
    return ret;
}

uint64_t sys_read(unsigned int fd, const char* buf, uint64_t len){
    int64_t ret;
    struct file *file = &(current->files->fd_array[fd]);
    if (file->opened == 0) {
        printk("file not opened\n");
        return ERROR_FILE_NOT_OPEN;
    } else {
        if ((fd == 1 || fd == 2) && file->perms == FILE_WRITABLE){
            file->write(file, buf, len);
        } else if (fd == 0 && file->perms == FILE_READABLE){
            ret = file->read(file, buf, len);
        }
    }
    return ret;
}


uint64_t sys_getpid(){
    return current->pid;
}

uint64_t do_fork(struct pt_regs *regs){
    printk("addr of reg/sp: %lx\n", regs);
    // Err("unfinished\n");
    nr_tasks++;
    printk("now nrtasks: %lu\n", nr_tasks);
    struct task_struct *_task = alloc_page();
    memcpy(_task, current, PGSIZE);
    task[nr_tasks-1] = _task;
    uint64_t *_pgd = alloc_page();
    memset(_pgd, 0, PGSIZE);
    _task->pid = nr_tasks - 1;
    _task->pgd = _pgd;
    _task->thread.ra = (uint64_t)__ret_from_fork;
    _task->mm.mmap = NULL;
    for(uint64_t i = 0; i < 512;i++){
        _pgd[i] = swapper_pg_dir[i];
    }

    struct vm_area_struct *tmp_vma = current->mm.mmap;
    while(tmp_vma != NULL){
        struct vm_area_struct *new_vma = alloc_page();
        memcpy(new_vma, tmp_vma, PGSIZE);
        new_vma->vm_next = _task->mm.mmap;
        new_vma->vm_prev = NULL;
        _task->mm.mmap = new_vma;
        //read and map
        uint64_t page_addr = new_vma->vm_start;
        for(;page_addr < new_vma->vm_end;){
            uint64_t *tmptbl = current->pgd;
            uint64_t vpn2 = (page_addr >> 30) & 0x1ff;
            uint64_t vpn1 = (page_addr >> 21) & 0x1ff;
            uint64_t vpn0 = (page_addr >> 12) & 0x1ff;
            uint64_t pte = tmptbl[vpn2];
            if ((pte & 0x1) == 0){
                page_addr = PGROUNDDOWN(page_addr + PGSIZE);       
                continue;
            }
            tmptbl = (uint64_t*)(((pte >> 10) << 12) + PA2VA_OFFSET);
            pte = tmptbl[vpn1];
            if ((pte & 0x1) == 0){
                page_addr = PGROUNDDOWN(page_addr + PGSIZE);       
                continue;
            }
            tmptbl = (uint64_t*)(((pte >> 10) << 12) + PA2VA_OFFSET);
            pte = tmptbl[vpn0];
            if ((pte & 0x1) == 0){
                page_addr = PGROUNDDOWN(page_addr + PGSIZE);       
                continue;
            }
            uint64_t *copy_addr = (uint64_t*)(((pte >> 10) << 12) + PA2VA_OFFSET);
            uint64_t *phy_addr = alloc_page();
            memset(phy_addr, 0, PGSIZE);
            memcpy(phy_addr, copy_addr, PGSIZE);
            create_mapping(_task->pgd, PGROUNDDOWN(page_addr), (uint64_t)phy_addr - PA2VA_OFFSET, PGSIZE, 0x1f);

            page_addr = PGROUNDDOWN(page_addr + PGSIZE);       
        }

        tmp_vma = tmp_vma->vm_next;
    }
    _task->thread.sp = ((uint64_t)regs & 0xfff) + (uint64_t)_task;
    struct pt_regs *child_regs = (struct pt_regs*)_task->thread.sp;
    _task->thread.sepc = _task->thread.sepc + 4;
    child_regs->sepc = _task->thread.sepc;
    _task->thread.sscratch = csr_read(sscratch);
    
    return nr_tasks;
}
