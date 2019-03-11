
typedef unsigned char byte;
typedef unsigned short ushort;

struct seg_desc
{
    // Nibble LO (32 bit)
    ushort limit_15_0;
    ushort base_15_0;

    // Nibble HL
    byte base_23_16:8;
    byte type:4;
    byte S:1;
    byte DPL:2;
    byte P:1;
    byte limit_19_16:4;
    byte AVL:1;
    byte L:1;
    byte D_B:1;
    byte G:1;
    byte base_31_24:8;
};