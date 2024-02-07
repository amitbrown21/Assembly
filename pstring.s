.section .rodata
invalid: .string "invalid input!\n"


.section .text
.globl pstrlen
pstrlen:
    pushq   %rbp        # save the old frame pointer
    movq    %rsp, %rbp  # create the new frame pointer
    xorq %rax,%rax 
    movb (%rdi),%al #move the first char (the length) to al (rax)
    popq	%rbp
    ret

.globl swapCase
swapCase:
#Pstring to both r12 and r14
    pushq   %rbp        # save the old frame pointer
    movq    %rsp, %rbp  # create the new frame pointer
    movq %rdi,%r14
    xorq %r12, %r12 
    movq %rdi,%r12 
    xorb %al,%al 
swap_loop:
    movb 1(%r12),%al #move the current char to %al and check if null  
    cmpb $0,%al 
    je done 
    #checking if the character is not an alphabet letter
    cmpb $'A',%al 
    jl special_char
    cmpb $'z',%al 
    jg special_char
    cmpb $'Z',%al
    jle swap_loop_1
    cmpb $'a',%al
    jl special_char
swap_loop_1:
    #xor32 changes the case (very cool)
    xorb $32,%al 
    movb %al , 1(%r12) #move byte back to r12
special_char:
    incq %r12 #move to the next char in r12
    jmp swap_loop

done:
    movq %r12,%rax
    movq %r14,%rdi 
    popq	%rbp
    ret


.globl pstrijcpy
pstrijcpy:
    #first pstirng in r15, second in r14
    pushq   %rbp        # save the old frame pointer
    movq    %rsp, %rbp  # create the new frame pointer
    movq %rdx, %rbx     # i to rbx
    movq %rcx, %rcx     # j to rcx
    #checking if i and j are valid 
    movb (%r15), %al    # length of string to rax 
    cmpq %rax, %rbx       # Compare i to length 
    jge  invalid_input    
    cmpq %rax, %rcx       # Compare j to length 
    jge  invalid_input  
    movb (%r14),%al   
    cmpq %rax, %rbx      # Compare i to length 
    jge  invalid_input    
    cmpq %rax, %rcx       # Compare j to length
    jge  invalid_input  
    cmpq %rcx,%rbx      # Compare i to j 
    jge invalid_input
    addq $1,%rcx
pstrijcpy_loop:
    cmpq %rbx,%rcx #compare i and j
    je cpy_done
    movb 1(%r14,%rbx),%al # put the character in i position of the second pstring into al 
    movb %al,1(%r15,%rbx) # move it to the i position of the first pstring
    incq %rbx #+1 i
    jmp pstrijcpy_loop
invalid_input:
    movq $invalid,%rdi #print error 
    call printf

cpy_done:
    popq %rbp
    ret




