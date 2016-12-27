едложение. Определить, сколько раз два соседних слова
# начинаются на одну букву
# Строковые команды с префиксом повторения (пропустить прбелы/слово)

.data
length:
    .long 0
space:
    .string " "
zero:
    .string "0"

.bss
text:
    .space 100

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
    mov     $100, %rdx     # count
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

    ret


_start:
    lea   text, %rdi
    push  %rdi
    call  GET_TEXT    # rax = text size

    push  %rax        # text still in stack
    call  CHECK_TEXT  # rax = answer
    add   $16, %rsp   # pop; pop;
    
    movb  (zero), %bl # rbx = '0'
    add   %bl, %al    # rbx += answer

    sub   $1, %rsp
    movb  %al, (%rsp)

    mov   $1, %rax    # write
    mov   $1, %rdi    # файловый дескриптор (1 == stdout)
    mov   %rsp, %rsi  # buf = rsp
    mov   $1, %rdx    # count = 2
    syscall

    call EXIT
