#include "../include/proc.h"


extern uint64_t swapper_pg_dir[];
extern char _sramdisk[];
extern char _eramdisk[];
extern void __dummy();
extern void __switch_to(struct task_struct *prev, struct task_struct *next);
extern void create_mapping(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t sz, uint64_t perm);

struct task_struct *idle;           // idle process
struct task_struct *current;        // 指向当前运行线程的 task_struct
struct task_struct *task[NR_TASKS]; // 线程数组，所有的线程都保存在此

void load_program(struct task_struct *task) {
    Elf64_Ehdr *ehdr = (Elf64_Ehdr *)_sramdisk;
    Elf64_Phdr *phdrs = (Elf64_Phdr *)(_sramdisk + ehdr->e_phoff);
    for (int i = 0; i < ehdr->e_phnum; ++i) {
        Elf64_Phdr *phdr = phdrs + i;
        if (phdr->p_type == PT_LOAD) {
            uint64_t page_num = (phdr->p_memsz + phdr->p_offset + PGSIZE - 1) / PGSIZE;
            // printk("here pagenum %lx\n", page_num);
            uint64_t *paddr = alloc_pages(page_num);
            uint64_t *addr = (uint64_t*)(_sramdisk + phdr->p_offset);
            uint64_t phy_offset = (uint64_t)addr & (PGSIZE - 1);
            for(uint64_t i = 0; i < phdr->p_memsz; i++){
                *((char*)paddr + i + phy_offset) = *((char*)addr + i);
            }
            for(uint64_t i = phdr->p_filesz; i < phdr->p_memsz; i++){
                *((char*)paddr + i + phy_offset) = 0;
            }
            create_mapping(task->pgd, phdr->p_vaddr - phy_offset, (uint64_t)paddr - PA2VA_OFFSET, phdr->p_memsz, 0x1f);
        }
    }
    task->thread.sepc = ehdr->e_entry;
}

void task_init() {
    srand(2024);

    idle = kalloc();
    idle->state = TASK_RUNNING;
    idle->counter = 0;
    idle->priority = 0;
    idle->pid = 0;

    current = idle;
    task[0] = idle;

    // 1. 调用 kalloc() 为 idle 分配一个物理页
    // 2. 设置 state 为 TASK_RUNNING;
    // 3. 由于 idle 不参与调度，可以将其 counter / priority 设置为 0
    // 4. 设置 idle 的 pid 为 0
    // 5. 将 current 和 task[0] 指向 idle


    for (int i = 1; i < NR_TASKS; i++){
        task[i] = kalloc();
        task[i]->state = TASK_RUNNING;
        task[i]->pid = i;
        task[i]->counter = 0;
        task[i]->priority = (rand() % (PRIORITY_MAX - PRIORITY_MIN + 1)) + PRIORITY_MIN;
        task[i]->thread.sp = (uint64_t)((uint64_t)task[i] + PGSIZE);
        task[i]->thread.ra = (uint64_t)(__dummy);
        task[i]->thread.sepc = USER_START;
        task[i]->thread.sstatus = 1 << 18 | 1 << 5;
        task[i]->thread.sscratch = USER_END;
        task[i]->pgd = alloc_page();
        // memcpy(task[i]->pgd, swapper_pg_dir, sizeof(swapper_pg_dir));
        uint64_t *a = task[i]->pgd;
        for(uint64_t i = 0; i < 512;i++){
            a[i] = swapper_pg_dir[i];
            // printk("i is %lu, swapper is %lx\n", i, swapper_pg_dir[i]);
        }

        // load_program(task[i]);
        uint64_t bin_size = (uint64_t)_eramdisk - (uint64_t)_sramdisk;
        uint64_t page_num = (bin_size + PGSIZE - 1)/PGSIZE;

        uint64_t *addr = alloc_pages(page_num);
        char *phy_addr = (char*)addr;
        // memcpy(addr, (uint64_t*)_sramdisk, bin_size);
        // printk("binsize: %lx, pagenum: %lu\n", bin_size, page_num);
        for(uint64_t i = 0; i < bin_size; i++){
            phy_addr[i] = _sramdisk[i];
        }
        // printk("%lx\n", *((uint32_t*)phy_addr));
        // printk("%lx\n", *((uint32_t*)phy_addr + 1));
        create_mapping(task[i]->pgd, USER_START, (uint64_t)addr - PA2VA_OFFSET, bin_size, 0x1f);
        uint64_t *user_stack = alloc_page();
        create_mapping(task[i]->pgd, USER_END - PGSIZE, (uint64_t)user_stack - PA2VA_OFFSET, PGSIZE, 0x1f);

        printk("after task[%lu] mapping\n", i);
    }

    // 1. 参考 idle 的设置，为 task[1] ~ task[NR_TASKS - 1] 进行初始化
    // 2. 其中每个线程的 state 为 TASK_RUNNING, 此外，counter 和 priority 进行如下赋值：
    //     - counter  = 0;
    //     - priority = rand() 产生的随机数（控制范围在 [PRIORITY_MIN, PRIORITY_MAX] 之间）
    // 3. 为 task[1] ~ task[NR_TASKS - 1] 设置 thread_struct 中的 ra 和 sp
    //     - ra 设置为 __dummy（见 4.2.2）的地址
    //     - sp 设置为该线程申请的物理页的高地址


    printk("...task_init done!\n");
}

#if TEST_SCHED
#define MAX_OUTPUT ((NR_TASKS - 1) * 10)
char tasks_output[MAX_OUTPUT];
int tasks_output_index = 0;
char expected_output[] = "2222222222111111133334222222222211111113";
#include "sbi.h"
#endif

void dummy() {
    // printk("in dummy\n");
    uint64_t MOD = 1000000007;
    uint64_t auto_inc_local_var = 0;
    int last_counter = -1;
    while (1) {
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0) {
            if (current->counter == 1) {
                --(current->counter);   // forced the counter to be zero if this thread is going to be scheduled
            }                           // in case that the new counter is also 1, leading the information not printed.
            last_counter = current->counter;
            auto_inc_local_var = (auto_inc_local_var + 1) % MOD;
            printk("[PID = %d] is running. auto_inc_local_var = %d\n", current->pid, auto_inc_local_var);
            #if TEST_SCHED
            tasks_output[tasks_output_index++] = current->pid + '0';
            if (tasks_output_index == MAX_OUTPUT) {
                for (int i = 0; i < MAX_OUTPUT; ++i) {
                    if (tasks_output[i] != expected_output[i]) {
                        printk("\033[31mTest failed!\033[0m\n");
                        printk("\033[31m    Expected: %s\033[0m\n", expected_output);
                        printk("\033[31m    Got:      %s\033[0m\n", tasks_output);
                        sbi_system_reset(SBI_SRST_RESET_TYPE_SHUTDOWN, SBI_SRST_RESET_REASON_NONE);
                    }
                }
                printk("\033[32mTest passed!\033[0m\n");
                printk("\033[32m    Output: %s\033[0m\n", expected_output);
                sbi_system_reset(SBI_SRST_RESET_TYPE_SHUTDOWN, SBI_SRST_RESET_REASON_NONE);
            }
            #endif
        }
    }
}

void switch_to(struct task_struct *next) {
    // printk("in switch_to\n");
    if(current->pid != next->pid){
        printk(PURPLE "switch to [pid = %d, priority = %d, priority = %d]\n" CLEAR, next->pid, next->priority, next->counter);
        struct task_struct *tmp = current;
        current = next;
        __switch_to(tmp, next);
    }
        
    return;
}

void do_timer() {
    // printk("in do_timer\n");
    // printk("in do_timer, current pid is %ld, current counter is %ld\n", current->pid, current->counter);

    if(current->pid == 0 || current->counter == 0)  schedule();
    else {
        current->counter -= 1;
        if(current->counter > 0)    return;
        else    schedule();
    }
    return;
    // 1. 如果当前线程是 idle 线程或当前线程时间片耗尽则直接进行调度
    // 2. 否则对当前线程的运行剩余时间减 1，若剩余时间仍然大于 0 则直接返回，否则进行调度
}

void schedule() {
    // printk("in schedule\n");

    int i = NR_TASKS;
    int max_counter = -1, chosen_p;
    struct task_struct *p = task[NR_TASKS];
    
    while(--i){
        // if(*--p == NULL)    continue;
        p = task[i];
        if(!p) continue;
        // printk("p pid is %ld, p counter is %ld\n", p->pid, p->counter);
        int pct = p->counter;
        if(pct > max_counter){
            // printk("%ld\n", pct);
            max_counter = p->counter;
            chosen_p = p->pid;
        }
    }
    // printk("maxcounter is %ld\n", max_counter);
    if(max_counter <= 0) {
        i = NR_TASKS;
        p = task[NR_TASKS];
        while(--i){
            // if(*--p == NULL)   continue;
            p = task[i];
            if(!p)  continue;
            p->counter = p->priority;
            printk(GREEN "SET [PID = %ld PRIORITY = %ld COUNTER = %ld]\n" CLEAR, p->pid, p->priority, p->counter);
        }
        schedule();
    }
    switch_to(task[chosen_p]);
    return;
}