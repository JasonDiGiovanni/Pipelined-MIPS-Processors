# JUMP_2: Test a jump and link instruction with a return to the caller
jal Label1
NOP                    # Placeholder instruction
Label1: 
jr $ra         # Return to the caller
