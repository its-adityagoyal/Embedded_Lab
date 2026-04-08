ORG 8100H

INIT:
    SETB P1.5           

MAIN_LOOP:
    ; --- Step 1: 00001 (LED 1 ON) ---
    SETB P1.0
    CLR P1.1
    CLR P1.2
    CLR P1.3
    CLR P1.4
    
    JB P1.5, BLINK      ; Check Sensor
    ACALL DELAY         ; Wait

    ; --- Step 2: 00010 (LED 2 ON) ---
    CLR P1.0
    SETB P1.1
    CLR P1.2
    CLR P1.3
    CLR P1.4
    
    JB P1.5, BLINK      ; Check Sensor
    ACALL DELAY

    ; --- Step 3: 00100 (LED 3 ON) ---
    CLR P1.0
    CLR P1.1
    SETB P1.2
    CLR P1.3
    CLR P1.4
    
    JB P1.5, BLINK      ; Check Sensor
    ACALL DELAY

    ; --- Step 4: 01000 (LED 4 ON) ---
    CLR P1.0
    CLR P1.1
    CLR P1.2
    SETB P1.3
    CLR P1.4
    
    JB P1.5, BLINK      ; Check Sensor
    ACALL DELAY

    ; --- Step 5: 10000 (LED 5 ON) ---
    CLR P1.0
    CLR P1.1
    CLR P1.2
    CLR P1.3
    SETB P1.4
    
    JB P1.5, BLINK      ; Check Sensor
    ACALL DELAY
            
    SJMP MAIN_LOOP      ; Repeat Sequence


BLINK:
    ; 1. Turn ALL OFF
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

    ; 3. Check Sensor to Exit
    SETB P1.5           
    JNB P1.5, MAIN_LOOP 
    SJMP BLINK          


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