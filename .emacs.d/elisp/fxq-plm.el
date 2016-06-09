;;; plm-mode-el -- Major mode for editing PL/M files
;; Copyright (C) 2010 Nokia Siemens Networks

;; Author: Ma Jijun Kim<jijun.ma@nsn.com>
;; Maintainer: 
;; Created: 1 Sept. 2010
;; Version: pre-1.0.0
;; Keywords: languages, pl/m
;;
;; $Id$

;; This file is not part of GNU Emacs.

;;; Commentary:
;; This is for "Nokia-PL/M".
;; This is not an officially supported tool.
;; Comment it on NWiki:

;;; History:
;; Inherits from http://www.emacswiki.org/cgi-bin/wiki/SampleMode

;;; Quotes:
;; Values produce value

;;; Known issues:
;; indentation is not working...

;;; Todos:
;; Make indentation work for PL/M

;;; Done:
;; syntax highlighting for PL/M

;;; NOT to DOs:


;;(defvar plm-mode-hook nil)
(defvar plm-mode-hook t)
(defvar plm-mode-map
  (let ((plm-mode-map (make-keymap)))
    (define-key plm-mode-map "\C-j" 'newline-and-indent)
    plm-mode-map)
  "Keymap for PL/M major mode")

(add-to-list 'auto-mode-alist '("\\.p86\\'" . plm-mode))
(add-to-list 'auto-mode-alist '("\\.p38\\'" . plm-mode))
(add-to-list 'auto-mode-alist '("\\.pin\\'" . plm-mode))
(add-to-list 'auto-mode-alist '("\\.pex\\'" . plm-mode))
(add-to-list 'auto-mode-alist '("\\.pii\\'" . plm-mode))
(add-to-list 'auto-mode-alist '("\\.pli\\'" . plm-mode))
(add-to-list 'auto-mode-alist '("\\.pdt\\'" . plm-mode))
(add-to-list 'auto-mode-alist '("\\.ain\\'" . plm-mode))
(add-to-list 'auto-mode-alist '("\\.pva\\'" . plm-mode))

(defconst plm-font-lock-keywords-1
  (list
   ;; These define the beginning and end of each PL/M entity definition
   ;; "DATA"
   '("\\<\\(=\\)\\>" . font-lock-builtin-face)
   '("\\('\\w*'\\)" . font-lock-variable-name-face))
  "Minimal highlighting expressions for PL/M mode.")

(defconst plm-font-lock-keywords-2
  (append plm-font-lock-keywords-1
	  (list
	   ;; These are some possible attributes of WPDL entities
       ;; "DECLARE" "DO" "THENDO" "OD" "IF" "ELSEIF" "ELSEDO" "FI" 
       ;; 	      "CASE" "ESAC" "WHILE" "THEN" "CALL" "RETURN" "FUNCTION" "PROCEDURE" "STRUCTURE" "DATA"
       ;; 	      "END" "AND" "OR" "XOR" "NOT" "EQU" "BASED" "LITERALLY"
       
	   '("\\<\\(AND\\|BASED\\|CA\\(?:LL\\|SE\\)\\|D\\(?:ATA\\|ECLARE\\|O\\)\\|E\\(?:LSE\\(?:DO\\|IF\\)\\|ND\\|QU\\|SAC\\)\\|F\\(?:I\\|UNCTION\\)\\|IF\\|LITERALLY\\|NOT\\|O[DR]\\|PROCEDURE\\|RETURN\\|STRUCTURE\\|THEN\\(?:DO\\)?\\|WHILE\\|XOR\\)\\>" . font-lock-keyword-face)
	   '("\\<\\(TRUE\\|FALSE\\|OK\\|NOK\\|NIL\\)\\>" . font-lock-constant-face)
	   '("^\\$\\w*" . font-lock-preprocessor-face)))
  "Additional Keywords to highlight in WPDL mode.")

(defconst plm-font-lock-keywords-3
  (append plm-font-lock-keywords-2
	  (list
	   ;; These are some possible built-in types for PL/M attributes
	   '("\\<\\(B\\(OOLEAN\\|YTE\\)\\|DWORD\\|SELECTOR\\|OFFSET\\|PUBLIC\\|POINTER\\|REENTRANT\\|INTERNAL\\|WORD\\)\\>" . font-lock-constant-face)))
  "Balls-out highlighting in PL/M mode.")

(defvar plm-font-lock-keywords plm-font-lock-keywords-3
  "Default highlighting expressions for PL/M mode.")


(defvar plm-indent 4
  "Default PL/M indent level.")

(defun plm-tab ()
  "Indent to next tab stop."
  (interactive)
  (indent-to (* (1+ (/ (current-column) plm-indent)) 
		plm-indent)))

(defvar plm-mode-syntax-table
  (let ((plm-mode-syntax-table (make-syntax-table)))
    ;; This is added so entity names with underscores can be more easily parsed
	(modify-syntax-entry ?_ "w" plm-mode-syntax-table)
	;; Comment styles are same as C++
	(modify-syntax-entry ?@ "." plm-mode-syntax-table)
	(modify-syntax-entry ?. "." plm-mode-syntax-table)
	(modify-syntax-entry ?/ ". 14" plm-mode-syntax-table)
	(modify-syntax-entry ?* ". 23" plm-mode-syntax-table)
	(modify-syntax-entry ?+ "." plm-mode-syntax-table)
	(modify-syntax-entry ?- "." plm-mode-syntax-table)
	(modify-syntax-entry ?= "." plm-mode-syntax-table)
	(modify-syntax-entry ?% "." plm-mode-syntax-table)
	(modify-syntax-entry ?< "." plm-mode-syntax-table)
	(modify-syntax-entry ?> "." plm-mode-syntax-table)
	(modify-syntax-entry ?\' "\"" plm-mode-syntax-table)
	(modify-syntax-entry ?/ ". 124b" plm-mode-syntax-table)
	(modify-syntax-entry ?* ". 23" plm-mode-syntax-table)
	(modify-syntax-entry ?\n "> b" plm-mode-syntax-table)
	plm-mode-syntax-table)
  "Syntax table for plm-mode")
  
(defvar plm-mode-map ()
  "Keymap used in PL/M mode.")

(if plm-mode-map ()
  (let ((map (make-sparse-keymap)))
    (define-key map "\^i" 'plm-tab)
    (setq plm-mode-map map)
    ))

(defun plm-mode ()
  (interactive)
  (kill-all-local-variables)
  (use-local-map plm-mode-map)
  (set-syntax-table plm-mode-syntax-table)
  ;; Set up font-lock
  (set (make-local-variable 'font-lock-defaults) '(plm-font-lock-keywords))
  ;; Register our indentation function
  ;;(set (make-local-variable 'indent-line-function) 'plm-indent-line)  
  (setq indent-tabs-mode nil)
  (setq major-mode 'plm-mode)
  (setq mode-name "PL/M")
  (run-hooks 'plm-mode-hook))

(provide 'plm-mode)
;;; plm-mode.el ends here
