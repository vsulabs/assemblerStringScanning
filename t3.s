# дано предложение. Определить, если ли два одинаковых слова рядом
# использовать: строковые команды с префиксом повторения 

.data
length:
    .long 0
space:
    .string " "
zero:
    .string "0"
answ_yes:
    .string "string has two similar words together"
answ_no:
    .string "string does not contain two words together"
msg_input:
    .string "please, input string: "
.bss
text:
    .space 128

.text
.globl _start

# int get_text(char* pointer) // return count
GET_TEXT:
    mov     %rsp, %rbp
    push    %rdi
    push    %rdx
    push    %rsi

    xor     %rax, %rax     # read
    xor     %rdi, %rdi     # stdin
    mov     8(%rbp), %rsi  # from
    mov     $128, %rdx     # count
    syscall

    lea     (%rsi, %rax), %rsi # rsi = end of input

    xor     %rdx, %rdx
    movb    (space), %dl
    mov     %rdx, (%rsi)  # set space in the end

    pop     %rsi
    pop     %rdx
    pop     %rdi
    ret 

EXIT:
    add     $8, %rsp     # Убираемя указатель
    mov     $60, %rax    # exit
    xor     %rdi, %rdi   # Код возврата 0
    syscall 


CHECK_TEXT:
    pushq  %rbp
    movq    %rsp,       %rbp

#       ставим один из указателей на начало строки
    subq    $48,        %rsp
    movq    %rdi,       -40(%rbp)
    movq    %fs:40,     %rax
    movq    %rax,       -8(%rbp)
    xorl    %eax,       %eax

#       и второй указатель на начало той же строки
    movq    -40(%rbp),  %rax
    movq    %rax,       -16(%rbp)
    movq    -40(%rbp),  %rax
    movq    %rax,       -24(%rbp)
    movl    $0,         -28(%rbp)
#       второй будет идти впереди, и обязан проверять
#       что не конец строки

    skip_until_not_space:
#           пропускаем первое слово до пробела
            movq        -24(%rbp),      %rax
            addq        $1,             %rax
            movq        %rax,           -24(%rbp)
            movq        -24(%rbp),      %rax
            movsbl      (%rax),         %eax
            
            cmpb        $32,            %al
            je          START_ALGORITHM
            jmp         skip_until_not_space
        
START_ALGORITHM:
#       делаем еще шаг указателем два. 
#       он будет указывать либо на 2 слово либо на конец строки
    movq    -24(%rbp),  %rax
    addq    $1,         %rax
    movq    %rax,       -24(%rbp)
infty_circle:           # основной цикл. 
    mov     -24(%rbp),  %rax
    movzbl  (%rax),     %eax
    cmpb    $10,        %al             # смотрим, что не конец строки

#   --------Условие выхода из цикла!
    je      No
    movb    $1,         -29(%rbp)
#       вторым указателем становимся на начало следующего слова
    
    scan_words_together:
#           сделали шаг первым словом, посмотрели что не пробел
            movq        -24(%rbp),      %rax
            movzbl      (%rax),         %eax
            cmpb        $32,            %al
            je          calc_res
#           шаг вторым словом, смтрим что не достигли пробела
            movq        -16(%rbp),      %rax
            movzbl      (%rax),         %eax
            cmpb        $32,            %al
            je          calc_res
            
            movzbl      -29(%rbp),      %edx
            movq        -24(%rbp),      %rax
            movzbl      (%rax),         %ecx
            movq        -16(%rbp),      %rax
            movzbl      (%rax),         %eax
            cmpb        %al,            %cl
            sete        %al
            movzbl      %al,            %eax
            andl        %edx,           %eax
            setne       %al            
            movb        %al,            -29(%rbp)
            movq        -24(%rbp),      %rax
# flag &= *ptr1 == *prt2_to_next_wrd            
            addq        $1,             %rax
            movq        %rax,           -24(%rbp)
            addq        $1,             -16(%rbp)
            jmp         scan_words_together

calc_res:
    movzbl  -29(%rbp),  %edx
# смотрим, что после пропуска букв оба слова стоят на пробеле
# если хотя бы одно не на пробеле, флагу присваиваем 0 (false)
# и идем дальше

    movq    -16(%rbp),  %rax
    movzbl  (%rax),     %eax
    cmpb    $32,        %al
    jne     set_bad_flag            # ушли сюда, если не закончилось слово 1

    movq    -24(%rbp),  %rax
    movzbl  (%rax),     %eax
    cmpb    $32,        %al
    jne     set_bad_flag            # ушли сюда, если не закончилось слово 2

    movl    $1,         %eax        # flag is ok
    jmp     resume_iter

set_bad_flag:                       
    movl    $0,         %eax
resume_iter:                               
    movzbl  %al,        %eax
    andl    %edx,       %eax
    testl   %eax,       %eax
    setne   %al

    movb    %al,        -29(%rbp)
    cmpb    $0,         -29(%rbp)
    je      skip_first_ptr_tail            
    movl    $1,         -28(%rbp)
    jmp     Yes                           
#   --------Условие выхода из цикла!
    skip_first_ptr_tail:                    
            addq        $1,         -16(%rbp)
            movq        -16(%rbp),  %rax
            subq        $1,         %rax
            movzbl      (%rax),     %eax
            cmpb        $32,        %al     # еще не достигли пробела?
            je          same_actions_for_second_ptr
            jmp         skip_first_ptr_tail

    same_actions_for_second_ptr:
            movq        -24(%rbp),  %rax
            addq        $1,         %rax
            movq        %rax,       -24(%rbp)
            movq        -24(%rbp),  %rax
            subq        $1,         %rax
            cmpb        $32,        %al
            je          infty_circle
            jmp         same_actions_for_second_ptr
            

No:
    movb    $0,     (%rsp)
    jmp quit_proc
Yes:
    movb    $1,     (%rsp)
quit_proc:
    mov     $1,     %rax
    mov     $1,     %rdi
    mov     %rsp,   %rsi
    mov     $1,     %rdx

    syscall
    ret


_start:
    lea   text, %rdi
    push  %rdi
    call  GET_TEXT    # rax = text size

    push  %rax        # text still in stack
    call  CHECK_TEXT  # rax = answer
    
    call EXIT
    
