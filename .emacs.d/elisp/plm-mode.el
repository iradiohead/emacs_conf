;;; plm-mode-el -- Major mode for editing PL/M files

;; Author: Peter Vaczi <peter.vaczi@nsn.com>

;;; Code:
(defvar plm-mode-hook nil)
(defvar plm-mode-map
  (let ((plm-mode-map (make-keymap)))
    (define-key plm-mode-map "\C-j" 'newline-and-indent)
    plm-mode-map)
  "Keymap for PLM major mode")

(add-to-list 'auto-mode-alist '("\\.plm\\'" . plm-mode))
(add-to-list 'auto-mode-alist '("\\.p86\\'" . plm-mode))
(add-to-list 'auto-mode-alist '("\\.p38\\'" . plm-mode))
(add-to-list 'auto-mode-alist '("\\.pin\\'" . plm-mode))
(add-to-list 'auto-mode-alist '("\\.pex\\'" . plm-mode))
(add-to-list 'auto-mode-alist '("\\.pii\\'" . plm-mode))
(add-to-list 'auto-mode-alist '("\\.pli\\'" . plm-mode))
(add-to-list 'auto-mode-alist '("\\.pdt\\'" . plm-mode))
(add-to-list 'auto-mode-alist '("\\.ain\\'" . plm-mode))
(add-to-list 'auto-mode-alist '("\\.pva\\'" . plm-mode))

;; (regexp-opt '("AND" "AT" "BASED" "BY" "BYTE" "CALL" "CASE" "CHARINT" "DATA" "DECLARE" "DO" "DWORD" "ELSE" "END" "EXTERNAL" "GO" "GOTO" "HWORD" "IF" "INITIAL" "INTEGER" "INTERRUPT" "LABEL" "LITERALLY" "LONGINT" "MINUS" "MOD" "NOT" "OFFSET" "OR" "PLUS" "POINTER" "PROCEDURE" "PUBLIC" "QWORD" "REAL" "REENTRANT" "RETURN" "SELECTOR" "SHORTINT" "STRUCTURE" "TESTCASE" "THEN" "TO" "WHILE" "WORD" "XOR") t)

(defconst plm-font-lock-keywords
  (list
   '( "\\<\\(AND\\|AT\\|BASED\\|BYTE\\|BY\\|CALL\\|CASE\\|CHARINT\\|DATA\\|DECLARE\\|DO\\|DWORD\\|ELSE\\|END\\|EXTERNAL\\|GO\\|GOTO\\|HWORD\\|IF\\|INITIAL\\|INTEGER\\|INTERRUPT\\|LABEL\\|LITERALLY\\|LONGINT\\|MINUS\\|MOD\\|NOT\\|OFFSET\\|OR\\|PLUS\\|POINTER\\|PROCEDURE\\|PUBLIC\\|QWORD\\|REAL\\|REENTRANT\\|RETURN\\|SELECTOR\\|SHORTINT\\|STRUCTURE\\|TESTCASE\\|THEN\\|TO\\|WHILE\\|WORD\\|XOR\\)\\>" . font-lock-builtin-face)
                                        ;font-lock-keyword-face
   '("\\[0-9\\]\\[0-9a-fA-FhHqQ\\]*" . font-lock-constant-face)
   '("\\(\\w*\\)" . font-lock-variable-name-face)
   )
  "Minimal highlighting expressions for PLM mode.")

(defun plm-indent-line ()
  "Indent current line as PLM code."
  (interactive)
  (beginning-of-line)
  (if (bobp)
      (indent-line-to 0)		   ; First line is always non-indented
    (let ((not-indented t) cur-indent)
      (if (looking-at ".*\\<END\\>") ; If the line we are looking at is the end of a block, then decrease the indentation
          (progn
            (save-excursion
              (forward-line -1)
              (setq cur-indent (- (current-indentation) default-tab-width)))
            (if (< cur-indent 0) ; We can't indent past the left margin
                (setq cur-indent 0)))
        (if (looking-at "^[ \t]*\\$")
            (setq cur-indent 0)
        (save-excursion
          (while not-indented ; Iterate backwards until we find an indentation hint
            (forward-line -1)
            (if (looking-at ".*\\<END\\>") ; This hint indicates that we need to indent at the level of the END token
                (progn
                  (setq cur-indent (current-indentation))
                  (setq not-indented nil))
              (if (looking-at ".*\\<\\(DO\\|PROCEDURE\\|TESTCASE\\)\\>") ; This hint indicates that we need to indent an extra level
                  (progn
                    (setq cur-indent (+ (current-indentation) default-tab-width)) ; Do the actual indenting
                    (setq not-indented nil))
                (if (bobp)
                    (setq not-indented nil))))))))
      (if cur-indent
          (indent-line-to cur-indent)
        (indent-line-to 0))))) ; If we didn't see an indentation hint, then allow no indentation

(defvar plm-mode-syntax-table
  (let ((plm-mode-syntax-table (make-syntax-table)))
	
    ; This is added so entity names with underscores can be more easily parsed
	(modify-syntax-entry ?_ "w" plm-mode-syntax-table)
	(modify-syntax-entry ?$ "w" plm-mode-syntax-table)
	
	; Comment styles are same as C++
	(modify-syntax-entry ?/ ". 124b" plm-mode-syntax-table)
	(modify-syntax-entry ?* ". 23" plm-mode-syntax-table)
	(modify-syntax-entry ?\n "> b" plm-mode-syntax-table)
	plm-mode-syntax-table)
  "Syntax table for plm-mode")
  
(defun plm-mode ()
  (interactive)
  (kill-all-local-variables)
  (use-local-map plm-mode-map)
  (set-syntax-table plm-mode-syntax-table)
  ;; Set up font-lock
  (set (make-local-variable 'font-lock-defaults) '(plm-font-lock-keywords))
  ;; Register our indentation function
  (set (make-local-variable 'indent-line-function) 'plm-indent-line)  
  (setq major-mode 'plm-mode)
  (setq mode-name "PLM")
  (run-hooks 'plm-mode-hook))

(provide 'plm-mode)

;;; plm-mode.el ends here
