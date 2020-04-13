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
}
