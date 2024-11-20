.data
value:   .word 42

.text
main:
#lw NOP
lw   $s0, value	#42
NOP
addi $s1, $s0, 8 #50
#rtNOP
NOP
addi $t0, $s1, 5
Branch:
#rt
addi $t0, $t0, 5 #60, 65
#branch
bne $t0, 65, Branch
#end
