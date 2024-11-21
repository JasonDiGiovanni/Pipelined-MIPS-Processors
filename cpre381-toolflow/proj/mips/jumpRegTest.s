

.data


.text
.globl main
main:
    
                                                                
                                                                                       
    addi $t0, $0, 1          
    addi $t1, $0, 1                                                                                        
    beq $t0, $t1, exit 
    addi $t2, $0, 3      
   
exit:
    halt
