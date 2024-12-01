# WAR_2: Test WAR hazard with an instruction gap between the read and write
add $t2, $t1, $0   # Read $t1
NOP
addi $t1, $0, 5    # Write to $t1