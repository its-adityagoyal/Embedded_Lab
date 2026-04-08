ORG 8100H

    MOV DPTR, #9000H ; Point to input address
    MOVX A, @DPTR    ; Read input data from 9000H into A

    INC DPTR         ; Increment DPTR to 9001H (for output)
    
    JB SP.0, IS_ODD ; Check LSB (Bit 0). If 1, Jump to ODD.

    ; --- EVEN CASE ---
    MOV A, #0EEH     ; Load 'EE' into Accumulator first
    MOVX @DPTR, A    ; Move Accumulator to External Memory (9001H)
    SJMP STOP        ; Jump to end

IS_ODD:
    ; --- ODD CASE ---
    MOV A, #0DDH     ; Load 'DD' into Accumulator first
    MOVX @DPTR, A    ; Move Accumulator to External Memory (9001H)

STOP: SJMP STOP      ; Infinite loop
END