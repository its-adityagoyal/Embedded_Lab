ORG 8100H

    ; --- Setup (Manually putting values) ---
    MOV DPTR, #9000H
    MOV A, #05H
    MOVX @DPTR, A       ; A[0] = 05
    INC DPTR
    MOV A, #09H
    MOVX @DPTR, A       ; A[1] = 09

    ; --- THE SWAP LOGIC START ---
    MOV DPTR, #9000H    ; Point to first number
    MOVX A, @DPTR       ; Read 1st number (05)
    MOV B, A            ; Save it in B (TEMP)

    INC DPTR            ; Move to second number
    MOVX A, @DPTR       ; Read 2nd number (09)
    
    ; We are at 9001H. A holds 09, B holds 05.
    DEC DPL           ; Go back to 9000H
    MOVX @DPTR, A       ; Write 09 to first location
    
    INC DPTR            ; Go back to 9001H
    MOV A, B            ; Get the old 05 back
    MOVX @DPTR, A       ; Write 05 to second location
    ; --- THE SWAP LOGIC END ---

    HERE: SJMP HERE
    END