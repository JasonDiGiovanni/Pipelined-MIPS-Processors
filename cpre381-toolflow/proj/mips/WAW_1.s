# WAW_1: Test WAW hazard where two instructions write to the same register consecutively
addi $t1, $0, 5    # Write to $t1
addi $t1, $0, 10    # Write to $t1 again