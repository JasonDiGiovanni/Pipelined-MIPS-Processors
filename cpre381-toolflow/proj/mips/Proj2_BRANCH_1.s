# BRANCH_1: Test a taken branch with instructions after the branch flushed
BEQ R1, R2, Label1   # Branch taken
NOP                  # This instruction will be flushed
Label1: ADD R3, R4, R5
