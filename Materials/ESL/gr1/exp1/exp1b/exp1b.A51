ORG 8100H

    MOV R0, #05H
    MOV R1, #09H
    
    ; Compare Logic
    MOV A, R0
    CLR C               ; Crucial! Always clear carry before SUBB
    SUBB A, R1          ; A = R0 - R1
    
    ; If R0 < R1, the result is negative, so Carry (C) will be 1.
    JC IS_SMALLER       ; Jump if Carry Set
    
    ; Else (R0 >= R1)
    MOV DPTR, #900FH
    MOV A, #00H
    MOVX @DPTR, A
    SJMP STOP

IS_SMALLER:
    MOV DPTR, #900FH
    MOV A, #01H
    MOVX @DPTR, A

STOP:
    HERE: SJMP HERE
    END