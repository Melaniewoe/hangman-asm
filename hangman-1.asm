;TITLE:  Hangman.asm
;A simple game of hangman.
;the rules of the game will be display in the window
;created :  11/1/2016
;Melanie Woe

INCLUDE Irvine32.inc

.data
;list of words that will be played
String0 BYTE "race", 0h
String1 BYTE "canoe", 0h
String2 BYTE "doberman", 0h
String3 BYTE "frame", 0h
String4 BYTE "hawse", 0h
String5 BYTE "orange", 0h
String6 BYTE "frigate", 0h
String7 BYTE "ketchup", 0h
String8 BYTE "postal", 0h
String9 BYTE "basket", 0h
String10 BYTE "cabinet", 0h
String11 BYTE "birch", 0h
String12 BYTE "machine", 0h
String13 BYTE "fiance", 0h

;size of the words
string0Size = LENGTHOF String0 - 1
string1Size = LENGTHOF String1 - 1
string2Size = LENGTHOF String2 - 1
string3Size = LENGTHOF String3 - 1
string4Size = LENGTHOF String4 - 1
string5Size = LENGTHOF String5 - 1
string6Size = LENGTHOF String6 - 1
string7Size = LENGTHOF String7 - 1
string8Size = LENGTHOF String8 - 1
string9Size = LENGTHOF String9 - 1
string10Size = LENGTHOF String10 - 1
string11Size = LENGTHOF String11 - 1
string12Size = LENGTHOF String12 - 1
string13Size = LENGTHOF String13 - 1
playMoreprompt BYTE "Do you wish to play again (Y/N)", 0
totPlay DWORD ?									;store the total game play
.code
MAIN PROC
call crlf
topGame:
;initialize all registers to 0
mov ECX, 0
mov EDX, 0
mov EAX, 0
mov ESI, 0
mov EBX, 0

call gameRule					;display the game's rule
call RandomString				;generate a random string (choose random string)
push ECX
mov ECX, 10						;10 chances of the game
play:
call userInput					; go to the userInput proc
cmp AL, 'Y'						; compare if al = y
je playAgainY					; if al = y, go to playAgainY
loop play
pop ECX

mov EBX, 1
playAgainY:
inc EBX
mov totPlay, EBX
jmp topGame						;if the user wants to play again, back to the top
pop EDX

exit
main ENDP

gameRule PROC USES EDX
;-------------------------------------------------------
; Display the game rules, disappear after the user enter any
; key
; Receives: nothing
; Return : nothing
; Requires: Nothing
;-------------------------------------------------------
.data
ruleStatement byte "~~~~~~~~~~~ Welcome to the Hangman Game ~~~~~~~~~~~" ,0h
ruleStatement1 byte "This hangman game has basic rules: " ,0h
ruleStatement2 byte "++ User will get 10 chances to guess the word", 0h
ruleStatement3 byte "++ User can choose to guess the word by letter or by whole word" ,0h
ruleStatement4 byte "++ At the end of the game user has to end it with guess by the whole word", 0h
ruleStatement5 byte "++ Users are allowed to enter a lower or uppercase letter / word", 0h
ruleStatement6 byte "ENJOY THE GAME!", 0h
.code
mov EDX, OFFSET ruleStatement
call WriteString
call crlf
mov EDX, OFFSET ruleStatement1
call WriteString
call crlf
mov EDX, OFFSET ruleStatement2
call WriteString
call crlf
mov EDX, OFFSET ruleStatement3
call WriteString
call crlf
mov EDX, OFFSET ruleStatement4
call WriteString
call crlf
mov EDX, OFFSET ruleStatement5
call WriteString
call crlf
mov EDX, OFFSET ruleStatement6
call WriteString
call crlf
call waitMsg
call clrscr						;clear the screen


RET
gameRule ENDP

userInput PROC
;-------------------------------------------------------
; Gets user input, letter or word
; call the matching proc
;
;Requires: Nothing
;-------------------------------------------------------
.data
promptUser byte "Do you wish to guess a letter or the whole word: (1 for letter 2 for word) ", 0
intVal DWORD ?
promptLetter BYTE "Guess a letter: ", 0

.code
push EDX
top:
mov EDX, OFFSET promptUser
call WriteString							;display the prompt on screen
pop EDX
call ReadInt								;read the user input
mov intVal, EAX								;move the userinput to intVal

cmp intVal, 2								;cmp intVal with 2
jne letterGuess								;if not equal jump to letterGuess
call wordMatching							;equal, go to wordMatching proc
call crlf
jmp finish

endGame:									;if the user doens't enter 1 or 2
jmp top										;ask the user enter the int 1 or 2

letterGuess:
cmp intVal, 1								;compare the intVal with 2
jne endGame									; if not equal, go to endGame
push EDX					
mov EDX, OFFSET promptLetter				;ask the user to enter a letter
call WriteString							;display the prompt
pop EDX
call letterMatching							;call the letterMatching proc
jmp finish

finish:
RET
userInput ENDP

RandomString PROC
;-------------------------------------------------------
;Display the underscores for the users
;generate the random number to choose the random string 
;return : the offset of string chosen in the esi, and number of loop in ecx
;-------------------------------------------------------
.data
randomNum DWORD ?
stringLength DWORD ?
word1 BYTE "Word =", 0
strUnderscore BYTE 20 DUP (?)
.code
call Randomize									;init random generator
call Random32
mov randomNum, EAX								;move the random number in EAX to RandNum

mov EDX, 0										;clear dividend
mov EAX, RandomNum
mov ECX, 14
div ECX											;EDX = the value of the string that will be chosen



; Compare the remainder in EDX to choose the string 
cmp EDX, 7								
jle chooseString0
jg chooseString8


chooseString0:
cmp EDX, 0
jne chooseString1
mov ECX, string0Size
mov ESI, OFFSET String0
jmp cont

chooseString1:
cmp EDX, 1
jne chooseString2
mov ECX, string1Size
mov ESI, OFFSET String1
jmp cont

chooseString2:
cmp EDX, 2
jne chooseString3
mov ECX, string2Size
mov ESI, OFFSET String2
jmp cont

chooseString3:
cmp EDX, 3
jne chooseString4
mov ECX, string3Size
mov ESI, OFFSET String3
jmp cont

chooseString4:
cmp EDX, 4
jne chooseString5
mov ECX, string4Size
mov ESI, OFFSET String4
jmp cont

chooseString5:
cmp EDX, 5
jne chooseString6
mov ECX, string5Size
mov ESI, OFFSET String5
jmp cont

chooseString6:
cmp EDX, 6
jne chooseString7
mov ECX, string6Size
mov ESI, OFFSET String6
jmp cont

chooseString7:
mov ECX, string7Size
mov ESI, OFFSET String7
jmp cont

chooseString8:
cmp EDX, 8
jne chooseString9
mov ECX, string8Size
mov ESI, OFFSET String8
jmp cont

chooseString9:
cmp EDX, 9
jne chooseString10
mov ECX, string9Size
mov ESI, OFFSET String9
jmp cont

chooseString10:
cmp EDX, 10
jne chooseString11
mov ECX, string10Size
mov ESI, OFFSET String10
jmp cont

chooseString11:
cmp EDX, 11
jne chooseString12
mov ECX, string11Size
mov ESI, OFFSET String11
jmp cont

chooseString12:
cmp EDX, 12
jne chooseString13
mov ECX, string12Size
mov ESI, OFFSET String12
jmp cont

chooseString13:
mov ECX, string13Size
mov ESI, OFFSET String13
jmp cont

cont:
;print the underscores based on the string
mov EDX, OFFSET word1						;mov word1 to EDX
call WriteString							;display the string
push ESI									;save ESI
mov ESI, OFFSET strUnderscore				;array of underscore in esi
L1:
mov BYTE PTR [ESI], '_'						;mov _ to array
inc ESI										;next 
loop L1										;loop
pop ESI
mov EDX, OFFSET strUnderscore				;mov the offset of underscore to EDX
call WriteString							;display the underscores
call crlf

RET
RandomString ENDP

WordMatching PROC USES ESI
;-------------------------------------------------------
;Compare the word entered by the user and the correct word
;Display correct if it is correct 
;receive: offset of string in ESI
;-------------------------------------------------------
.data
stringInput BYTE 21 dup (0)
wrongInput BYTE "That is incorrect - ", 0h
numRemain BYTE " guesses remaining", 0h
correctInput BYTE "That is correct. You win.", 0h
playAgain1 BYTE "Do you wish to play again (Y/N)", 0h
inputSize = 20
promptWord BYTE "Guess the word: ", 0h
byteCount DWORD ?
totalPlay BYTE "Total game played :", 0h
.code
mov EDX, OFFSET promptWord						;ask the user to enter a word
call WriteString								;display the prompt
push EDX
push ECX
mov EDX, OFFSET stringInput						;store the stringinput by user
mov ECX, inputSize								;the size of the user's input
call readString									;read the user input
mov byteCount, EAX								;num of characters
mov ECX, EAX
push EDX
LowerCase:
or BYTE PTR [EDX], 00100000b					;clear bit 5, lowercase letters
inc EDX
loop LowerCase
pop EDX
pop ECX
loopWord:
mov AL, [ESI]									;mov the string of game to AL
mov BL, [EDX]									;mov user's letter to BL
cmp AL, 0										;cmp AL with 0
jne loopWord2									;not 0, continue
cmp BL, 0										;cmp BL with 0
jne loopWord2									;not 0, continue
jmp loopWord4									;if 0, end

loopWord2:
inc ESI											;point to the next
inc EDX											;point to next element
cmp AL, BL										;is the letter equals?
je loopWord										;IF EQUAL loop again
jne loopWord3									;not equal go out
	

loopWord3:	
mov EDX, OFFSET wrongInput						;display wrong input	
call WriteString
push EAX										;save registers EAX and ECX
push ECX
dec ECX											;loop -1
mov EAX, ECX									
call WriteDec									;total chances remaining
pop ECX
pop EAX											;pop the registers back
mov EDX, OFFSET numRemain
call WriteString
call crlf
jmp WordFinish

loopWord4:
mov EDX, OFFSET correctInput					;display correct input
call WriteString
call crlf
jmp wordAgain

wordAgain:
mov EDX, OFFSET playAgain1						;ask the user if they want to play again
call WriteString
call readChar	
cmp AL, 'Y'
je WordFinish
jmp WordFinish1

WordFinish1:
call crlf
mov EDX, OFFSET totalPlay
call WriteString
mov EAX, totPlay
call WriteDec
call waitmsg
EXIT 

WordFinish:
pop EDX
RET
WordMatching ENDP


letterMatching PROC USES EDI ESI
;-------------------------------------------------------
;Compare the letter entered by the user and the correct letter
;Display correct if it is correct 
;receive: the offset of string chosen in esi
;-------------------------------------------------------
.data
charInput BYTE ?
arrayHangman BYTE 20 DUP (?)					;will store the _ and letter
.code
top:
call ReadChar									;read the user input
mov EDI, OFFSET arrayHangman
loopLetter:
or AL, 00100000b								;change to lowercase if needed
mov charInput, AL								;mov userinput to AL
mov AL, charInput
mov BL, [ESI]									;mov the game's string to BL
cmp BL, 0										;is it the end of the string?
jne loopLetter2									;if not 0, continue
jmp loopL

loopLetter2:
inc ESI											;point to the next
cmp AL, BL										;is the letter equals?
jne loopLetter4									;not equal, jump to loop letter
je loopLetter3									; equal, jump to loopLetter3

loopLetter3:
push AX
mov BYTE PTR [EDI], AL							;if equal display the letter				
inc EDI											;next element
pop AX
jmp loopLetter									;jump back to the loopLetter


loopLetter4:
mov DL, BYTE PTR [EDI]							;if not equal, mov _ to the array
cmp DL, '_'	
jne loopLettercont
cont:
mov BYTE PTR [EDI], '_'
inc EDI
jmp loopLetter

loopLettercont:
cmp DL, 0
je cont
cmp DL, BL
jne cont
inc EDI
jmp loopLetter

pop EDI

loopL:
push EDX
mov EDX, OFFSET arrayHangman						;display the array
call WriteString
call crlf
pop EDX
jmp ldone1

ldone1:
RET
letterMatching ENDP

END MAIN