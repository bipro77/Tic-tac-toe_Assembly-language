.MODEL SMALL
.STACK 100H
.DATA

grid db 31h,32h,33h,34h,35h,36h,37h,38h,39h
player db 0
win db 0
welcome db " Welcome to `Tic-Tac-Toe' Game !!$"
separator db " |---+---+---|$"
enterLoc db " Rule: You Can MOVe within Locations 1 to 9 .$"
turnMessageX db " Player 1's (X) turn, Which Position You Want to Choose?$"
turnMessageO db " Player 2's (O) turn, Which Position You Want to Choose?$"
tieMessage db "The Game Tied Between The Two Players!$"
winMessage db "Congratulations!! The Winner is player $"
inDigitError db " ERROR!, this place is taken$"
zeroError db " ERROR!, input is not a valid digit for the game$" 
line db " *-----------*$"      

space db " $"

; --------------------- CODE Segment START-------------------------
.CODE 





printString proc 

MOV ah, 09 
 
int 21h
ret 
 
 
 
 ;COLORLASTDIGIT
 
 
 printCharCOLOR PROC 
 	MOV BP, BX
 	;MOV DI,
 	mov di, cx 
 	    
	MOV AL,DL
	
	CMP AL,'X'
	JE L1 
	CMP AL,'O'
	JE L2     
	jmp L3
	
	
	L1:
	
    MOV AH, 9  	
	MOV BL, 10
	MOV CX,1
	INT 10H  
	mov dl,al   
	mov ah,2   
	int 21h
	JMP EXIT2
	
	L2:
	
	MOV AH, 9 
	MOV BL, 12
	MOV CX,1
	INT 10H  
	mov dl,al   
	mov ah,2   
	int 21h
	JMP EXIT2
	
	L3:
	
	MOV AH, 9 
	MOV BL, 14
	MOV CX,1
	INT 10H 
	mov dl,al   
	mov ah,2   
	int 21h
	JMP EXIT2

;	
	
	EXIT2:
 	MOV BX, BP
 	mov cx, di
 	
 	
 	RET

printString1 proc
	MOV BP,BX 
	mov di, cx
	MOV BL,14

MOV ah, 09 
MOV AL,0
MOV CX,90h
INT 10H

 
int 21h
mov cx, di 
MOV BX,BP 
ret

newLine proc
MOV DL,0DH ;
MOV AH,2
INT 21H
MOV DL,0AH
MOV AH,2
INT 21H
ret

printChar proc
	
MOV ah, 02
int 21h
ret

;////////////////////////////////////////////////////////////////////
printGrid:
LEA dx, line
call printString
call newLine

LEA bx, grid
MOV dx,[bx]
call printRow

LEA dx, separator
call printString
call newLine

call printRow
LEA dx, separator
call printString
call newLine

call printRow

LEA dx, line
call printString
call newLine
ret


printRow proc

;First Cell
MOV dl, ' '
call printChar
MOV dl, '|'
call printChar
MOV dl, ' '
call printChar
MOV dl, [bx]
call printCharCOLOR
MOV dl, ' '
call printChar
MOV dl, '|'
call printChar
inc bx

;Second Cell
MOV dl, ' '
call printChar
MOV dl, [bx]
call printCharCOLOR
MOV dl, ' '
call printChar
MOV dl, '|'
call printChar
inc bx

;Third Cell
MOV dl, ' '
call printChar
MOV dl, [bx]
call printCharCOLOR
MOV dl, ' '
call printChar
MOV dl, '|'
call printChar
inc bx

CALL newLine
ret

;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
getMOVe proc
MOV dl, ' '
call printChar
MOV dl, '='
call printChar
MOV dl, ' '
call printChar

MOV ah, 01
int 21h
call checkValidDigit
cmp ah, 1
je contCheckTaken
MOV dl, 0dh
call printChar
LEA dx, zeroError
call printString
LEA dx, newLine
call printString
jmp getMOVe

contCheckTaken proc ; Checks this: if(grid[al] > '9'), grid[al] == 'O' or 'X'
LEA bx, grid
sub al, 31h
MOV ah, 0
add bx, ax
MOV al, [bx]
cmp al, 39h
jng finishGetMOVe
MOV dl, 0dh
call printChar
LEA dx, inDigitError
call printString
CALL newLine

jmp getMOVe
finishGetMOVe:
CALL newLine

CALL newLine
ret

checkValidDigit proc
MOV ah, 0
cmp al, '1'
jl validDigit
cmp al, '9'
jg validDigit
MOV ah, 1
validDigit:
ret

;////////////////////////////////// Winning Check /////////////////////

checkWin proc
LEA si, grid
call checkDiagonal
cmp win, 1
je endCheckWin
call checkRows
cmp win, 1
je endCheckWin
call CheckColumns
endCheckWin:
ret

;-------------------------------------------;
checkDiagonal proc
;DiagonalLtR
MOV bx, si
MOV al, [bx]
add bx, 4    ;grid[0] ---> grid[4]
cmp al, [bx]
jne diagonalRtL
add bx, 4    ;grid[4] ---> grid[8]
cmp al, [bx]
jne diagonalRtL
MOV win, 1
ret

diagonalRtL proc
MOV bx, si
add bx, 2    ;grid[0] ---> grid[2]
MOV al, [bx]
add bx, 2    ;grid[2] ---> grid[4]
cmp al, [bx]
jne endCheckDiagonal
add bx, 2    ;grid[4] ---> grid[6]
cmp al, [bx]
jne endCheckDiagonal
MOV win, 1
endCheckDiagonal proc
ret

;-------------------------------------------;
checkRows proc
;firstRow
MOV bx, si; --->grid[0]
MOV al, [bx]
inc bx        ;grid[0] ---> grid[1]
cmp al, [bx]
jne secondRow
inc bx        ;grid[1] ---> grid[2]
cmp al, [bx]
jne secondRow
MOV win, 1
ret

secondRow proc
MOV bx, si; --->grid[0]
add bx, 3    ;grid[0] ---> grid[3]
MOV al, [bx]
inc bx    ;grid[3] ---> grid[4]
cmp al, [bx]
jne thirdRow
inc bx    ;grid[4] ---> grid[5]
cmp al, [bx]
jne thirdRow
MOV win, 1
ret

thirdRow proc
MOV bx, si; --->grid[0]
add bx, 6;grid[0] ---> grid[6]
MOV al, [bx]
inc bx    ;grid[6] ---> grid[7]
cmp al, [bx]
jne endCheckRows
inc bx    ;grid[7] ---> grid[8]
cmp al, [bx]
jne endCheckRows
MOV win, 1
endCheckRows proc
ret

;-------------------------------------------;
CheckColumns proc
;firstColumn
MOV bx, si; --->grid[0]
MOV al, [bx]
add bx, 3    ;grid[0] ---> grid[3]
cmp al, [bx]
jne secondColumn
add bx, 3    ;grid[3] ---> grid[6]
cmp al, [bx]
jne secondColumn
MOV win, 1
ret

secondColumn proc
MOV bx, si; --->grid[0]
inc bx    ;grid[0] ---> grid[1]
MOV al, [bx]
add bx, 3    ;grid[1] ---> grid[4]
cmp al, [bx]
jne thirdColumn
add bx, 3    ;grid[4] ---> grid[7]
cmp al, [bx]
jne thirdColumn
MOV win, 1
ret

thirdColumn proc
MOV bx, si; --->grid[0]
add bx, 2    ;grid[0] ---> grid[2]
MOV al, [bx]
add bx, 3    ;grid[2] ---> grid[5]
cmp al, [bx]
jne endCheckColumns
add bx, 3    ;grid[5] ---> grid[8]
cmp al, [bx]
jne endCheckColumns
MOV win, 1
endCheckColumns proc
ret            



; COLOR PRINT


printGrid1:
LEA dx, line
call printString1
call newLine

LEA bx, grid
;MOV dx,[bx]

call printRow1

LEA dx, separator
call printString1
call newLine

call printRow1
LEA dx, separator
call printString1
call newLine

call printRow1

LEA dx, line
call printString1
call newLine
ret


printRow1 proc

;First Cell
MOV dl, ' '
call printChar
MOV dl, '|'
call printChar
MOV dl, ' '
call printChar
MOV dl, [bx]
call printCharCOLOR
MOV dl, ' '
call printChar
MOV dl, '|'
call printChar
inc bx

;Second Cell
MOV dl, ' '
call printChar
MOV dl, [bx]
call printCharCOLOR
MOV dl, ' '
call printChar
MOV dl, '|'
call printChar
inc bx

;Third Cell
MOV dl, ' '
call printChar
MOV dl, [bx]
call printCharCOLOR
MOV dl, ' '
call printChar
MOV dl, '|'
call printChar
inc bx

CALL newLine
ret



;//////////////////////////////////////////////////////////////////
MAIN PROC
start:
MOV ax, @data
MOV ds, ax
MOV es, ax

MOV CX,9
LEA dx, welcome
call printString1
CALL newLine
LEA dx, enterLoc
call printString
CALL newLine
call newLine

gameLoop:
call printGrid
MOV al, player
cmp al, 1
CALL newLine
je p2turn
; previous player was 2
MOV player, 1
LEA dx, turnMessageX
call printString1
CALL newLine
jmp endPlayerSwitch
p2turn:; previous player was 1
MOV player, 2; 
LEA dx, turnMessageO
call printString
CALL newLine

endPlayerSwitch:
call getMOVe; bx will point to the right board postiton at the end of getMOVe
MOV dl, player
cmp dl, 1
jne p2MOVe
MOV dl, 'X'
jmp contMOVes
p2MOVe:
MOV dl, 'O'
contMOVes:
MOV [bx], dl
cmp cx, 5 ; no need to check before the 5th turn
jg noWinCheck
call checkWin
cmp win, 1
je won
noWinCheck:
loop gameLoop

;tie, cx = 0 at this point and no player has won

CALL newLine
call printGrid1
CALL newLine
LEA dx, tieMessage
call printString
JMP  EXIT

won:; current player has won
CALL newLine
call printGrid1
CALL newLine
CALL newLine
LEA dx, winMessage
call printString
MOV dl, player
add dl, 30H
call printChar
CALL newLine

EXIT:

MAIN ENDP
END MAIN



