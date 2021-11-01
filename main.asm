        .ORIG x3000
        
        AND R0, R0, #0; INPUT DATA
        AND R1, R1, #0; DATA LOCATION
        AND R2, R2, #0; ITERATION

INPUT   LEA R0, INPUT
        ST R0, RETVAL
        
        LEA R0, BEGIN
        PUTS
        TRAP x40
        JSR INVALC
        ST R0, BEGDT
        ; OUTPUT STRING TO TERMINAL "Enter starting memory address:"
        
INPUT2  LEA R0, INPUT2
        ST R0, RETVAL
        
        LEA R0, END
        PUTS
        TRAP x40
        JSR INVALC
        ST R0, ENDDT
        LEA R0, DOWN
        PUTS
        ; OUTPUT STRING TO TERMINAL "Enter ending memory address:"
        
        JSR ERRC
        
        LEA R0, OUTSTR1
        PUTS
        LD R0, BEGDT
        TRAP x41
        LEA R0, OUTSTR2
        PUTS
        LD R0, ENDDT
        TRAP x41
        LEA R0, OUTSTR3
        PUTS
        ;OUTPUT STRING "Memory contents BEGDT to ENDDT:"
        
        LD R0, BEGDT
        LD R1, ENDDT
        NOT R0, R0
        ADD R0, R0, #1
        ADD R2, R1, R0
        LD R1, BEGDT
        ; INITILIZE VALUES
        
LOOP    AND R0, R0, #0
        ADD R0, R1, R0
        TRAP x41
        
        LEA R0, SPACE
        PUTS
        ; BLANK SPACE
        
        LDR R0, R1, #0
        TRAP x41
        ; GET DATA AT LOCATION R1
        
        LEA R0, DOWN
        PUTS
        ; DOWNSPACE
        
        ADD R1, R1, #1
        ADD R2, R2, #-1
        BRzp LOOP
        ;ITERATION CHECK
        
STOP    HALT



BEGIN   .STRINGZ "Enter starting memory address:\n"
BEGDT   .FILL #0
END     .STRINGZ "\nEnter ending memory address:\n"
ENDDT   .FILL #0
SPACE   .STRINGZ " "
DOWN    .STRINGZ "\n"
OUTSTR1 .STRINGZ "\nMemory contents "
OUTSTR2 .STRINGZ " to "
OUTSTR3 .STRINGZ ":\n"
DTR0    .FILL #0


ERRC    LD R0, BEGDT
        LD R1, ENDDT
        NOT R1, R1
        ADD R1, R1, #1
        ADD R0, R1, R0
WRONG   BRnz RIGHT
        LEA R0, ERRMES
        PUTS
        BRnzp INPUT2
RIGHT   RET
        ; CHECK IF END ADDRESS LESS THAN BEGINNING ADDRESS
        
ERRMES  .STRINGZ "END ADDRESS LESS THAN BEGINNING ADDRESS\n\n"
RETVAL  .FILL #0

INVALC  ADD R0, R0, #0
        
VALID   BRz INVAL
        RET
INVAL   LD R7, RETVAL
        RET
        ; CHECK IF INVALID INPUT THEN RE ENTER VALUES
        .END