ORG 8100H

INIT:
    SETB P1.5           

 
MAIN_LOOP:
    
	
	MOV DPTR, #9000H
	MOVX A, @DPTR
	MOV R1,A
	MOV P1.5, R1.0
	INC DPL
	
	
	
	JB P1.5, MAIN_LOOP
SJMP MAIN_LOOP
	
BLINK:
    
    CLR P1.0
    CLR P1.1
    CLR P1.2
    CLR P1.3
    CLR P1.4
    ACALL DELAY1        ; Fast Delay

    ; 2. Turn ALL ON
    SETB P1.0
    SETB P1.1
    SETB P1.2
    SETB P1.3
    SETB P1.4
    ACALL DELAY1        ; Fast Delay

    
    SETB P1.5           ; Ensure Input mode is still set
    JNB P1.5, MAIN_LOOP ; If P1.5 is Low (Open), go back to Main
    SJMP BLINK          ; Else, keep blinking


DELAY:                  ; ~1.0 Second Delay
    MOV R5, #10         
D1: MOV R6, #200        
D2: MOV R7, #250        
D3: DJNZ R7, D3
    DJNZ R6, D2
    DJNZ R5, D1
    RET

DELAY1:                 ; ~0.1 Second Delay (Faster Blink)
    MOV R0, #1          
L1: MOV R1, #200        
L2: MOV R2, #250        
L3: DJNZ R2, L3
    DJNZ R1, L2
    DJNZ R0, L1
    RET
    
    END