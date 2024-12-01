# RAW_2: Test RAW hazard with a gap of one instruction between dependent instructions
addi $t1, $0, 5 # Produce result in $t1
NOP
addi $t2, $t1, 5 # Use $t1 immediately
