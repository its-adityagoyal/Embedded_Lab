;-----------------------------------------------------------
; EXPERIMENT 3: PART B - Custom Sequence Multiplexing
; Sequence: 00-06, 15-23, 29, 47-54 (0.5s display time)
;-----------------------------------------------------------

    ORG 8100H

    ; --- ESA KIT 8255 ADDRESSES ---
    PORTA     EQU 0E800H        
    PORTB     EQU 0E801H        
    CTRL_PORT EQU 0E803H        

INIT_8255:
    MOV DPTR, #CTRL_PORT
    MOV A, #80H                 
    MOVX @DPTR, A

START_SEQUENCE:
    MOV DPTR, #SEQ_DATA         

READ_NEXT:
    CLR A
    MOVC A, @A+DPTR             
    CJNE A, #0FFH, DISPLAY_NUM  
    SJMP START_SEQUENCE         

DISPLAY_NUM:
    MOV R2, A                   
    MOV R4, #50                 
    
MUX_LOOP:
    ; ---> THE FIX: SAVE DPTR IMMEDIATELY <---
    PUSH DPL                    
    PUSH DPH

    ; ==========================================
    ; TENS DIGIT (DISPLAY 1 - P1B0)
    ; ==========================================
    MOV DPTR, #PORTB
    MOV A, #03H                 ; Blanking
    MOVX @DPTR, A

    MOV A, R2
    SWAP A                      
    ANL A, #0FH                 
    MOV DPTR, #HEX_TABLE        
    MOVC A, @A+DPTR             
    
    MOV DPTR, #PORTA
    MOVX @DPTR, A               
    
    MOV DPTR, #PORTB
    MOV A, #02H                 ; Turn ON Display 1
    MOVX @DPTR, A
    ACALL DELAY_5MS             

    ; ==========================================
    ; ONES DIGIT (DISPLAY 2 - P1B1)
    ; ==========================================
    MOV DPTR, #PORTB
    MOV A, #03H                 ; Blanking
    MOVX @DPTR, A

    MOV A, R2
    ANL A, #0FH                 
    MOV DPTR, #HEX_TABLE        
    MOVC A, @A+DPTR             
    
    MOV DPTR, #PORTA
    MOVX @DPTR, A               
    
    MOV DPTR, #PORTB
    MOV A, #01H                 ; Turn ON Display 2
    MOVX @DPTR, A
    ACALL DELAY_5MS             

    ; ---> THE FIX: RESTORE DPTR AT THE VERY END <---
    POP DPH                     
    POP DPL
    
    DJNZ R4, MUX_LOOP           

    INC DPTR                    
    SJMP READ_NEXT              

;-----------------------------------------------------------
; Subroutines & Data
;-----------------------------------------------------------
DELAY_5MS:
    MOV R6, #10
M1: MOV R7, #250
M2: DJNZ R7, M2
    DJNZ R6, M1
    RET

HEX_TABLE: 
    DB 3FH, 06H, 5BH, 4FH, 66H, 6DH, 7DH, 07H, 7FH, 6FH

SEQ_DATA:
    DB 00H, 01H, 02H, 03H, 04H, 05H, 06H
    DB 15H, 16H, 17H, 18H, 19H, 20H, 21H, 22H, 23H
    DB 29H
    DB 47H, 48H, 49H, 50H, 51H, 52H, 53H, 54H
    DB 0FFH

    END