;Cagla Midikli 150200011
		AREA complement, CODE, READONLY	;declare new area
		ENTRY 							;declare as antry point
		ALIGN							;ensures that __main addresses the following instruction
			

	
__main  FUNCTION						;enable Debug
		EXPORT __main					;make __main as global to access from startup file
		MOVS r0, #10					;move symbolic value to R0
		MOVS r1, #0xFF					;move 1111 1111 to R0 because of find first complement 
		EORS r0, r0, r1 				;I applied bitwise or 1111 1111 value and r0  because To get the component of the bits
		B stop							;branch stop
		

stop	B    stop						;branch stop
					



		ENDFUNC							;finish function
		END								;finish assembly file