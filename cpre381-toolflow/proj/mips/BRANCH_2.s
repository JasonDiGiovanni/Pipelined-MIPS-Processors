# BRANCH_2: Test a not-taken branch with instructions executed sequentially
bne $t1, $t2, Label1   # Branch not taken
addi $t3, $0, 10      # Executes normally
Label1: 
addi $t4, $0, 10