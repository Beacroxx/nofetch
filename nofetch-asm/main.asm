BITS 32
org 0x08048000
ehdr:
  db 0x7F, "ELF"          ; e_ident[4]
end:
  mov al, 4               ; al = 4
  xor bl, bl
  mov dl, 96              ; dl(bufferSize) = 96
  int 0x80                ; interrupt sys_write
  mov al, 1               ; al = 1
  int 0x80                ; interrupt sys_exit
  dw 2                    ; e_type = executable
  dw 3                    ; e_machine = x86
  dd 1                    ; e_version
  dd _start               ; e_entry
  dd phdr - $$            ; e_phoff
file: db "/versio", 0       ; file
  dw ehdrsize             ; e_ehsize
  dw phdrsize             ; e_phentsize
  dw 1                    ; e_phnum
  ehdrsize equ $ - ehdr
phdr:

  dd 1
  dd 0                    ; p_offset
  dd $$                   ; p_vaddr
  dd 0                    ; p_paddr !unused!
  dd filesize             ; p_filesz
  dd filesize             ; p_memsz
  dd 7                    ; p_flags (read-write-execute)
  dd 0x1000               ; p_align (page size)
  phdrsize equ $ - phdr

_start:
  rdtsc                   ; timestamp -> edx:eax
  mov edi, buf            ; edi = buf
  push edi                ; push buf address to stack
  mov dl, al              ; dl = al
  and dl, 7               ; dl &= 7

  mov eax, 0x203e0a       ; eax = "\n> "
  push eax                ; push the prompt to stack
  stosd                   ; *edi++ = eax
  mov esi, string         ; esi = string

loop:
  lodsb                   ; al = *esi++
  test dl, dl             ; if dl != 0
  jne no_store            ; goto no_store
  stosb                   ; *edi++ = al
no_store:
  test al, al             ; if al != 0
  jne check               ; goto check
  dec edx                 ; edx--
check:
  cmp al, 1               ; if al != 1
  jne loop                ; goto loop

  pop eax                 ; pop the prompt from stack
  stosd                   ; *edi++ = eax

  mov eax, 5              ; eax = 5
  mov ebx, file           ; ebx(fileName) = file
  xor ecx, ecx            ; ecx(accessMode) = 0
  int 0x80                ; interrupt sys_open

  mov ebx, eax            ; ebx = fileHandle
  mov al, 3               ; al = 3
  mov ecx, edi            ; ecx = buf
  mov edx, 48             ; edx(size) = 48
  int 0x80                ; interrupt sys_read

find:
  inc edi                 ; edi++
  cmp byte [edi], '('     ; if *buf != '('
  jne find                ; goto find

  mov [edi], DWORD 0x5F363878
  mov [edi + 4], DWORD 0x0A0A3436

  pop ecx                 ; pop buf address from stack
  jmp end                 ; goto end

  string: db "Segmentation fault (core dumped)", 0, "I ate the ram", 0, "Stole your kernel", 0, "yeah", 0, "You should touch grass", 0, "Where did / go?", 0, "Hey, what's this knob do?", 0, "I use arch btw", 1

section .bss
buf: resb 32

filesize equ $ - $$
