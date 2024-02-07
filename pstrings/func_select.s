.section .rodata
invalid: .string "invalid option!\n"
length_text: .string "first pstring length: %d, second pstring length: %d\n"
swap_text: .string "length: %d, string: %s\n"
input: .string "%d"

.section .text 
.globl run_func
run_func: 
    pushq   %rbp        # save the old frame pointer
    movq    %rsp, %rbp  # create the new frame pointer
    cmpq $31, %rdi
    je pstrlength
    cmpq $33, %rdi 
    je swap
    cmpq $34, %rdi 
    je stringcpy 
    jmp wrong 

pstrlength:
    movq %rsi,%rdi 
    call pstrlen
    movq %rax,%r10 #first pstring length 
    movq %rdx,%rdi 
    call pstrlen
    movq %rax,%rdx 
    movq %r10,%rsi
    movq $length_text,%rdi 
    call printf
    popq	%rbp
    ret

swap:
    movq %rdx,%r15 #sending second pstring to r15
    # Doing swapcase for pstring 1
    movq %rsi,%rdi 
    call swapCase
    movq %rax,%rsi
    call pstrlen
    movq %rax,%rsi
    movq %rdi,%rdx
    movq $swap_text,%rdi
    addq $1,%rdx 
    call printf
    # Doing swapcase for pstring 2
    movq %r15,%rdi 
    call swapCase
    movq %rax,%rsi
    call pstrlen
    movq %rax,%rsi
    movq %rdi,%rdx
    movq $swap_text,%rdi
    addq $1,%rdx 
    call printf
    popq	%rbp
    ret

stringcpy:
    #we need to get 2 more chars and send them to rdx ,rcx 
    #we need to save the pstrings in r15,r14
    movq %rsi,%r15 
    movq %rdx,%r14
    movq $input,%rdi #scanf format
    subq  $16,%rsp 
    leaq (%rsp),%rsi #move the adress in the stack to rsi for scanf
    call scanf
    movzx (%rsp),%r13 #move the result to r13
    leaq (%rsp),%rsi 
    movq $input,%rdi
    call scanf
    movzx (%rsp),%rcx
    movq %r13,%rdx 
    addq $16,%rsp  
    call pstrijcpy
    movq %r15,%rdi 
    call pstrlen
    movq %rax,%rsi
    movq $swap_text,%rdi 
    movq %r15,%rdx
    addq $1,%rdx
    call printf
    movq %r14,%rdi 
    call pstrlen
    movq %rax,%rsi 
    movq %r14,%rdx 
    movq $swap_text,%rdi 
    addq $1,%rdx
    call printf
    popq	%rbp
    ret 
    





wrong: 
    movq $invalid,%rdi 
    call printf 
    popq	%rbp
    ret 

