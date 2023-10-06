format PE GUI 4.0
entry main
 
include 'win32ax.inc'
 
null equ ebx

;***************************************************************************************************
; ===========================================
; TEAM-STALKER
; STALKER XRAY PROJECT
; ===========================================
section '.data' data readable writeable

       string   db 'ABCDEF§12345••••••12345',0

section '.code' code readable executable
 
proc main
       stdcall XrayCheckASCII,string

       invoke  MessageBox,NULL,string,'check ascii encode',MB_OK
.exit:
       xor eax, eax
       invoke  ExitProcess, 0
endp
;***************************************************************************************************

;***************************************************************************************************
; Замена символов, которые не вошли в таблицу символов (кириллицы и латиницы) ASCII на _
; Вернет длину заменяемой строки
; Первый символ строки сделает заглавным
; --------------------------------------------------------------------------------------
proc XrayCheckASCII,pAddr
     push ebx ecx edx esi edi
     mov  esi,[pAddr]
     xor  ecx,ecx
     dec  esi
     dec  ecx
.check_ascii_loop:
     inc  esi
     inc  ecx
     movzx eax,byte [esi]
     cmp  al,0x0
     je   .check_ascii_ret
     cmp  ecx,0x100
     JAE  .add_terminator
     or   ecx, ecx
     je   .ToUpByte
.compare_eng:
     cmp  al,0x27
     JBE  .changebyte
     cmp  al,0x7E
     JBE  .check_ascii_loop
.compare_rus:
     cmp  al,0xC0
     JB   .changebyte
     cmp  al,0xFF
     JBE  .check_ascii_loop
.changebyte:
     mov  byte[esi],'_'
     jmp  .check_ascii_loop
.ToUpByte:
     cmp  al, 0x61
     JBE  .compare_eng
     cmp  al, 0x7A
     JBE  .sub_byte
     cmp  al, 0xE0
     JB   .compare_eng
.sub_byte:
     sub  eax, 0x20
     mov  byte[esi], al
     jmp  .check_ascii_loop
.add_terminator:
     mov  byte[esi],0
.check_ascii_ret:
     mov  eax,ecx
     pop  edi esi edx ecx ebx
     ret
endp
;***************************************************************************************************

;***************************************************************************************************************
section '.idata' import data readable writeable

  library kernel32,'KERNEL32.DLL',\
          user32,'user32.dll'

  include 'api/kernel32.inc'
  include 'api/user32.inc'
  ;***************************************************************************************************************
