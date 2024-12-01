# COMBO_1: Test a combination of RAW and WAR hazards in consecutive instructions
add $t2, $t1, $0   # Read $t1
addi $t1, $0, 5 # Produce result in $t1
addi $t2, $t1, 5 # Use $t1 immediately