#include "stdint.h"
#include "printk.h"
#include "string.h"
#include "defs.h"
#include "mm.h"

uint64_t early_pgtbl[512] __attribute__((__aligned__(0x1000)));

void create_mapping(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t sz, uint64_t perm);

void setup_vm() {
    /* 
     * 1. 由于是进行 1GiB 的映射，这里不需要使用多级页表 
     * 2. 将 va 的 64bit 作为如下划分： | high bit | 9 bit | 30 bit |
     *     high bit 可以忽略
     *     中间 9 bit 作为 early_pgtbl 的 index
     *     低 30 bit 作为页内偏移，这里注意到 30 = 9 + 9 + 12，即我们只使用根页表，根页表的每个 entry 都对应 1GiB 的区域
     * 3. Page Table Entry 的权限 V | R | W | X 位设置为 1
    **/

    uint64_t spa = PHY_START;
    uint64_t sva = VM_START;
    memset(early_pgtbl, 0, sizeof(early_pgtbl));
    printk("in setup vm\n");

    uint64_t addr, vaddr, index, test;
    addr = PHY_START;
    vaddr = addr;
    index = (vaddr >> 30) & 0x1FF;
    early_pgtbl[index] = (((addr >> 30) & 0x1ff) << 28) | PTE_V | PTE_R | PTE_W | PTE_X;
    vaddr = addr + PA2VA_OFFSET;
    index = (vaddr >> 30) & 0x1FF;
    early_pgtbl[index] = (((addr >> 30) & 0x1ff) << 28) | PTE_V | PTE_R | PTE_W | PTE_X; 

    for(uint64_t i = 0; i < 512; i++){
        if(early_pgtbl[i])
            printk("index: %u, pte: %llx, pte: %llu\n", i, early_pgtbl[i], early_pgtbl[i]);
    }
    return;
}

uint64_t swapper_pg_dir[512] __attribute__((__aligned__(0x1000)));
extern char _stext[], _etext[], _srodata[], _erodata[], _sdata[], _ebss[];
uint64_t phy_swapper_pg_dir;

void setup_vm_final() {
    memset(swapper_pg_dir, 0x0, PGSIZE);

    // No OpenSBI mapping required
    uint64_t stext = (uint64_t)_stext - PA2VA_OFFSET;
    uint64_t etext = (uint64_t)_etext - PA2VA_OFFSET;
    uint64_t srodata = (uint64_t)_srodata - PA2VA_OFFSET;
    uint64_t erodata = (uint64_t)_erodata - PA2VA_OFFSET;
    uint64_t sdata = (uint64_t)_sdata - PA2VA_OFFSET;
    uint64_t ebss = (uint64_t)_ebss - PA2VA_OFFSET;
    // printk("st: %lx\net: %lx\nsrod: %lx\nerod: %lx\nsd: %lx\neb: %lx\n", stext, etext, srodata, erodata, sdata, ebss);

    uint64_t text_size = etext - stext;
    uint64_t rodata_size = erodata - srodata;
    uint64_t remain_size = stext + PHY_SIZE - sdata;

    // mapping kernel text X|-|R|V
    phy_swapper_pg_dir = (uint64_t)swapper_pg_dir - PA2VA_OFFSET;

    create_mapping(swapper_pg_dir, (uint64_t)_stext, stext, text_size, 0xb);
    printk("after first mapping\n");

    // mapping kernel rodata -|-|R|V
    create_mapping(swapper_pg_dir, (uint64_t)_srodata, srodata, rodata_size, 0x3);
    printk("after second mapping\n");
    // mapping other memory -|W|R|V
    create_mapping(swapper_pg_dir, (uint64_t)_sdata, sdata, remain_size, 0x7);
    printk("after third mapping\n");

    // set satp with swapper_pg_dir
    asm volatile(".extern phy_swapper_pg_dir");
    asm volatile("la a1, phy_swapper_pg_dir");
    asm volatile("ld a0, 0(a1)");
    asm volatile("srli a0, a0, 12");
    asm volatile("li a1, 0x8000000000000000");
    asm volatile("or a0, a0, a1");
    asm volatile("csrw satp, a0");

    // flush TLB
    asm volatile("sfence.vma zero, zero");

    // // flush icache
    // asm volatile("fence.i");
    return;
}

/* 创建多级页表映射关系 */
/* 不要修改该接口的参数和返回值 */
void create_mapping(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t sz, uint64_t perm) {
    /*
     * pgtbl 为根页表的基地址
     * va, pa 为需要映射的虚拟地址、物理地址
     * sz 为映射的大小，单位为字节
     * perm 为映射的权限（即页表项的低 8 位）
     * 
     * 创建多级页表的时候可以使用 kalloc() 来获取一页作为页表目录
     * 可以使用 V bit 来判断页表项是否存在
    **/
    uint16_t vpn2, vpn1, vpn0;
    uint64_t addr, vaddr;
    uint64_t pte;
    uint64_t *tmptbl, *p_pte;
    for(uint64_t addr_offset = 0; addr_offset < sz; addr_offset += PGSIZE){
        addr = pa + addr_offset;
        vaddr = va + addr_offset;
        // printk("addr: %lx, vaddr: %lx\n", addr, vaddr);
        tmptbl = pgtbl;
        vpn2 = (vaddr >> 30) & 0x1ff;
        vpn1 = (vaddr >> 21) & 0x1ff;
        vpn0 = (vaddr >> 12) & 0x1ff;
        // printk("vpn2: %d, vpn1: %d, vpn0: %d\n", vpn2, vpn1, vpn0);
        p_pte = tmptbl + vpn2;
        pte = tmptbl[vpn2];
        // printk("tpmtbl: %lx, p_pte: %lx, pte: %lx\n", tmptbl, p_pte, pte);
        if(pte & 0x1){
            tmptbl = (uint64_t*)(((pte >> 10) << 12) + PA2VA_OFFSET);
        } else {
            tmptbl = (uint64_t*)alloc_page();
            // printk("kalloc: %lx\n", tmptbl);
            uint64_t* phy_tmptbl = (uint64_t*)((uint64_t)tmptbl - PA2VA_OFFSET);
            *p_pte = (((uint64_t)phy_tmptbl >> 12) << 10) | 0x1;
            // printk("new pte: %lx\n", *p_pte);
        }
        p_pte = tmptbl + vpn1;
        pte = tmptbl[vpn1];
        // printk("tpmtbl: %lx, p_pte: %lx, pte: %lx\n", tmptbl, p_pte, pte);
        if(pte & 0x1){
            tmptbl = (uint64_t*)(((pte >> 10) << 12) + PA2VA_OFFSET);
        } else {
            tmptbl = (uint64_t*)alloc_page();
            // printk("kalloc: %lx\n", tmptbl);
            uint64_t* phy_tmptbl = (uint64_t*)((uint64_t)tmptbl - PA2VA_OFFSET);
            *p_pte = (((uint64_t)phy_tmptbl >> 12) << 10) | 0x1;
            // printk("new pte: %lx\n", *p_pte);
        }
        p_pte = tmptbl + vpn0;
        *p_pte = ((addr >> 12) << 10) | perm;
        // printk("tmptbl: %lx, p_pte: %lx, pte: %lx\n", tmptbl, p_pte, *p_pte);
    }
    
}

