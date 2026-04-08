ORG 8100H

; -------------------------------------------------
; CONSTANT DEFINITIONS
; -------------------------------------------------
ARRAY_BASE EQU 09000H
KEY_ADDR   EQU 09500H
RESULT     EQU 09550H
SIZE       EQU 10
SIZE_N1    EQU 09          ; SIZE - 1

; -------------------------------------------------
; SORTING (BUBBLE SORT)
; -------------------------------------------------
           
START:      MOV     R0,#SIZE        ; Outer loop

SORT1:      MOV     R1,#SIZE_N1     ; Inner loop
            MOV     DPTR,#ARRAY_BASE

SORT2:      MOVX    A,@DPTR         ; Read arr[j]
            MOV     R5,A            ; Save arr[j] in R5
            INC     DPTR
            MOVX    A,@DPTR         ; Read arr[j+1]
            MOV     B,A             ; B = arr[j+1]
           
            ; Compare arr[j] (R5) and arr[j+1] (B)
            MOV     A,R5            ; Load arr[j] back to A
            CLR     C
            SUBB    A,B             ; A - B
           
            ; If Carry=1 (A < B), correct order -> Jump
            JC      NEXT
            ; If Zero=1 (A == B), correct order -> Jump
            JZ      NEXT
           
            ; If C=0 and Z=0, then A > B -> SWAP
            ; Current DPTR points to arr[j+1]
            MOV     A,R5            ; A = arr[j]
            MOVX    @DPTR,A         ; Store arr[j] in arr[j+1] position
            DEC     DPL
            MOV     A,B             ; A = arr[j+1]
            MOVX    @DPTR,A         ; Store arr[j+1] in arr[j] position
            INC     DPTR            ; Restore DPTR to j+1 for next iter

NEXT:       DJNZ    R1,SORT2
            DJNZ    R0,SORT1

; -------------------------------------------------
; BINARY SEARCH
; -------------------------------------------------

            MOV     R2,#00H         ; LOW = 0
            MOV     R3,#SIZE_N1     ; HIGH = 9

SEARCH_LOOP:
            ; Compare LOW (R2) and HIGH (R3)
            MOV     A,R2
            CLR     C
            SUBB    A,R3
            JZ      CHECK_LAST      ; If Zero, LOW == HIGH (Check single element)
            JNC     NOT_FOUND       ; If No Carry, LOW > HIGH (Not found)
            ; If Carry, LOW < HIGH -> Continue

            ; CALC MID = (LOW + HIGH) / 2
            MOV     A,R2
            ADD     A,R3
            CLR     C
            RRC     A
            MOV     R4,A            ; MID in R4

            ; READ arr[MID]
            MOV     DPTR,#ARRAY_BASE
            MOV     A,R4
            ADD     A,DPL
            MOV     DPL,A
            MOV     A,#00H
            ADDC    A,DPH
            MOV     DPH,A
           
            MOVX    A,@DPTR         ; A = arr[MID]
            MOV     R5,A            ; Save arr[MID] in R5

            ; READ KEY
            MOV     DPTR,#KEY_ADDR
            MOVX    A,@DPTR
            MOV     B,A             ; B = KEY
           
            ; COMPARE arr[MID] (R5) with KEY (B)
            MOV     A,R5
            CLR     C
            SUBB    A,B
            JZ      FOUND           ; If Zero, A == KEY
            JC      MOVE_RIGHT      ; If Carry, A < KEY -> Look Right
           
            ; Else A > KEY -> Look Left (HIGH = MID - 1)
            MOV     A,R4
            JZ      NOT_FOUND       ; Safety: If MID=0, cannot decrement
            DEC     A
            MOV     R3,A            ; HIGH = MID - 1
            SJMP    SEARCH_LOOP

MOVE_RIGHT: ; LOW = MID + 1
            MOV     A,R4
            INC     A
            MOV     R2,A           
            SJMP    SEARCH_LOOP

CHECK_LAST:
            ; Check the final element at index R2
            MOV     DPTR,#ARRAY_BASE
            MOV     A,R2
            ADD     A,DPL
            MOV     DPL,A
            MOV     A,#00H
            ADDC    A,DPH
            MOV     DPH,A
           
            MOVX    A,@DPTR         ; Read array element
            MOV     R5,A           
           
            MOV     DPTR,#KEY_ADDR
            MOVX    A,@DPTR         ; Read Key
           
            CLR     C
            SUBB    A,R5            ; Key - Element
            JNZ     NOT_FOUND
           
            ; If Found at last step, Result = R2
            MOV     A,R2
            MOV     R4,A
            SJMP    FOUND

FOUND:      MOV     DPTR,#RESULT
            MOV     A,R4            ; Index
            MOVX    @DPTR,A
            SJMP    DONE

NOT_FOUND:  MOV     DPTR,#RESULT
            MOV     A,#0FFH
            MOVX    @DPTR,A

DONE:       SJMP    $
            END