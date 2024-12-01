# WAR_1: Test WAR hazard where a register read is followed by a write to the same register
add $t2, $t1, $0   # Read $t1
addi $t1, $0, 5    # Write to $t1