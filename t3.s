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
#   Кладем в rax адрес байта за текущим
    lea     (%rdi),  %rax
# Вычитаем 2 т.к. в конце мы будем за пробелом и переносом строки
    sub     $2,      %rax
    mov     (%rax),  %bl
    cmpb    $10,  %bl
    je      No

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
    
