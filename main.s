.section .rodata   # read-only data section
str:     .string "Enter configuration seed: "
userin:  .string "What is your guess? "
wrong:   .string "Incorrect.\n"
over:    .string "Game over, you lost :(. The correct answer was %d\n"
won:     .string "Congratz! You won!\n"
format:  .string "%d"

.section .data
seed:    .long 0
answer: .long 0 
max:    .long 5

.section .text    
.globl main    

.type main, @function
main:
    pushq   %rbp        # save the old frame pointer
    movq    %rsp, %rbp  # create the new frame pointer
    movq    $str, %rdi 
    movq    $0, %rax
    call    printf      # print config seed request
    movq    $format, %rdi
    leaq    seed, %rsi  # load address of seed for scanf
    call    scanf       # get config seed 
    movq    seed, %rdi 
    call    srand       # config to rand seed 
    call    rand        # rand generated in rax
    movq    $10, %rcx   # N=10 
    xorq    %rdx, %rdx 
    idiv    %rcx        # getting the rand mod 10 
    movq    %rdx, %r13  # this is my randomly generated number
    movq    $0,%r15 # counter initialized 

game: #loop start
   cmpq    max, %r15 # compare M and the counter
    jge     game_over 
    movq    $userin, %rdi
    call    printf
    movq    $format, %rdi
    movq    $answer, %rsi  
    call    scanf
    movq    %rsi, %r12  # this is the entered guess
    cmpq    %r13, %r12 # compare guess to answer 
    je      correct  
    incq    %r15 # increment the counter
    movq    $wrong, %rdi 
    call    printf
    jmp     game #loop

.type correct, @function
correct:
    movq    $won, %rdi
    call    printf
    call    exit

.type game_over, @function
game_over:
    movq    $over, %rdi
    movq    %r13, %rsi  
    call    printf
    call    exit

