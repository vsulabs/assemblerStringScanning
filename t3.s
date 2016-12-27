# дано предложение. Определить, если ли два одинаковых слова рядом
# использовать: строковые команды с префиксом повторения 

.data
length:
    .long 0
space:
    .string " "
zero:
    .string "0"
yes_text:
    .string "string has two similar words together"
.set yes_len, . - yes_text
no_text:
    .string "string does not contain two words together"
.set no_len, . - no_text
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

    lea     -1(%rsi), %rdi
    movb    $0x20, (%rdi)  # set space in the end
    movb    $10,   (%rsi)  # set EOL in the end

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
    pushq   %rbp
    movq    %rsp,   %rbp

#       ставим второй из указателей(rsi) на начало строки
    lea     (%rdi), %rsi

#       Второй будет идти впереди, и обязан проверять
#       что не конец строки
#       Пропускаем одно слово до пробела
    mov     space,  %ax
    repne   scasb
        
START_ALGORITHM:
#   Кладем в rax адрес текущего байта
    lea     (%rdi),  %rax
# Сравниваем с символом конца строки
    mov     (%rax),  %bl
    cmpb    $10,     %bl
    je      No

# Сохраняем начало одного слова для последующей проверки
# Т.к. инкремент происходит синхронно, проверять оба нет нужды
    pushq  %rdi

# Пропустить одинаковую часть слов
    repe cmpsb
# Если был достигнут конец слова, то были пропущены ещё и пробелы
# и первый символ слова
    dec  %rdi
    dec  %rsi

# Если указатель не сдвинулся
    popq    %rcx
    cmp     %rcx,   %rdi
    je      SKIP

# if rdi[i - 1] != ' ': goto SKIP;
    mov     -1(%rdi),  %bl
    cmp     space,   %bl
    jne     SKIP

# if rsi[i - 1] != ' ': goto SKIP;
    mov     -1(%rsi),  %bl
    cmp     space,   %bl
    jne     SKIP

# if rdi[i - 1] == ' ' && rsi[i - 1] == ' ': goto Yes:
    jmp     Yes

    SKIP:
        mov     space,  %ax
        cmpb    $0x20,  (%rdi)
        repne scasb

        pushq    %rdi
        mov     %rsi,  %rdi
        mov     space,  %ax
        cmpb    $0x20,  (%rdi)
        repne scasb
        mov     %rdi,  %rsi

        popq %rdi


    jmp START_ALGORITHM
    
No:
    mov     $no_text,  %rsi
    mov     $no_len,   %rdx
    jmp quit_proc
Yes:
    mov     $yes_text, %rsi
    mov     $yes_len,  %rdx

quit_proc:
    mov     $1,       %rax
    mov     $1,       %rdi
    syscall

    pop     %rbp
    ret


_start:
    lea   text, %rdi
    push  %rdi
    call  GET_TEXT    # rax = text size

    push  %rax        # text still in stack
    call  CHECK_TEXT  # rax = answer
    
    call EXIT
    
