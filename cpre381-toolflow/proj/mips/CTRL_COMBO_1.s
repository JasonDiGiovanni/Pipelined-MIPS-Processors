# CTRL_COMBO_1: Test back-to-back branches, both taken
addi $t1, $0, 5
bne $t1, $t2, Label1   # First branch taken
Label1: bne $t1, $t3, Label2   # Second branch taken
Label2: addi $t4, $0, 10
