;-----------------------------------------------------------
; EXPERIMENT 3: PART C - Real-Time Clock & Stopwatch
; Custom Wiring: P1A0=dp, P1A1=a ... P1A7=g
; Active Low Mode Switch. Starts at 10:59:45.
;-----------------------------------------------------------

    ORG 8000H           
    LJMP MAIN           

    ORG 8100H           ; MAIN PROGRAM START
    
    ; --- ESA KIT 8255 ADDRESSES ---
    PORTA     EQU 0E800H        
    PORTB     EQU 0E801H        
    PORTC     EQU 0E802H        
    CTRL_PORT EQU 0E803H        

MAIN:
    ; ==========================================
    ; 1. SYSTEM INITIALIZATION
    ; ==========================================
    MOV DPTR, #CTRL_PORT
    MOV A, #89H                 ; PA=Out, PB=Out, PC=In
    MOVX @DPTR, A

    CLR 00H             ; Mode Flag: 0=Clock, 1=Stopwatch
    CLR 01H             ; SW Run Flag: 0=Stopped, 1=Running
    SETB 03H            ; Debounce for Start (PC1)
    SETB 04H            ; Debounce for Stop (PC2)
    
    MOV 30H, #20        ; 20 ticks = 1 sec

    ; --- SET INITIAL CLOCK TIME (10:59:45) ---
    MOV DPTR, #9000H
    MOV A, #10H                 ; Hours
    MOVX @DPTR, A
    INC DPTR
    MOV A, #59H                 ; Minutes
    MOVX @DPTR, A
    INC DPTR
    MOV A, #45H                 ; Seconds
    MOVX @DPTR, A

    ; --- CLEAR STOPWATCH MEMORY ---
    CLR A
    MOV DPTR, #9003H
    MOVX @DPTR, A
    INC DPTR
    MOVX @DPTR, A
    INC DPTR
    MOVX @DPTR, A

    ; Start Timer 0 (50ms Overflows)
    MOV TMOD, #01H      
    MOV TH0, #4CH       
    MOV TL0, #00H
    
    MOV IE, #82H        ; Enable Interrupts
    SETB TR0            ; Start Timer

    ; ==========================================
    ; 2. MAIN LOOP
    ; ==========================================
MAIN_LOOP:
    MOV DPTR, #PORTC
    MOVX A, @DPTR
    MOV R2, A           ; R2 holds Port C state

    ; --- 1. LEVEL-TRIGGERED MODE SWITCH (PC0) ---
    ; PC0 High = Clock, PC0 Low = Stopwatch
    JB ACC.0, MODE_IS_HIGH
    SETB 00H            ; MODE_FLAG = 1 (Stopwatch Mode)
    SJMP CHECK_START
MODE_IS_HIGH:
    CLR 00H             ; MODE_FLAG = 0 (Clock Mode)

    ; --- 2. ACTIVE-LOW START SWITCH (PC1) ---
CHECK_START:
    MOV A, R2
    JB ACC.1, START_IS_HIGH     
    
    JNB 03H, CHECK_STOP         
    CLR 03H                     
    JNB 00H, CHECK_STOP         
    
    CLR A
    MOV DPTR, #9003H
    MOVX @DPTR, A
    INC DPTR
    MOVX @DPTR, A
    INC DPTR
    MOVX @DPTR, A
    SETB 01H                    
    SJMP CHECK_STOP
    
START_IS_HIGH:
    SETB 03H                    

    ; --- 3. ACTIVE-LOW STOP SWITCH (PC2) ---
CHECK_STOP:
    MOV A, R2
    JB ACC.2, STOP_IS_HIGH      
    
    JNB 04H, UPDATE_DISP        
    CLR 04H                     
    JNB 00H, UPDATE_DISP        
    CLR 01H                     
    SJMP UPDATE_DISP
    
STOP_IS_HIGH:
    SETB 04H                    

    ; --- 4. MULTIPLEXING DISPLAY ROUTINE ---
UPDATE_DISP:
    JB 00H, SHOW_SW
    MOV R0, #90H        ; Display Clock Data
    MOV R1, #00H
    SJMP RENDER_DIGITS
SHOW_SW:
    MOV R0, #90H        ; Display Stopwatch Data
    MOV R1, #03H

RENDER_DIGITS:
    ; Seconds
    MOV DPH, R0
    MOV DPL, R1
    INC DPTR
    INC DPTR
    MOVX A, @DPTR
    MOV R3, A           
    
    ANL A, #0FH
    ACALL SEND_TO_PA
    MOV DPTR, #PORTB
    MOV A, #0FEH        
    MOVX @DPTR, A
    ACALL DELAY_2MS

    ACALL BLANK_DISP
    MOV A, R3
    SWAP A
    ANL A, #0FH
    ACALL SEND_TO_PA
    MOV DPTR, #PORTB
    MOV A, #0FDH        
    MOVX @DPTR, A
    ACALL DELAY_2MS

    ; Minutes
    MOV DPH, R0
    MOV DPL, R1
    INC DPTR
    MOVX A, @DPTR
    MOV R3, A           
    
    ACALL BLANK_DISP
    MOV A, R3
    ANL A, #0FH
    ACALL SEND_TO_PA
    MOV DPTR, #PORTB
    MOV A, #0FBH        
    MOVX @DPTR, A
    ACALL DELAY_2MS

    ACALL BLANK_DISP
    MOV A, R3
    SWAP A
    ANL A, #0FH
    ACALL SEND_TO_PA
    MOV DPTR, #PORTB
    MOV A, #0F7H        
    MOVX @DPTR, A
    ACALL DELAY_2MS

    ; Hours
    MOV DPH, R0
    MOV DPL, R1
    MOVX A, @DPTR
    MOV R3, A           
    
    ACALL BLANK_DISP
    MOV A, R3
    ANL A, #0FH
    ACALL SEND_TO_PA
    MOV DPTR, #PORTB
    MOV A, #0EFH        
    MOVX @DPTR, A
    ACALL DELAY_2MS

    ACALL BLANK_DISP
    MOV A, R3
    SWAP A
    ANL A, #0FH
    ACALL SEND_TO_PA
    MOV DPTR, #PORTB
    MOV A, #0DFH        
    MOVX @DPTR, A
    ACALL DELAY_2MS

    ACALL BLANK_DISP    
    LJMP MAIN_LOOP      

; =========================================================
; 3. TIMER 0 INTERRUPT SERVICE ROUTINE (Background Clock)
; =========================================================
TIMER0_ISR:
    CLR TR0
    MOV TH0, #4CH
    MOV TL0, #00H
    SETB TR0

    PUSH ACC
    PUSH PSW
    PUSH DPL
    PUSH DPH

    DJNZ 30H, EXIT_ISR  
    MOV 30H, #20        

    ; --- CLOCK MATH ---
    MOV DPTR, #9002H    
    MOVX A, @DPTR
    ADD A, #01H         
    DA A                
    CJNE A, #60H, SAVE_C_SEC
    MOV A, #00H         
SAVE_C_SEC:
    MOVX @DPTR, A
    JNZ CHECK_SW_MATH   

    MOV DPTR, #9001H    
    MOVX A, @DPTR
    ADD A, #01H
    DA A
    CJNE A, #60H, SAVE_C_MIN
    MOV A, #00H
SAVE_C_MIN:
    MOVX @DPTR, A
    JNZ CHECK_SW_MATH   

    MOV DPTR, #9000H    
    MOVX A, @DPTR
    ADD A, #01H
    DA A
    CJNE A, #24H, SAVE_C_HR
    MOV A, #00H
SAVE_C_HR:
    MOVX @DPTR, A

    ; --- STOPWATCH MATH ---
CHECK_SW_MATH:
    JNB 01H, EXIT_ISR   

    MOV DPTR, #9005H    
    MOVX A, @DPTR
    ADD A, #01H
    DA A
    CJNE A, #60H, SAVE_S_SEC
    MOV A, #00H
SAVE_S_SEC:
    MOVX @DPTR, A
    JNZ EXIT_ISR

    MOV DPTR, #9004H    
    MOVX A, @DPTR
    ADD A, #01H
    DA A
    CJNE A, #60H, SAVE_S_MIN
    MOV A, #00H
SAVE_S_MIN:
    MOVX @DPTR, A
    JNZ EXIT_ISR

    MOV DPTR, #9003H    
    MOVX A, @DPTR
    ADD A, #01H
    DA A
    CJNE A, #24H, SAVE_S_HR
    MOV A, #00H
SAVE_S_HR:
    MOVX @DPTR, A

EXIT_ISR:
    POP DPH
    POP DPL
    POP PSW
    POP ACC
    RETI

; =========================================================
; SUBROUTINES & CUSTOM DATA
; =========================================================
SEND_TO_PA:
    PUSH DPH
    PUSH DPL
    MOV DPTR, #HEX_TABLE
    MOVC A, @A+DPTR
    MOV DPTR, #PORTA
    MOVX @DPTR, A
    POP DPL
    POP DPH
    RET

BLANK_DISP:
    MOV DPTR, #PORTB
    MOV A, #0FFH
    MOVX @DPTR, A
    RET

DELAY_2MS:
    MOV R6, #4
D1: MOV R7, #250
D2: DJNZ R7, D2
    DJNZ R6, D1
    RET

HEX_TABLE: 
    DB 7EH, 0CH, 0B6H, 9EH, 0CCH, 0DAH, 0FAH, 0EH, 0FEH, 0DEH

; =========================================================
; INTERRUPT VECTOR MAPPING (CRITICAL: MUST BE AT END)
; =========================================================
    ORG 0FFF0H          ; Trainer Address from Kit Manual
    LJMP TIMER0_ISR

    END