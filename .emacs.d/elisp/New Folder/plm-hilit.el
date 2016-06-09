;; PL/M 386 hilit mode

;; Define the patters and symbols for hilit pattern generator.  The
;; patterns are used "as is".  The symbols need word delimiters
;; before use.  Data rules, ok?

(require 'hilit19)

(put 'plm-hilit 'comment '(("/\\*" "\\*/" comment)))
			    
(put 'plm-hilit 'include '(("^$.*$" 0 include))) ;use "as is"

(put 'plm-hilit 'defun '(
CASE
DO
ELSE
END
IF
PROCEDURE
THEN
WHILE
STRUCTURE


; DXSLITGX.INC
THENDO
ELSEDO
ELSEIF
FI
OD
ESAC
FUNCTION
))


(put 'plm-hilit 'define 
'(	;"sym2str" generate
DECLARE
))


(put 'plm-hilit 'type '(		;"sym2str" generate
))


(put 'plm-hilit 'keyword '(		;"sym2str" generate
;	1. The reserved words in PLM386
;	1. PLM386 -kielen varatut sanat
;##LANG PLM386


ADDRESS
AND
AT

BASED
BY
BYTE

CALL
;CASE
CHARINT

DATA
;DECLARE
DISABLE

;DO
DWORD
;ELSE

ENABLE
;END
EOF

EXTERNAL
GO
GOTO

HALT
HWORD
;IF

INITIAL
INTEGER
INTERRUPT

LABEL
LITERALLY
LONGINT

MINUS
MOD
NOT

OFFSET
OR
PLUS

POINTER
;PROCEDURE
PUBLIC

QWORD
REAL
REENTRANT

RETURN
SELECTOR
SHORTINT

;STRUCTURE
;THEN
TO

;WHILE
WORD
XOR

;    The following enumerates the predefined subroutines and variables.
;    If one (or more) of them is redeclared in a PLM386 -program, the
;    previous declaration is suppressed in scope of the new
;    declaration.

;    Seuraavassa listassa on lueteltu ennalta   m{{riteltyjen aliohjelmien
;    ja muuttujien tunnukset. Mik{li jokin n{ist{ tunnuksista m{{ritell{{n
;    uudelleen  PLM386-ohjelmassa, poistuu vastaava ennalta m{{ritelty  a-
;    liohjelma tai muuttuja k{yt|st{ kyseisen m{{rittelyn vaikutusalueessa.

;##LANG PLM386(intr)

ABS
ADJUSTRPL
BLOCKINPUT

BLOCKINDWORD
BLOCKINWORD
BLOCKOUTPUT

BLOCKOUTDWORD
BLOCKOUTWORD
BUILDPTR

CARRY
CAUSEINTERRUPT
CLEARTASKSWITCHEDFLAG

CMPB
CMPD
CMPW

CONTROLREGISTER
DEBUGREGISTER
DEC

DOUBLE
FINDB
FINDD

FINDHW
FINDRB
FINDRD

FINDRHW
FINDRW
FINDW

FIX
FLAGS
FLOAT

GETACCESSRIGHTS
GETREALERROR
GETSEGMENTLIMIT

HIGH
IABS
INDWORD

INHWORD
INITREALMATHUNIT
INPUT

INT

;##LANG PLM86(intr)
INTERRUPT
;##LANG PLM386(intr)
INWORD

LAST
LENGTH
LOCALTABLE

LOCKSET
LOW
MACHINESTATUS

MOVB
MOVBIT
MOVD
MOVE

MOVHW
MOVRB
MOVRBIT

MOVRD
MOVRHW
MOVRW

MOVW
NIL
OFFSETOF

OUTDWORD
OUTHWORD
OUTPUT

OUTWORD
PARITY
RESTOREGLOBALTABLE

RESTOREINTERRUPTTABLE
RESTOREREALSTATUS
ROL

ROR
SAL
SAR

SAVEGLOBALTABLE
SAVEINTERRUPTTABLE
SAVEREALSTATUS

SCANBIT
SCANRBIT
SCL

SCR
SEGMENTREADABLE
SEGMENTWRITABLE

SELECTOROF
SETB
SETD

SETHW
;##LANG PLM86(intr)
SETINTERRUPT
;##LANG PLM386(intr)
SETREALMODE
SETW

SHL
SHLD
SHR

SHRD
SIGN
SIGNED

SIZE
SKIPB
SKIPD

SKIPHW
SKIPRB
SKIPRD

SKIPRHW
SKIPRW
SKIPW

STACKBASE
STACKPTR
TASKREGISTER

TESTREGISTER
TIME
UNSIGN

WAITFORINTERRUPT
XLAT
ZERO

; DXSLITGX.INC
FOREVER
INTERNAL
SUCCESS
BOOL
T
F
CHARACTER_T
BOOLEAN
TRUE
FALSE
VAGUE
BYTEPOINTER
DURATION
pid
))

;; Generate the hilit patterns.
(defun plm-hilit-generate (list type)
  "Generate the hilit patterns for the symbols in the LIST.  Each
pattern shall get the hilit tag TYPE."
  (list (concat "\\<\\(" (mapconcat (function (lambda (sym)
						(symbol-name sym)))
				    list "\\|")
 		"\\)\\>") 0 type))


(defconst plm-hilit-pattern
  (append (list 'plm-mode 'case-sensitive)
	  (get 'plm-hilit 'comment)
	  (get 'plm-hilit 'include)
	  (mapcar (function (lambda (type)
			      (plm-hilit-generate (get
						   'plm-hilit type)
						  type)))
		  '(define type keyword))
	  (mapcar (function (lambda (type)
			      (plm-hilit-generate (get
						   'plm-hilit type)
						  type)))
		  '(define type defun))))


(setq hilit-patterns-alist (cons plm-hilit-pattern
				 hilit-patterns-alist))

(provide 'plm-hilit)

