

.data


.text
.globl main
main:
    
                                                                
                                                                                       
jal return
j exit2
j exit
return:
	addi $t1 $ra 4
	jr $t1    
   
exit:
    halt

exit2:
