.text
main:
addi $t1, $0, 5
bne $t1, $0, skipAdd
NOP

skipAdd:
addi $t1, $t1, 5

halt