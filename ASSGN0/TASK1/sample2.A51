//This simple program for swapping the values stored at
//external memory locations 9000H and 9001H 

		
		ORG 8100H		  // The starting address of the program code in memory
		
		//Initializing values to external memory
		MOV DPTR, #9000H
		MOV A, #05H
		MOVX @DPTR, A
		MOV DPTR, #9001H
		MOV A, #09H
		MOVX @DPTR, A
		
		//Bringing values to processor's inside memory
		MOV DPTR, #9000H
		MOVX A, @DPTR
		MOV R0, A
		MOV DPTR, #9001H
		MOVX A, @DPTR
		MOV R1, A
		
		//Swapping
		MOV A,R0
		MOVX @DPTR, A
		MOV DPTR, #9000H
		MOV A,R1
		MOVX @DPTR, A
			END