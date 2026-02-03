//Check whether a NULL terminated string stored from location 9000H is a substring of another NULL terminated string
//stored from location 9200H or not. If a substring is detected, store the start index (not address) at memory location
//9500H, else store -1 at 9500H.

		ORG 8100H
		
		MOV R6, #00H	//Counter for outer loop
		
		//Outer loop for main string
		LOOP1:
			//Termination condition for outer loop
			MOV A, R6
			MOV DPL, A
			MOV DPH, #92H
			MOVX A, @DPTR
			CJNE A, #00H, CONTINUE_LOOP1
			
			SJMP QUIT
			
			CONTINUE_LOOP1:
				MOV R7, #00H	//Counter for inner loop
				
				//Inner loop for test string
				LOOP2:
					//Condition for successful termination of inner loop
					MOV A, R7
					MOV DPL, A
					MOV DPH, #90H
					MOVX A, @DPTR
					CJNE A, #00H, CONTINUE_LOOP2
					
					SJMP PRINT
					
					CONTINUE_LOOP2:
						MOV DPH, #92H
						MOV A, R6
						ADD A, R7
						MOV DPL, A
						MOVX A, @DPTR
						MOV R1, A	//stores current character of main string
						
						MOV DPH, #90H
						MOV A, R7
						MOV DPL, A
						MOVX A, @DPTR	//stores current character of test string
						
						CJNE A, 01H, INCREMENT	//compares the corresponding characters of main string and test string
						
						INC R7
						
						SJMP LOOP2
						
				INCREMENT:
					INC R6
					SJMP LOOP1
			
		
		//Store the starting index of the main string from where the test string starts
		PRINT:
			MOV DPTR, #9500H
			MOV A, R6
			MOVX @DPTR, A
			
			SJMP INF_LOOP
		
		//Store -1
		QUIT:
			MOV DPTR, #9500H
			MOV A, #0FFH
			MOVX @DPTR, A
			
			SJMP INF_LOOP
		
		INF_LOOP: SJMP INF_LOOP
			END
						
						
			
			