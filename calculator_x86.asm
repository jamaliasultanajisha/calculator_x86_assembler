.MODEL SMALL

.DATA
    STR1 DB 0DH,0AH, "WELCOME to CALCULATOR v 1.0.$"
    STR2 DB 0DH,0AH, "Press a to add,s to substract and m to multiply $"
    STR3 DB 0DH,0AH, "Operation: $"
    STR4 DB 0DH, 0AH, "Enter first number: $"
    STR5 DB 0DH,0AH, "Enter second number: $"
    STR6 DB 0DH,0AH, "The summation is: $"
    STR7 DB 0DH,0AH, "The difference is: $"
    STR8 DB 0DH,0AH, "The multiplication is: $" 
    
    NUM1 DW ?
    NUM2 DW ?
    
    VAR1 DB ?
    VAR2 DB ?
    VAR3 DB ?  

.CODE

PUTC    MACRO   char
        PUSH    AX
        MOV     AL, char
        MOV     AH, 0Eh
        INT     10h     
        POP     AX
ENDM

MAIN PROC
    MOV AX,@DATA
    MOV DS,AX
    
    LEA DX,STR1
    MOV AH,9
    INT 21H
    
    MOV AH,2
    
    LEA DX,STR2
    MOV AH,9
    INT 21H
     
    MOV AH,2
    
    TOP: 
    LEA DX,STR3
    MOV AH,9
    INT 21H
     
    MOV AH,2
            
    MOV AH,1 
    INT 21h
    MOV BL,AL  
    
    CMP BL,'a'
    JE PLUS
    CMP BL,'s'
    JE MIN
    CMP BL,'m'
    JE MULT 
    CMP BL,'x'
    JE REALEND
    JMP END_IF
    
    PLUS:
    
    LEA DX,STR4
    MOV AH,9
    INT 21H
    
    MOV AH,2
            
   ; MOV AH,1
   ; INT 21h    
   ; SUB AL,30H
   ; MOV VAR1,AL  
   CALL SCAN_NUM
   
   MOV NUM1,CX
    
    LEA DX,STR5
    MOV AH,9
    INT 21H
    
    MOV AH,2
            
    ;MOV AH,1
    ;INT 21h   
    ;SUB AL,30H
    ;MOV VAR2,AL 
    CALL SCAN_NUM
   
    MOV NUM2,CX 
    
    LEA DX,STR6
    MOV AH,9
    INT 21H
    
    MOV AX,NUM1
    ADD AX,NUM2
    
    CALL PRINT_NUM
    
    ;ADD AL,VAR1
    ;MOV VAR3,AL
    ;MOV AH,0
    
    ;AAA
    ;ADD AH,30H
    ;ADD AL,30H
    ;MOV BX,AX
    
   ; MOV AH,2
   ; MOV DL,BH
   ; INT 21H
    
   ; MOV AH,2
   ; MOV DL,BL
   ; INT 21H '
    
    JMP END_IF
    
    MIN: 
    
    LEA DX,STR4
    MOV AH,9
    INT 21H
    
    MOV AH,2
            
   ; MOV AH,1
   ; INT 21h
   ; MOV CL,AL
    
    CALL SCAN_NUM
   
   MOV NUM1,CX
    
    LEA DX,STR5
    MOV AH,9
    INT 21H
    
    MOV AH,2
            
   ; MOV AH,1
   ; INT 21h
   ; MOV BH,AL
   
   CALL SCAN_NUM
   
   MOV NUM2,CX
    
    LEA DX,STR7
    MOV AH,9
    INT 21H
    MOV AH,2  
    
    ;CMP CL,BH
    ;JL ELSE
    
   ; SUB CL,BH
   ; ADD CL,48
    
    ;MOV AH,2
    ;MOV DL,CL
    ;INT 21H
      
    ;JMP END_IF
      
   ; ELSE:
    
    ;MOV AH,2
   ; MOV DL,'-'
    ;INT 21H
    MOV AH,2
    MOV DL,BH
    INT 21H
    
    MOV AX,2
     
    MOV AX,NUM1
    
    SUB AX,NUM2
    CALL PRINT_NUM
    
    MOV AH,2
    MOV DL,BH
    INT 21H
    
    JMP END_IF
    
    MULT:    
     
    LEA DX,STR4
    MOV AH,9
    INT 21H
    
    MOV AH,2
            
 ;   MOV AH,1
  ;  INT 21h 
   ; SUB AL,30H
    ;MOV VAR1,AL
    
    CALL SCAN_NUM
   
    MOV NUM1,CX 
    
    LEA DX,STR5
    MOV AH,9
    INT 21H
    
    MOV AH,2
    
    
    CALL SCAN_NUM
   
    MOV NUM2,CX
    
    LEA DX,STR8
    MOV AH,9
    INT 21H
    
    MOV AH,2
    
    MOV AX,NUM1
        
    IMUL NUM2 ;(DX AX)=AX*NUM2 
    
    CALL  PRINT_NUM
            
;    MOV AH,1
 ;   INT 21h
  ;  SUB AL,30H
   ; MOV VAR2,AL
    
;    MUL VAR1
    
 ;   MOV VAR3,AL 
    
  ;  AAM
   ; ADD AH,30H
    ;ADD AL,30H
;    MOV BX,AX
    
 ;   LEA DX,STR8
  ;  MOV AH,9
   ; INT 21H  
      
    ;MOV AH,2
;    MOV DL,BH
 ;   INT 21H 
    
  ;  MOV AH,2
   ; MOV DL,BL
    ;INT 21H
        
    END_IF:
    LOOP TOP      
    
    REALEND:
               
    MOV AH,4CH
    INT 21h
MAIN ENDP

SCAN_NUM        PROC    NEAR
        PUSH    DX
        PUSH    AX
        PUSH    SI
        
        MOV     CX, 0

        ; reset flag:
        MOV     CS:make_minus, 0

next_digit:

        ; get char from keyboard
        ; into AL:
        MOV     AH, 00h
        INT     16h
        ; and print it:
        MOV     AH, 0Eh
        INT     10h

        ; check for MINUS:
        CMP     AL, '-'
        JE      set_minus

        ; check for ENTER key:
        CMP     AL, 0Dh  ; carriage return?
        JNE     not_cr
        JMP     stop_input
not_cr:


        CMP     AL, 8                   ; 'BACKSPACE' pressed?
        JNE     backspace_checked
        MOV     DX, 0                   ; remove last digit by
        MOV     AX, CX                  ; division:
        DIV     CS:ten                  ; AX = DX:AX / 10 (DX-rem).
        MOV     CX, AX
        PUTC    ' '                     ; clear position.
        PUTC    8                       ; backspace again.
        JMP     next_digit
backspace_checked:


        ; allow only digits:
        CMP     AL, '0'
        JAE     ok_AE_0
        JMP     remove_not_digit
ok_AE_0:        
        CMP     AL, '9'
        JBE     ok_digit
remove_not_digit:       
        PUTC    8       ; backspace.
        PUTC    ' '     ; clear last entered not digit.
        PUTC    8       ; backspace again.        
        JMP     next_digit ; wait for next input.       
ok_digit:


        ; multiply CX by 10 (first time the result is zero)
        PUSH    AX
        MOV     AX, CX
        MUL     CS:ten                  ; DX:AX = AX*10
        MOV     CX, AX
        POP     AX

        ; check if the number is too big
        ; (result should be 16 bits)
        CMP     DX, 0
        JNE     too_big

        ; convert from ASCII code:
        SUB     AL, 30h

        ; add AL to CX:
        MOV     AH, 0
        MOV     DX, CX      ; backup, in case the result will be too big.
        ADD     CX, AX
        JC      too_big2    ; jump if the number is too big.

        JMP     next_digit

set_minus:
        MOV     CS:make_minus, 1
        JMP     next_digit

too_big2:
        MOV     CX, DX      ; restore the backuped value before add.
        MOV     DX, 0       ; DX was zero before backup!
too_big:
        MOV     AX, CX
        DIV     CS:ten  ; reverse last DX:AX = AX*10, make AX = DX:AX / 10
        MOV     CX, AX
        PUTC    8       ; backspace.
        PUTC    ' '     ; clear last entered digit.
        PUTC    8       ; backspace again.        
        JMP     next_digit ; wait for Enter/Backspace.
        
        
stop_input:
        ; check flag:
        CMP     CS:make_minus, 0
        JE      not_minus
        NEG     CX
not_minus:

        POP     SI
        POP     AX
        POP     DX
        RET
make_minus      DB      ?       ; used as a flag.
SCAN_NUM        ENDP





; this procedure prints number in AX,
; used with PRINT_NUM_UNS to print signed numbers:
PRINT_NUM       PROC    NEAR
        PUSH    DX
        PUSH    AX

        CMP     AX, 0
        JNZ     not_zero

        PUTC    '0'
        JMP     printed

not_zero:
        ; the check SIGN of AX,
        ; make absolute if it's negative:
        CMP     AX, 0
        JNS     positive
        NEG     AX

        PUTC    '-'

positive:
        CALL    PRINT_NUM_UNS
printed:
        POP     AX
        POP     DX
        RET
PRINT_NUM       ENDP



; this procedure prints out an unsigned
; number in AX (not just a single digit)
; allowed values are from 0 to 65535 (FFFF)
PRINT_NUM_UNS   PROC    NEAR
        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX

        ; flag to prevent printing zeros before number:
        MOV     CX, 1

        ; (result of "/ 10000" is always less or equal to 9).
        MOV     BX, 10000       ; 2710h - divider.

        ; AX is zero?
        CMP     AX, 0
        JZ      print_zero

begin_print:

        ; check divider (if zero go to end_print):
        CMP     BX,0
        JZ      end_print

        ; avoid printing zeros before number:
        CMP     CX, 0
        JE      calc
        ; if AX<BX then result of DIV will be zero:
        CMP     AX, BX
        JB      skip
calc:
        MOV     CX, 0   ; set flag.

        MOV     DX, 0
        DIV     BX      ; AX = DX:AX / BX   (DX=remainder).

        ; print last digit
        ; AH is always ZERO, so it's ignored
        ADD     AL, 30h    ; convert to ASCII code.
        PUTC    AL


        MOV     AX, DX  ; get remainder from last div.

skip:
        ; calculate BX=BX/10
        PUSH    AX
        MOV     DX, 0
        MOV     AX, BX
        DIV     CS:ten  ; AX = DX:AX / 10   (DX=remainder).
        MOV     BX, AX
        POP     AX

        JMP     begin_print
        
print_zero:
        PUTC    '0'
        
end_print:

        POP     DX
        POP     CX
        POP     BX
        POP     AX
        RET
PRINT_NUM_UNS   ENDP



ten             DW      10      ; used as multiplier/divider by SCAN_NUM & PRINT_NUM_UNS.







GET_STRING      PROC    NEAR
PUSH    AX
PUSH    CX
PUSH    DI
PUSH    DX

MOV     CX, 0                   ; char counter.

CMP     DX, 1                   ; buffer too small?
JBE     empty_buffer            ;

DEC     DX                      ; reserve space for last zero.


;============================
; Eternal loop to get
; and processes key presses:

wait_for_key:

MOV     AH, 0                   ; get pressed key.
INT     16h

CMP     AL, 0Dh                  ; 'RETURN' pressed?
JZ      exit_GET_STRING


CMP     AL, 8                   ; 'BACKSPACE' pressed?
JNE     add_to_buffer
JCXZ    wait_for_key            ; nothing to remove!
DEC     CX
DEC     DI
PUTC    8                       ; backspace.
PUTC    ' '                     ; clear position.
PUTC    8                       ; backspace again.
JMP     wait_for_key

add_to_buffer:

        CMP     CX, DX          ; buffer is full?
        JAE     wait_for_key    ; if so wait for 'BACKSPACE' or 'RETURN'...

        MOV     [DI], AL
        INC     DI
        INC     CX
        
        ; print the key:
        MOV     AH, 0Eh
        INT     10h

JMP     wait_for_key
;============================

exit_GET_STRING:

; terminate by null:
MOV     [DI], 0

empty_buffer:

POP     DX
POP     DI
POP     CX
POP     AX
RET
GET_STRING      ENDP


END MAIN
