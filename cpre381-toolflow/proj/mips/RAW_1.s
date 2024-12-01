# RAW_1: Test RAW hazard with adjacent instructions where the result of one is used by the next
addi $t1, $0, 5 # Produce result in $t1
addi $t2, $t1, 5 # Use $t1 immediately
