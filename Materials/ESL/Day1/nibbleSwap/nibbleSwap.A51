ORG 8100H
	
    MOV DPTR, #9000H
    MOVX A,@DPTR      ; Load value FROM 9000H
    MOV B, A        ; SAVE A COPY in Register B (Critical Step!)
    
    ANL A, #0FH     ; Mask the upper bits (AND with 0000 1111)
                    ; 45H (0100 0101) becomes 05H (0000 0101)
	RR A            
    RR A
    RR A
    RR A 				
    MOV R0, A      ; Store lower nibble in R0

    
    MOV A, B        ; Reload the original value from B (45H)
    ANL A, #0F0H    ; Mask the lower bits (AND with 1111 0000)
                    ; 45H becomes 40H (0100 0000)

    ; Move the upper nibble down to the lower position
    ; Since SWAP is banned, we Rotate Right 4 times
    RR A            
    RR A
    RR A
    RR A            
	
	ADD A,R0
	INC DPTR
    MOVX @DPTR, A      

HERE: SJMP HERE     ; Stop
END