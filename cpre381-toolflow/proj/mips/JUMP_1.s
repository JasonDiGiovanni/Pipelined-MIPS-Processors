# JUMP_1: Test an unconditional jump to a label
j Label1
NOP                    # This instruction will be flushed
Label1: 
addi $t1, $0, $10