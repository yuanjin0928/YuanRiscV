`define     PC_DEFAULT  32'b0    
`define     PC_WIDTH    32 

// macros for op code
`define     OP_LUI     7'b011_0111
`define     OP_AUIPC   7'b001_0111
`define     OP_JAL     7'b110_1111
`define     OP_JALR    7'b110_0111
`define     OP_BRANCH  7'b110_0011
`define     OP_LOAD    7'b000_0011
`define     OP_STORE   7'b010_0011
`define     OP_ALU_I   7'b001_0011 
`define     OP_ALU_R   7'b011_0011
`define     OP_CSR     7'b111_0011

// macros for pc source
`define     PC_NEXT_SRC_SEL_WIDTH    $clog2(`PC_NEXT_SRC_LAST)   
`define     PC_NEXT_SRC_INC          0
`define     PC_NEXT_SRC_JAL          1
`define     PC_NEXT_SRC_JALR         2
`define     PC_NEXT_SRC_BRANCH       3
`define     PC_NEXT_SRC_LAST         4

// macros for branch type
`define     BRANCH_SEL_WIDTH   $clog2(`BRANCH_LAST)
`define     BRANCH_BEQ          0
`define     BRANCH_BNE          1
`define     BRANCH_BLT          2
`define     BRANCH_BGE          3
`define     BRANCH_BLTU         4
`define     BRANCH_BGEU         5
`define     BRANCH_LAST         6

// macros for data source to be written into register file
`define     REG_DATA_SRC_SEL_WIDTH  $clog2(`REG_DATA_SRC_LAST)
`define     REG_DATA_SRC_LUI        0
`define     REG_DATA_SRC_AUIPC      1
`define     REG_DATA_SRC_JAL_JALR   2
`define     REG_DATA_SRC_LOAD       3
`define     REG_DATA_SRC_ALU        4
`define     REG_DATA_SRC_CSR        5
`define     REG_DATA_SRC_LAST       6        

// macros for data 2 source of ALU
`define     ALUT_SRC2_WIDTH     $clog2(`ALU_SRC2_LAST)
`define     ALU_SRC2_REG        0
`define     ALU_SRC2_IMM        1
`define     ALU_SRC2_LAST       2

// macros for ALU operation types
`define     ALU_OP_WIDTH    $clog2(`ALU_OP_LAST)
`define     ALU_OP_BRANCH   0
`define     ALU_OP_MEM      1
`define     ALU_OP_REG      2
`define     ALU_OP_LAST     3

// macros for ALU operations
`define     ALU_CTRL_WIDTH  $clog2(`ALU_CTRL_LAST)
`define     ALU_ADD         0
`define     ALU_SUB         1
`define     ALU_SLL         2
`define     ALU_SLT         3
`define     ALU_SLTU        4
`define     ALU_XOR         5
`define     ALU_SRL         6
`define     ALU_SRA         7
`define     ALU_OR          8
`define     ALU_AND         9
`define     ALU_MUL         10   
`define     ALU_MULH        11 
`define     ALU_MULHSU      12 
`define     ALU_MULHU       13   
`define     ALU_DIV         14
`define     ALU_DIVU        15
`define     ALU_REM         16
`define     ALU_REMU        17
`define     ALU_CTRL_LAST   18  
         