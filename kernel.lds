ENTRY(_start)
SECTIONS
{

	. = 0x00400000;
    usertext : { user/?*(.text*) }
    
    . = 0x00500000;
    userrodata : { user/?*(.rodata*) }
    
    . = 0x00600000;
    userdata : { user/?*(.data) }
    userbss : { user/?*(.bss) }
    usercommon : { user/?*(COMMON) }
    . = 0x00700000;
    _userheap = .;
    userheap : { user/?(.heap) }
    
	. = 0x00100000;
	.init : { *(.init) }
	. = 0x00200000;
	.text : { *(.text) }
	. = 0x00300000;
	.data  : { *(.data*)}
	.rodata : { *(.rodata*)}
	.bss : { *(.bss*) *(COMMON)}

}
