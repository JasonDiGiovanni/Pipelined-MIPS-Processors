# BRANCH_1: Test a taken branch with instructions after the branch flushed
addi $t1, $0, 5
bne $t1, $t2, Label1   # Branch taken
NOP                    # This instruction will be flushed
Label1: 
addi $t2, $0, 10