
BITS 32
org 0x08048000
ehdr:
  db 0x7F, "ELF"          ; e_ident[4]
end:
  mov al, 4               ; al = 4
  xor bl, bl              ; bl(fileDescriptor) = stderr
  mov dl, 128             ; dl(bufferSize) = 128
  int 0x80                ; interrupt sys_write
  mov al, 1               ; al = 1
  int 0x80                ; interrupt sys_exit
  dw 2                    ; e_type = executable
  dw 3                    ; e_machine = x86
  dd 1                    ; e_version
  dd _start               ; e_entry
  dd phdr - $$            ; e_phoff
  dd 0                    ; e_shoff kind of unused
  dd 0                    ; e_flags !unused!
  dw ehdrsize             ; e_ehsize
  dw phdrsize             ; e_phentsize
  dw 1                    ; e_phnum
  file: db "/proc/version", 0
  ehdrsize equ $ - ehdr

phdr:
  dd 1                    ; p_type (PT_LOAD)
  dd 0                    ; p_offset
  dd $$                   ; p_vaddr
  dd 0                    ; p_paddr !unused!
  dd filesize             ; p_filesz
  dd filesize             ; p_memsz
  dd 7                    ; p_flags (read-write-execute)
  dd 0x1000               ; p_align (page size)
  phdrsize equ $ - phdr

string: db "probably a computer", 0, "there's probably some ram in there", 0, "init should ideally be running", 0, "yeah", 0, "you should probably go outside", 0, "i would be lead to believe that / is mounted", 0, "hey, what's this knob do?", 0, "i use arch btw", 0
_start:
  rdtsc                     ; timestamp -> edx:eax
  xor edx, edx              ; edx = 0
  mov edi, buf              ; edi = buf
  movzx edx, al             ; edx = edx
  and edx, 7                ; edx &= 7

  mov [edi], DWORD 0x203e0a ; buf = "\n> "
  mov esi, string           ; esi = string
  add edi, 3                ; buf += 3

scan:
  lodsb                     ; al = [esi++]
  cmp edx, 0                ; if divRemainder != 0
  jne copy                  ; goto copy
  stosb                     ; [edi++] = al

copy:
  test al, al               ; if al != 0
  jne next                  ; goto next
  dec edx                   ; divRemainder--

next:
  cmp al, 1                 ; if al != 1
  jne scan                  ; goto scan

  mov [edi], DWORD 0x203e0a ; buf = "\n> "
  add edi, 3                ; buf += 3

  mov eax, 5                ; al = 5
  mov ebx, file             ; ebx(fileName) = file
  xor ecx, ecx              ; ecx(accessMode) = 0
  int 0x80                  ; interrupt sys_open

  mov ebx, eax              ; ebx = fileHandle
  mov al, 3                 ; al = 3
  mov ecx, edi              ; ecx = buf
  mov edx, 35               ; edx(size) = 35
  int 0x80                  ; interrupt sys_read

find:
  inc edi                   ; buf++
  cmp byte [edi], '('       ; if *buf != '('
  jne find                  ; goto find

  mov [edi], DWORD 0x5F363878
  mov [edi + 4], DWORD 0x0A0A3436

  mov ecx, buf              ; ecx(buffer) = buf
  jmp end                   ; goto end

section .bss
buf: resb 32

filesize equ $ - $$
