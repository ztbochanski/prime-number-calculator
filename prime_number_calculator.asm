TITLE prime_number_calculator     (prime_number_calculator.asm)

; ------------------------------------------------------------------------
; Author: Zachary Bochanski
; Last Modified: 2021.07.13
; Description: This program demonstrates the use of implementing procedures, loops, nested loops, 
; and understanding validation through the functionality of a prime number calculator.
; It first prompts user to enter a number between 0 and 180. There is validation if it is out of range, 
; if the number is valid then it displays the prime numbers of the number the user chose.
; ------------------------------------------------------------------------


INCLUDE Irvine32.inc

; ------------------------------------------------------------------------
; DECLARE CONSTANTS - values to easily modify program
; ------------------------------------------------------------------------
MAX = 180
MIN = 1
NUMS_PER_LINE = 10


; ------------------------------------------------------------------------
; DATA SECTION - declare variable definitions
; ------------------------------------------------------------------------
.data
    ; introduction
    intro       BYTE    "Prime Numbers. Programmed by: zbochans",0
    direction1  BYTE    "Enter the number of prime numbers you would like to see.",0
    direction2  BYTE    "The limit is 180 primes.",0

    ; prompt and validation
    prompt      BYTE    "Enter the num offset primes to display [1, 180]: ",0
    errorMsg    BYTE    "No soup for you! Number out of bounds. Try again.",0

    ; goodby message
    outro       BYTE    "Results certified by zbochans. Goodby.",0

    ; user input and test value
    userNum     DWORD   ?
    candidate   DWORD   0

    ; results display
    spaces      BYTE    "   ",0
    primeCount  DWORD   0


; ------------------------------------------------------------------------
; CODE SECTION - instructions for logic here
; ------------------------------------------------------------------------
.code
main PROC
  CALL introduction     ; display name and directions

  CALL readData     ; get user entered infromation

  CALL showPrimes    ; find requested num of primes and display

  CALL goodBy    ; outro message

  Invoke ExitProcess,0    ; exit to operating system
main ENDP


; ------------------------------------------------------------------------
; Name: introduction
; 
; Description: Shows the programmer informatoin, program purpose, and directions.
;
; Preconditons: state of edx needs to accept intro, directions definitions
; 
; Postconditions: edx is changed but not part of return
; 
; Receives: intro, directions
;
; Returns: none
; 
; ------------------------------------------------------------------------
introduction PROC

    ; introduction phrase
    MOV     EDX, OFFSET intro
    CALL    WriteString
    CALL    CrLf
    CALL    CrLf

    ; directions
    MOV     EDX, OFFSET direction1
    CALL    WriteString
    CALL    CrLf
    MOV     EDX, OFFSET direction2
    CALL    WriteString
    CALL    CrLf
    CALL    CrLf
    RET

introduction ENDP


; ------------------------------------------------------------------------
; Name: readData
; 
; Description: Gets a valid number from the user by reading input and displying a prompt. 
; It continues to prompt until a valid input is detected.
;
; Preconditons: the user entered number, userNum, is in bounds.
; 
; Postconditions: edx, eax 
; 
; Receives: prompt, errorMsg, MAX_BOUND, MIN_BOUND
;
; Returns: none
; ------------------------------------------------------------------------
readData PROC

_GetInput:
    MOV     EDX, OFFSET prompt
    CALL    WriteString
    CALL    ReadDec
    MOV     userNum, EAX
    CMP     userNum, MIN
    JL      _Validate       ; jump to validate if less than
    CMP     userNum, MAX
    JG      _Validate       ; jump if greater than
    RET

_Validate:
    MOV     EDX, OFFSET errorMsg
    CALL    WriteString
    CALL    CrLf
    CALL    CrLf
    CALL    _GetInput
    RET

readData ENDP


; ------------------------------------------------------------------------
; Name: showPrimes
; 
; Description: Shows and displays all the primes the user requested including the user entered value. 
;   The requirements for display are 10 per line anda 3 spaces between numbers.
;
; Preconditons: EAX = candidateNum EBX = 0, ECX = userNum 
; 
; Postconditions: eax, ebx, ecx, edx
; 
; Receives: userNum
;
; Returns: none
; 
; ------------------------------------------------------------------------
showPrimes PROC
    MOV     ECX, userNum

_ForNumInUserRequest:
    
_WhileNotPrime:
    INC     candidate
    CALL    isPrime
    CMP     EBX, 0  ; if 0 then not prime, keep going
    JE      _WhileNotPrime

_CheckNewLine:
    MOV     EAX, primeCount
    MOV     EDX, 0
    MOV     EBX, NUMS_PER_LINE
    DIV     EBX
    CMP     EDX, 0
    JNE      _Print
    CALL    CrLf

_Print:
    INC     primeCount
    MOV     EAX, candidate
    CALL    WriteDec
    MOV     EDX, OFFSET spaces
    CALL    WriteString

    LOOP    _ForNumInUserRequest
    RET
showPrimes ENDP


; ------------------------------------------------------------------------
; Name: isPrime
; 
; Description: Returns true (1) if number is prime
;
; Preconditons: eax = candidateNum, edx = 0, ebx = 0
; 
; Postconditions: eax, ebx, ecx, edx
; 
; Receives: eax = number to check
;
; Returns: ebx = true (1) or false (0)
; 
; ------------------------------------------------------------------------
isPrime PROC
    PUSH    ECX
    MOV     EBX, 0             ; assume candidate is not prime
    MOV     EAX, candidate
    CMP     EAX, 1          ; primes are greater than 1
    JLE      _PrimeFalse

    CMP     EAX, 2          ; only even prime so edx will be 0 and falsely indicate 0 "not prime"
    JE      _PrimeTrue

    
    MOV     ECX, EAX
    DEC     ECX             ; index - 1 (to avoid getting remainder 0)
_CalculatePrimes:

    ; if ECX counter makes it to 1 then the candidate is prime
    MOV     EAX, candidate
    CMP     ECX, 1
    JE      _PrimeTrue

    ; divide candidate by ECX index, remainder == 0: is not prime
    MOV     EDX, 0
    DIV     ECX
    CMP     EDX, 0
    JE      _PrimeFalse
    


    LOOP    _CalculatePrimes

_PrimeFalse:
    JMP     _Finish

_PrimeTrue:
    MOV     EBX, 1
    JMP     _Finish

_Finish:
    POP     ECX
    RET
isPrime ENDP


; ------------------------------------------------------------------------
; Name: goodBy
; 
; Description: Displays the goodby message.
;
; Preconditons: edx = outro message
; 
; Postconditions: none
; 
; Receives: outro
;
; Returns: none
; 
; ------------------------------------------------------------------------
goodBy PROC
    CALL    CrLf
    CALL    CrLf
    MOV     EDX, OFFSET outro
    CALL    WriteString
    CALL    CrLf
    RET
goodBy ENDP


END main
