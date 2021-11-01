        .ORIG x4000; TRAP x40
        
        ST R1, DTR1
        ST R2, DTR2
        ST R3, DTR3
        ST R4, DTR4
        ST R7, DTR7
        AND R0, R0, #0 ; INPUT DATA
        AND R1, R1, #0 ; 1ST ITERATION CHAR LEFT
        AND R3, R3, #0 ; DATA STORAGE
        AND R4, R4, #0 ; 2ND ITERATION AND ADDER

        ADD R1, R1, #4
        
        LEA R0, INPTER
        PUTS
        ST R1, SAVER1
        ;OUTPUT "x"
        
ILOOP   JSR FULLR
        AND R0, R0, #0 
        GETC
        OUT
        BRnzp INT
        ;GET 4 CHAR AS INPUT
        
PUSH4   AND R4, R4, #0
        ADD R4, R4, #4
        ADD R3, R3, R0
        ADD R1, R1, #-1
        BRnz STORE
        
        
P4LOOP  ADD R3, R3, R3
        ADD R4, R4, #-1
        BRp P4LOOP
        ADD R1, R1, #0
        BRp ILOOP
        ; PUSH DATA 4 TIMES FORWARD

STORE   ST R3, DATA
        BRnzp STOP
        ;STORE DATA

INT     LD R2, INTLW
        ST R2, LOW
        LD R2, INTUP
        ST R2, HIGH
        LD R2, SUBINT
        ST R2, SUBNUM
        AND R2, R2, #0 ; COMPARISION VALUE AND SUBTRACTION VALUE
        JSR LCOMP
        JSR FULLR
CAP     LD R2, CAPLW
        ST R2, LOW
        LD R2, CAPUP
        ST R2, HIGH
        LD R2, SUBCAP
        ST R2, SUBNUM
        JSR LCOMP
        JSR FULLR
LOWC    LD R2, LOWLW
        ST R2, LOW
        LD R2, LOWUP
        ST R2, HIGH
        LD R2, SUBLOW
        ST R2, SUBNUM
        JSR LCOMP
        BRnzp ERROR          
        ; STORE THE LOW AND UPPER COMPARISION VALUE, THE BIT SUBTRACTION FOR EACH DATA TYPE
        
        
LCOMP   LD R2, LOW
        ;ST R0, SAVER0
        ST R7, SAVER7
        AND R7, R7, #0
        JSR COMP
        ADD R2, R2, #0
        BRn ERROR
        ; CHECK IF LESS THAN LOWER RANGE
        
UCOMP   ;AND R2, R2, #0
        ;LD R0, SAVER0
        LD R2, HIGH        
        JSR COMP
        ADD R2, R2, #0
<       BRzp >=
        BRnzp SUB
>=      LD R7, SAVER7
        RET 
        ; CHECK IF LESS THAN HIGHER RANGE
        
COMP    NOT R2, R2
        ADD R2, R2, #1
        ADD R2, R0, R2
        RET
        ; COMPARE THE INPUT VALUE TO CHECK FOR DATA TYPE
        
SUB     ADD R0, R0, #0
        AND R2, R2, #0 ; SUBTRACTION VALUE
        ADD R0, R0, #0
        LD R2, SUBNUM
        NOT R2, R2
        ADD R2, R2, #1
        ADD R0, R0, R2
        BRnzp PUSH4
        ; CONVERT STRING TO SIGHT DATA TYPE
        
FULLR   AND R2, R2, #0 ; COMPARISION VALUE AND SUBTRACTION VALUE
        AND R5, R5, #0 ; DISPLAY STORED DATA
        ST R2, LOW
        ST R2, HIGH
        ST R2, SUB
        RET
        ; RESET THE REGISTERS
        
ERROR   AND R0, R0, #0
        ST R0, DATA
        LEA R0, ERRMES
        PUTS
        BR STOP
        ; CHECK FOR INVALID INPUT
        
STOP    LD R0, DATA
        LD R1, DTR1
        LD R2, DTR2
        LD R3, DTR3
        LD R4, DTR4
        LD R7, DTR7
        RTI
        ; RESTORE DATA AND REGISTERS AND RETURN
        
INPTER  .STRINGZ "x"
ERRMES  .STRINGZ "\nINVALID INPUT.\n"
TRAPLOC .FILL x40
INTLW   .FILL #47
INTUP   .FILL #58
CAPLW   .FILL #64
CAPUP   .FILL #71
LOWLW   .FILL #96
LOWUP   .FILL #103
LOW     .FILL #0
HIGH    .FILL #0
DATA    .FILL #0
SAVER1  .FILL #0
SAVER7  .FILL #0 ; 2ND TP
SAVER0  .FILL #0 ; 
SUBINT  .FILL #48
SUBCAP  .FILL #55 
SUBLOW  .FILL #87
SUBNUM  .FILL #0
DTR1    .FILL #0
DTR2    .FILL #0
DTR3    .FILL #0
DTR4    .FILL #0
DTR7    .FILL #0

        .END