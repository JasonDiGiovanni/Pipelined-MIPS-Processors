#
# Implement a mips program that sorts an array with N elements using the BubbleSort algorithm
# 
# add, addi, addiu, addu, and, andi, lui, lw, nor, xor, xori, or, ori, slt, slti, sll, srl, sra, sw, sub, subu, beq, bne, j, jal, jr
#
#// Optimized implementation of Bubble sort
#include <stdbool.h>
#include <stdio.h>

#void swap(int* xp, int* yp){
#    int temp = *xp;
#    *xp = *yp;
#    *yp = temp;
#}
#
#// An optimized version of Bubble Sort
#void bubbleSort(int arr[], int n){
#    int i, j;
#    bool swapped;
#    for (i = 0; i < n - 1; i++) {
#        for (j = 0; j < n - i - 1; j++) {
#            if (arr[j] > arr[j + 1]) {
#                swap(&arr[j], &arr[j + 1]);
#                swapped = true;
#            }
#        }
#
#        // If no two elements were swapped by inner loop,
#        // then break
#        if (swapped == false)
#            break;
#    }
#}
#
#// Function to print an array
#void printArray(int arr[], int size){
#    int i;
#    for (i = 0; i < size; i++)
#        printf("%d ", arr[i]);
#}
#
#int main(){
#    int arr[] = { 64, 34, 25, 12, 22, 11, 90 };
#    int n = sizeof(arr) / sizeof(arr[0]);
#    bubbleSort(arr, n);
#    printf("Sorted array: \n");
#    printArray(arr, n);
#    return 0;
#}

.data
arr:    .word 7, 10, 20, 6, 50    # Unsorted array
size:   .word 5                # Size of the array
newline: .asciiz "\n"

.text
.globl main
main:
    # Load size of the array into $s0 (size)
    #lw $s0, size               # $s0 = size (n)
    lui $1, 4097
    NOP
    NOP
    NOP
    lw $16,20($1)

    # Initialize i = 0 (outer loop index)
    addi $s1, $0, 0            # $s1 = i = 0        #Fetch.
    NOP                                             #Decode
    NOP                                             #Execute
for1:
    # Check if i < n-1 using slt and beq
    sub $t0, $s0, $s1          # $t0 = n - i        #Memory Access    #Fetch.
    NOP                                             #Write Back       #Decode
    NOP                                                               #Execute
    addi $t0, $t0, -1          # $t0 = n - i - 1                      #Memory Access        #Fetch.
    NOP                                                               #Write Back           #Decode
    NOP                                                                                     #Execute
    slt $t1, $0, $t0           # $t1 = 1 if n - i - 1 > 0             #Fetch.               #Memory Access
    NOP                                                               #Decode               #Write Back
    NOP                                                               #Execute
    beq $t1, $0, exit_for1     # Exit if n - i - 1 <= 0               #Memory Access
    NOP

    # Initialize j = 0 (inner loop index)
    addi $s2, $0, 0            # $s2 = j = 0                          #Write Back           #Fetch.
    NOP                                                                                     #Decode
    NOP                                                                                     #Execute
for2:
    # Check if j < n - i - 1 using slt and beq
    slt $t1, $s2, $t0          # if j < n - i - 1                                           #Memory Access        #Fetch.
    NOP                                                                                     #Write Back           #Decode
    NOP                                                                                                           #Execute
    beq $t1, $0, next_for1     # Exit inner loop if j >= n - i - 1                                                #Memory Access
    NOP

    # Load arr[j] and arr[j + 1]
    sll $t2, $s2, 2            # $t2 = j * 4 (word offset for arr[j])                       #Fetch.               #Write Back
    NOP                                                                                     #Decode
    NOP                                                                                     #Execute
    #lw $t3, arr($t2)           # Load arr[j] into $t3                                       #Memory Access
    lui $1, 4097
    NOP
    NOP
    NOP
    addu $1, $1, $10
    NOP
    NOP
    lw $11, 0($1)
    addi $t4, $t2, 4           # $t4 = (j + 1) * 4 (word offset for arr[j + 1])             #Write Back           #Fetch.
    NOP                                                                                                           #Decode
    NOP                                                                                                           #Execute
    #lw $t5, arr($t4)           # Load arr[j + 1] into $t5                                   #Fetch.               #Memory Access
    lui $1, 4097
    NOP
    NOP
    NOP
    addu $1, $1, $12
    NOP                                                                                     #Decode               #Write Back
    NOP                                                                                     #Execute
    lw $13, 0($1)
    NOP                                                                                     #Memory Access
    NOP
    NOP

    # Compare arr[j] > arr[j + 1]
    slt $t6, $t5, $t3          # $t6 = (arr[j] > arr[j + 1]) ? 1 : 0                        #Write Back            #Fetch.
    NOP                                                                                                            #Decode
    NOP                                                                                                            #Execute
    beq $t6, $0, skip_swap     # If arr[j] <= arr[j + 1], skip swap                                                #Memory Access
    NOP

    # Swap arr[j] and arr[j+1]
    #sw $t5, arr($t2)           # arr[j] = arr[j+1]                                                                 #Write Back
    lui $1, 4097
    NOP
    NOP
    NOP
    addu $1, $1, $10
    NOP
    NOP
    sw $13, 0($1)
    #sw $t3, arr($t4)           # arr[j+1] = arr[j]
    lui $1, 4097
    NOP
    NOP
    NOP
    addu $1, $1, $12
    NOP
    NOP
    sw $11, 0($1)
    
    

skip_swap:
    addi $s2, $s2, 1           # j++                    #Fetch.
    NOP                                                 #Decode
    j for2                    # Repeat inner loop       #Execute
    NOP                                                    #Mem and Write happen back at top of for2

next_for1:
    addi $s1, $s1, 1           # i++                    #Fetch.
    NOP                                                 #Decode
    j for1                    # Repeat outer loop       #Execute
    NOP                                                    #Mem and Write happen back at top of for1

exit_for1:
    # Print sorted array
    addi $12, $0, 4
    #lw $s3, arr                # $s3 = arr[0]
    lui $1, 4097
    NOP
    NOP
    NOP
    lw $19, 0($1)
    #lw $s4, arr+4              # $s4 = arr[1]
    #lui $1, 4097
    addu $1, $1, $12
    NOP
    NOP
    
    lw $20, 0($1)
    #lw $s5, arr+8              # $s5 = arr[2]
    #lui $1, 4097
    addu $1, $1, $12
    NOP
    NOP
    lw $21, 0($1)
    #lw $s6, arr+12             # $s6 = arr[3]
    #lui $1, 4097
    addu $1, $1, $12
    NOP
    NOP
    lw $22, 0($1)
    #lw $s7, arr+16             # $s7 = arr[4]
    #lui $1, 4097
    addu $1, $1, $12
    NOP
    NOP
    lw $23, 0($1)



exit:
    # Exit program
    li $v0, 10                 # syscall for exit
    syscall

    halt
