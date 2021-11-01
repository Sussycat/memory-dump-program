            .ORIG x5000; TRAP x41
            
            ST R0, SAVER0; INPUT DATA AND REMAINING BITS
            ST R1, SAVER1
            ST R2, SAVER2
            ST R3, SAVER3
            ST R4, SAVER4
            
            ;LD R0, TEST;    INPUT DATA AND REMAINING BITS
            
            AND R1, R1, #0; BITMASK AND LAST 4 BIT
            AND R2, R2, #0; LOOP ITERATION
            AND R3, R3, #0; STORAGE LOCATION
            AND R4, R4, #0; COMPARISION VALUE AND ADDITION VALUE
            
MASK        LEA R3, DATA
            ADD R2, R2, #4
        
MASKLOOP    ADD R2, R2, #-1
            BRn STROUT
            LD R1, BIT4
            AND R1, R1, R0
            ST R1, DTR1
            LD R1, BIT12
            AND R0, R1, R0
            LD R1, DTR1
            ; MASK BITS TO RETURN LAST 4 BITS AND REMAINING 12 BITS
            
            JSR SHIFTR
            JSR SHIFTR
            JSR SHIFTR
            JSR SHIFTR
            ; SHIFT R0 TO RIGHT BY 4 BITS
            
DATAC       LD R4, TYPEC
            NOT R4, R4
            ADD R4, R4, #1
            ADD R4, R1, R4
<10         BRzp >=10
            BRnzp INT
>=10        BRnzp CHAR
            ; CHECK DATA TYPE
        
        
INT         LD R4, INTADD
            ADD R1, R4, R1
            BRnzp STORE
            
CHAR        LD R4, CHARADD
            ADD R1, R4, R1
            BRnzp STORE
            ; CONVERT VALUE TO STR  
  
STORE       STR R1, R3, #0
            ADD R3, R3, #-1
            BRnzp MASKLOOP
            ; STORE DATA

STROUT      LEA R0, OUTTERM
            PUTS
            LEA R0, DT
            PUTS
            ;OUTPUT DATA
            
            LD R0, SAVER0
            LD R1, SAVER1
            LD R2, SAVER2
            LD R3, SAVER3
            LD R4, SAVER4 
            ; RETURN VALUES
            ;HALT
            RTI

TEST        .FILL x3F0A
SAVER0      .FILL #0
SAVER1      .FILL #0
SAVER2      .FILL #0
SAVER3      .FILL #0
SAVER4      .FILL #0
DTR1        .FILL #0
BIT12       .FILL #65520
BIT4        .FILL #15
            .FILL #0
OUTTERM     .STRINGZ "x"
DT          .FILL #0
            .FILL #0
            .FILL #0
DATA        .FILL #0
            .FILL #0
INTADD      .FILL #48
CHARADD     .FILL #55
TYPEC       .FILL #10      
  
        
SHIFTR	    ST R1, R1SAVE		; Save callee-save registers
    		ST R2, R2SAVE

    		AND R1, R1, #0		; R1 holds the intermediate result
    		AND R2, R2, #0		; R2 holds count for number of bits examined
    		ADD R2, R2, #15

NextBit		ADD R0, R0, #0		; Test MSB for 1 or 0
		    BRn MSBIS1

MSBIS0		ADD R1, R1, R1		;shift running total left
					;force LSB to 0
		    ADD R0, R0, R0		;shift original value left; check next bit
		    BR  TestDone

MSBIS1		ADD R1, R1, R1		;shift running total left
		    ADD R1, R1, #1		;force LSB to 1
		    ADD R0, R0, R0		;shift original value left; check next bit

TestDone	ADD R2, R2, #-1
		    BRP NextBit

Done		ADD R0, R1, #0		; Move result to R0
	        LD  R2, R2SAVE		; Restore callee-save registers
            LD  R1, R1SAVE
            RET			; Return to calling program

R1SAVE		.BLKW 1
R2SAVE		.BLKW 1
            .END