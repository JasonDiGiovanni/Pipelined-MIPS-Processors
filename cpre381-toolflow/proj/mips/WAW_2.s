# WAW_2: Test WAW hazard with a gap of one instruction between writes
addi $t1, $0, 5    # Write to $t1
NOP
addi $t1, $0, 10    # Write to $t1 again