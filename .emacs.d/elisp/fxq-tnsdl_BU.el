;;; tnsdl.el --- major mode for TNSDL development

;; Copyright (C) 2007 Nokia Siemens Networks

;; Author: Peter Tury
;; Maintainer: Erkki Ruohtula
;; Created: 17 April 2007
;; Version: pre-2.0.2
;; Keywords: languages, tnsdl
;;
;; $Id: tnsdl.el 4 2008-08-26 08:08:14Z ruohtula $

;; This file is not part of GNU Emacs.

;;; Commentary:
;; This is for "Nokia-SDL".
;; This is not an officially supported tool.
;; Comment it on NWiki:

;;; History:
;; This file is a successor of previous tnsdl-modes.
;; Creators of those ancestors:
;;    Harri Mäenpää
;;    Toni Arte
;;    Tero Venetjoki
;; Inherits also from http://www.emacswiki.org/cgi-bin/wiki/SampleMode,
;;                    http://two-wugs.net/emacs/mode-tutorial.html, ...

;;; Quotes:
;; (From http://www-pu.informatik.uni-tuebingen.de/users/klaeren/epigrams.html)
;; For the current state of this file: "Simplicity does not precede complexity, but follows it."

;;; Known issues:
;; Multiline string constants doesn't handled. (Are they valid in TNSDL at all? --> No.)

;;; Todos:
;; * add `tnsdl-mark-defun', `tnsdl-mark-sexp'...
;; * finish indent-region...
;; * create documentation (texi, .html, ...)
;; * all skip commands (e.g. tnsdl-goto-...) should set a mark to make "go-back" possible (c.f. pop-tag-mark)
;; * add support for automatically filtering out (=hide) lines (based on regexps) from *compilation* buffer 
;; * Check what should be inside `define-derived-mode' and what should be outside.
;; * check what should be `interactive' and what not...
;; * add mode documentation (for C-h m)
;; * add abbrevs -- isn't `dabbrev-expand' enough?
;; * support http://www.bloomington.in.us/~brutt/msf-abbrev.html
;; * add hook for tag-switching
;; * support dot notation: handle intelligently type.fields and type.operators (e.g. tooltips,TAGs, ...)
;; * support minor modes: vertical line, setnu/linum?...
;; * add "visual bookmarks" (c.f. easymacs) / overlays for registered positions?
;; * add "transparent" comments: code inside comments sould be fontified (1. via append-fontificatio; 2. using background fontification...)
;; * support "old" tnsdl-mode faces
;; * add delete-comment functionality to delete out-commented region -- c.f. `kill-comment'
;; * define (tnsdl-mode-local) key bindings
;; * add (more) unit tests, measure coverage and performance (profile)
;; * tooltips for types(?) and function calls (showing function signature)
;; * support align (in align.el)
;; * consider support of http://www.morishima.net/~naoto/software/elscreen/
;; * utilize header-line-format...
;; * add "back-to-caller" functionality: like TAGs, but goes to the caller of the function in which point is... (even if no TAGs were used before)
;; * add # if (xxx) ... # endif /* xxx */ automation
;; * speedbar should show stateful procedures' structure (i.e. indent lines of states of procedures) (examine speedbar: should we use etag for it...?)
;; * hide/show comments: (info "(elisp)Other Font Lock Variables") (info "(elisp)Invisible Text")
;; * "3-way" constructs: #if-#else-#elif-#endif; decision-():-else-enddecision; state-input-endstate;procedure-fpar-dcl-start-endprocedure(??)... -- option: tnsdl-fine-sexp
;; * support http://www.emacswiki.org/cgi-bin/emacs-en/PredictiveMode
;; * consider if thingatpt.el could be utilized (e.g. `sexp-at-point'...)

;;; Done:
;; * support minor modes: imenu (--> Speedbar), which-function, hs (hideshow), (new)comment, 
;; * add support for # directives (fontification + ignore)
;; * enable several (now: 3) levels of syntax highlighting = support different fontification levels (switch with font-lock-maximum-decoration...)
;; * set `beginning-of-defun-function' and `end-of-defun-function' (and create beginning-of-paired-block...)
;; * add uncomment functionality (see `uncomment-region') -- comment-dwim does it :-)
;; * typeing /// should result in /* (point) */ -- comment-dwim does it :-)

;;; NOT to DOs:
;; * make tnsdl-mode a toggle function (what is the "standard": on/off...) -- NO. minor modes work that way
;; * support customizable groups of faces -- http://www.emacswiki.org/cgi-bin/wiki/ColorTheme does it better

;;; Requires some definitions from cl package (supplied with Emacs)

(require 'cl)

;;; Code:

(defvar tnsdl-mode-hook t)

;;; create our main customization group

(defgroup tnsdl nil
  "TNSDL development."
  :tag "TNSDL"
  :group 'languages
  :version "22.1.1")

;;; general utility functions

(defmacro fix-pos ()
  "Set variable POS's value to point if it was nil.
POS must be a variable where this macro is expaned.
Return point if POS was reset; otherwise nil."
  ;; Note: intentional variable capture happens here.
  (unless pos (setq pos (point))))

;; -- It is better to explicitly call syntax-ppss...
;; (defmacro fix-sp ()
;;   "Set variable SP's value to `syntax-ppss' if it was nil.
;; SP must be a variable where this macro is expanded.
;; Return SP if it was reset; otherwise nil."
;;   ;; Note: intentional variable capture happens here.
;;   (unless sp (setq sp (syntax-ppss))))

(defun in-hashmark-line-p (start-pos &optional line-pos)
  "Return t if LINE-POS is in a line what starts with character #.
E.g.
# if ...
START-POS determines what \"start position of the line\" means:
it should be either 'beginning-of-line or 'back-to-indentation.
LINE-POS is defaulted to point."
  (save-excursion
    (when line-pos (goto-char line-pos)) ; do not move, if POS wasn't received -> actual point will be used
    (apply start-pos nil) ;beginning-of-line)
    (= ?# (cond ((char-after (point))) ; char-after can be nil...
                (t 0)))))

(defun between-chars (before after &optional pos)
  "Return t iff POS is between char BEFORE and char AFTER.
Default value for POS is point."
  (fix-pos)
  (and (= before (cond ((char-before pos)) (t 0)))
       (= after (cond ((char-after pos)) (t 0)))))

;; use `forward-char' instead !!
;; (defun point-add (movement)
;;   "Move point by MOVEMENT.
;; Return new position of point."
;;   (goto-char (+ (point) movement)))

;;(defun looking-around (syntax re)
;;  "Return t if point is before, after or in RE")

(defun look-chars-around (before after step)
  "If point is between chars BEFORE and AFTER, then move it by STEP.
Return new position of point if movement happened; otherwise nil.

\(Normally STEP is +1 or -1...\)"
  (when (between-chars before after) (forward-char step)))

(defun look-forward (re)
  "If point is at RE, then move it to end of RE.
Return new position of point if movement happened; otherwise nil."
  (when (looking-at re) (goto-char (match-end 0))))

(defun look-backward (re &optional limit)
  "If point is at RE, then move it to beginning of RE.
Return new position of point if movement happened; otherwise nil."
  (when (looking-back re limit) (goto-char (match-beginning 0))))

(defun pos-to-column (pos)
  "Return column of position POS.
When POS would be `point', then use `current-column' instead!"
  (save-excursion
    (goto-char pos)
    (current-column)))

(defun set-compilation-search-path (&optional add directory)
  "Use DIRECTORY for `compilation-search-path':
if ADD is 'append, then appends it to the end of `compilation-search-path';
if ADD is 'prepend, then puts it to the beginning...;
if ADD is 'delete, then deletes it from `compilation-search-path';
otherwise replaces compilation-search-path's old value with it.
DIRECTORY defaults to `default-directory'."
  (interactive)
  (unless directory (setq directory default-directory))
  (cond ((or (eq add 'append)
             (eq add 'prepend))
         (add-to-list compilation-search-path directory (eq add 'append)))
        ((eq add 'delete)
         (setq compilation-search-path (delete directory compilation-search-path)))
        (t 
         (setq compilation-search-path (list directory)))))

(defun in-compilation-search-path-p ()
  ;; menu / button / toggle requires t or nil: other values don't work!
  (if (member default-directory compilation-search-path)
      t
    nil))

(defun toggle-compilation-search-path (&optional new-state)
  "Add/remove current buffer's `default-directory' to `compilation-search-path'.
Addition means replacement!

Toggle if NEW-STATE is nil or 0;
Add if NEW-STATE is positive;
Remove if NEW-STATE is negative."
  (interactive)
  (unless new-state (setq new-state 0))
  (cond ((> new-state 0) (set-compilation-search-path))
        ((< new-state 0) (set-compilation-search-path 'delete))
        (t (if (in-compilation-search-path-p)
               (set-compilation-search-path 'delete)
             (set-compilation-search-path)))))

(defun reset-font-lock-level (level)
  "Changes the level of the fontification of the current buffer."
  (font-lock-mode t)
  (if (local-variable-p 'local-font-lock-maximum-decoration)
      (setq local-font-lock-maximum-decoration level))
  (let ((orig-max-decor font-lock-maximum-decoration))
    (setq font-lock-maximum-decoration level)
    (setq font-lock-mode-major-mode nil)
    (font-lock-set-defaults)
    (setq font-lock-maximum-decoration orig-max-decor))
  (font-lock-fontify-buffer))

(defun reset-font-lock-level-0 () (interactive) (reset-font-lock-level 0))
(defun reset-font-lock-level-1 () (interactive) (reset-font-lock-level 1))
(defun reset-font-lock-level-2 () (interactive) (reset-font-lock-level 2))
(defun font-lock-mode-off () (interactive) (font-lock-mode 0))

;;; base variables
;; see also "words, words, words..." below
(defvar ;(setq
  tnsdl-string-delim-re
  "\\('\\|``\\)"
  "Regexp matching string delimiters (in the simplest case).")

;;; base functions
(defun tnsdl-customize-mode ()
  "Start Emacs' `customize-mode' for `tnsdl-mode'."
  (interactive)
  (customize-mode 'tnsdl))

;; todo: consider implementing the following functions as `(elisp)Inline Functions' (12.10)
;; using `defsubst' instead of defun...

(defun tnsdl-in-comment-p (sp)
  "Return t iff SP shows 'inside a comment'.
SP should be the result of `syntax-ppss' or `parse-partial-sexp'..."
  ;; note: if TNSDL would have nestable comments, this should be modified...
  ;; todo compare to `hs-inside-comment-p' -- and see its usage in e.g. `slime-inside-comment-p'
  (nth 4 sp))

(defun tnsdl-in-string-p (sp)
  "Return t iff SP shows 'inside a string'.
SP should be the result of `syntax-ppss' or `parse-partial-sexp'..."
  (nth 3 sp))

;; (defun tnsdl-in-comment-starter-p ()
;;   "Return t iff point is between `/' and `*'.
;; Use `between-chars'."
;;   (between-chars ?/ ?*))

;; (defun tnsdl-in-comment-ender-p ()
;;   "Return t iff point is between `*' and `/'.
;; Use `between-chars'."
;;   (between-chars ?* ?/))

;; todo: consider if various following ..-goto-..-start/end functions could be
;; implemented in fewer functions...

;; todo: consider using "standard" names: ...-forward- and ...-backward-...

(defun tnsdl-goto-directive-start ()
  "Move point to the start of actual compiler directive line (#).
Returns the new position of point if movement happened."
  (interactive)
  (when (in-hashmark-line-p 'beginning-of-line)
    (beginning-of-line)
    (point)))

(defun tnsdl-goto-directive-end ()
  "Move point to the end of the actual compiler directive line (#).
Returns the new position of point if movement happened."
  (interactive)
  (when (in-hashmark-line-p 'beginning-of-line)
    (end-of-line)
    (point)))

(defun tnsdl-goto-comment-start () ; todo: compare to `forward-comment' and `comment-forward'
  ;; IF kept: should it be renamed to tnsdl-forward-comment?
  "Move point before the actual comment's start.
Do nothing inside strings.
Return new position of point if movement happened. Otherwise return nil."
  (interactive)
  (let ((sp (syntax-ppss))
        (pos (point)))
    (unless (tnsdl-in-string-p sp) ; do nothing inside strings
      (cond
       ;; go into comment if point is "just after" it:
       ((look-backward "\\*/" (- (point) 2)))
       ;; go before comment-starter if point is in one:
       ((look-chars-around ?/ ?* -1)))
      (unless (= pos (point)) (setq sp (syntax-ppss))) ; re-set syntax-ppss only if point is moved above
      (when (tnsdl-in-comment-p sp) (goto-char (nth 8 sp)))
      (unless (= pos (point)) (point)))))

(defun tnsdl-goto-comment-end ()  ; todo: compare to `forward-comment'
  "Move point after the actual comment's end.
Do nothing inside strings.
Return new position of point if movement happened. Otherwise return nil."
  (interactive)
  (let ((sp (syntax-ppss))
        (pos (point)))
    (unless (tnsdl-in-string-p sp) ; do nothing inside strings
      (cond 
       ;; go into comment if point is "just before" it:
       ((look-forward "/\\*"))
       ;;((tnsdl-in-comment-starter-p) (goto-char (1+ (point))))
       ((look-chars-around ?/ ?* 1)))
      (unless (= pos (point)) (setq sp (syntax-ppss))) ; re-set syntax-ppss only if point is moved above
      (when (tnsdl-in-comment-p sp)
        (unless (look-chars-around ?* ?/ 1)
        ;;(if (tnsdl-in-comment-ender-p)
        ;;    (goto-char (1+ (point)))
          (search-forward "*/" nil t)))
      (unless (= pos (point)) (point)))))

(defun tnsdl-goto-string-block-start ()
  "Move point before the actual string block's start.
Return t if movement happened; otherwise nil.
Do nothing inside comments.

\(A string block is one line of a string: it is delimited by
two consecutive `tnsdl-string-delim-re'. Constructs like 'n are ignored:
they don't delimit string blocks.\)"
  (let ((sp)
        (done))
    (unless (tnsdl-in-comment-p (syntax-ppss)) ; do nothing inside comments
      (while (or (and (between-chars ?` ?`) (goto-char (1- (point))))
                 (and (looking-back tnsdl-string-delim-re (- (point) 2)) (goto-char (match-beginning 0)))
                 (and (tnsdl-in-string-p (setq sp (syntax-ppss))) (goto-char (nth 8 sp))))
        (setq done t))
      done)))

(defun tnsdl-goto-string-block-end ()
  "Move point after the actual string block's end.
Return t if movement happened; otherwise nil.
Do nothing inside comments.

\(A string block is one line of a string: it is delimited by
`tnsdl-string-delim-re'. Constructs like 'n are ignored:
they don't delimit string blocks.\)"
  ;;(interactive)
  (let ((done)
        (sp))
    (unless (tnsdl-in-comment-p (syntax-ppss)) ; do nothing inside comments
    (while ;(and (not (tnsdl-in-comment-p (setq sp (syntax-ppss)))) ; do nothing inside comments -- this is unnecessary inside the loop
                (or ;;(and (between-chars ?` ?`) (goto-char (1+ (point))))
                    (look-chars-around ?` ?` 1)
                    ;; bug??: sp should be reset, if movement happened above -- cf. tnsdl-goto-comment-end
                    ;; -- NO: here we are in a loop...
                    (and (tnsdl-in-string-p (syntax-ppss))
                         (re-search-forward tnsdl-string-delim-re nil t))
                    ;;(and (looking-at tnsdl-string-delim-re) (goto-char (match-end 0))))
                    (look-forward tnsdl-string-delim-re))
      (setq done t))
    done)))

(defun tnsdl-before-string ()
  "Return (end) position of next `tnsdl-string-delim-re' iff
there are only white spaces to it.
Otherwise return nil."
;; todo: rename this fun; its current name comes from its original imagined purpose...
  (save-excursion
    (skip-chars-forward "[ \n\t]")
    ;; (look-forward tnsdl-string-delim-re) ~=
    (when (or (looking-at "'\\\\") ; handle "string continuation" -- for `\\\\' see (info "(elisp)Regexp Special")
              (looking-at tnsdl-string-delim-re)) ; note: order inside `or' is important here!
      (match-end 0))))

(defun tnsdl-after-string ()
  "Return (start) position of previous `tnsdl-string-delim-re' iff
there are only white spaces to it.
Otherwise return nil."
  (save-excursion
    (skip-chars-backward "[ \n\t]")
    ;; (look-backward tnsdl-string-delim-re (- (point) 2)) ~=
    (when (or (looking-back "'\\\\") ; -- see above at `tnsdl-before-string'...
              (looking-back tnsdl-string-delim-re (- (point) 2)))
      (match-beginning 0))))

;; todo: eliminate duplicated code in the next two functions...

(defun tnsdl-goto-string-start ()
  "Move point before the actual string's start.
Return t if movement happened; otherwise nil.
Do nothing inside comments.

Note: /*comments*/ \"between\" strings are not supported (by TNSDL?)."
  (interactive)
  (let ((sp)
        (next-pos)
        (done))
    (unless (tnsdl-in-comment-p (syntax-ppss)) ; do nothing inside comments
      (while (or (tnsdl-goto-string-block-start)
                 ;;(and (tnsdl-in-string-p (setq sp (syntax-ppss)))
                 ;;     (goto-char (nth 8 sp)))
                 (and (setq next-pos (tnsdl-after-string))
                      (goto-char next-pos)))
        (setq done t))
      done)))

(defun tnsdl-goto-string-end ()
  "Move point after the actual string's end.
Return t if movement happened; otherwise nil.
Do nothing inside comments.

Note: /*comments*/ \"between\" strings are not supported (by TNSDL?)."
  (interactive)
  (let ((next-pos)
        (done)
        (sp))
    (unless (tnsdl-in-comment-p (syntax-ppss)) ; do nothing inside comments
      (while (or (tnsdl-goto-string-block-end)
                 (and (setq next-pos (tnsdl-before-string))
                      (goto-char next-pos)))
        (setq done t))
      done)))

(defun tnsdl-def-ignore
  (direction name fun
   &optional ignore-string-p ignore-comment-p ia-string doc
   &rest fixed-params)
  "Defines function NAME equivalent to FUN but ignoring strings/comments
during search/skip/etc. and having \"built-in\" parameters FIXED-PARAMS.
 DIRECTION should be either 'forward or 'backward.
 Note: strings/comments are completely ignored even if FUN has a limit
parameter (like e.g. `search-forward's \"bound\") and the limit falls
inside a string/comment --> NAME may move point out of that limit.
 If FIXED-PARAMS is not nil, then its `car' determines the order of fixed
and actual parameters: if (car FIXED-PARAMS), then parameters passed to FUN
will be (cdr FIXED-PARAMS) followed by other parameters.
Otherwise (cdr FIXED-PARAMS) will follow the others.
 DOC will be the first part of the docstring of NAME. The second part is
generated by the macro and contains base information, e.g. FUN and
FIXED-PARAMS...
 The new function will be `interactive' if IA-STRING is not-nil: then
IA-STRING should either be t (meaning \"no interactive parameters\") or
a valid arg-descriptor for `interactive'. (See info node
`(elisp)Using Interactive'.)

Return the new definition (=`symbol-function') of NAME.

FUN should move point to the found position like `search-forward',
`search-backward', `re-search-forward', `re-search-backward',
`skip-chars-forward' or `skip-syntax-backward' does.
FUN should return nil in case of unsuccess (or `signal' an error...).

The created function NAME will in fact repeatedly apply FUN to parameter
list created from FIXED-PARAMS and actual parameters, and then
call `tnsdl-goto-string-block-end'/`tnsdl-goto-string-block-start' and
`tnsdl-goto-comment-end'/`tnsdl-goto-comment-start' according
to DIRECTION and IGNORE-STRING-P and IGNORE-COMMENT-P.
 Setting both IGNORE-STRING-P and IGNORE-COMMENT-P to nil is probably
meaningless: in such cases use FUN directly instead."
  ;; body starts here:
  (lexical-let ((lfun fun))
    (fset name
          `(lambda (&rest r)
             ;; build up docstring of the new function NAME:
             ,(concat
               doc
               "\n\nDefined via `tnsdl-def-ignore' in the following way:\n call `"
               (symbol-name lfun)
               "' with parameters "
               (if fixed-params
                   (if (car fixed-params)
                       ;; option: use (substring ... 1 (1- (length ...))) to remove `(' and `)'...
                       (prin1-to-string (append (cdr fixed-params) '(R)))
                     (prin1-to-string (append '(R) (cdr fixed-params))))
                 "(R)")
               ";\n"
               (when ignore-string-p
                 (concat
                  " ignore strings using `"
                  (if (eq direction 'forward) 
                      "tnsdl-goto-string-block-end"
                    "tnsdl-goto-string-block-start")
                  "';\n"))
               (when ignore-comment-p
                 (concat
                  " ignore comments using `"
                  (if (eq direction 'forward)
                      "tnsdl-goto-comment-end"
                    "tnsdl-goto-comment-start")
                  "';\n"))
               "To check its final definition do `(prin1-to-string (symbol-function '"
               (symbol-name name)
               "))'.")
             ;; build up body of the new function NAME:
             ,(when ia-string `(interactive ,(unless (eq t ia-string) ia-string)))
             (let ((pos)
                   (start-pos (point)) ; -- this variable is unnecessary...
                   (success))
               ;; visibly move point only after full success;
               ;; for this, we keep track of two values:
               ;;   pos is a "temporary target candidate"
               ;;   start-pos is a "proved target" -- now this is the point where NAME was first called...
               (save-excursion
                 (while (and (progn ;;(setq start-pos (point))
                               (setq success
                                     (apply ',lfun
                                            ,(if fixed-params
                                                 (if (car fixed-params)
                                                     `(append ',(cdr fixed-params) r)
                                                   `(append r ',(cdr fixed-params)))
                                               'r)))
                               (when success (setq pos (point)))
                               success) ; continue only in case of success -- this line is unnecessary...
                             ;; if previous movement has to be "refined" because of string/comment
                             ;; skipping, then "forget" new pos and re-set pos to "old, proved" value;
                             ;; optimization possibility: some (more) part of the logical expression
                             ;; below could be evaluated during macro expanson...
                             (or (and ,ignore-string-p
                                      ,(if (eq direction 'forward)
                                           '(tnsdl-goto-string-block-end)
                                         '(tnsdl-goto-string-block-start))
                                      (setq pos start-pos)) ;  -- this line is unnecessary...
                                 (and ,ignore-comment-p 
                                      ,(if (eq direction 'forward)
                                           '(tnsdl-goto-comment-end)
                                         '(tnsdl-goto-comment-start))
                                      (setq pos start-pos)) ;  -- this line is unnecessary...
                                 ;; now compiler directive handling is not controlled by the
                                 ;; caller of this function: compiler directive lines are
                                 ;; always skipped ...
                                 ,(if (eq direction 'forward)
                                      '(tnsdl-goto-directive-end)
                                    '(tnsdl-goto-directive-start))))))
               (when success (goto-char pos))
               success)))))

(defun tnsdl-def-ignore-guess
  (fun-start
   &optional ia-string doc
   &rest fixed-params)
  "Do `tnsdl-def-ignore' with guessed parameters for both directions:
'forward and 'backward.
 The base function will be FUN-START-forward and FUN-START-backward.
FUN-START is a string and shouldn't contain \"-forward\" or
\"-backward\" ending!
 The name of the new functions will be tnsdl-FUN-START-forward and -backward.
 Both strings and comments will be ignored.
 IA-STRING and FIXED-PARAMS are treated in the same way as in `tnsdl-def-ignore'."
;; todo: some checks are missing; e.g. intern-soft shouldn't return nil, ...
  (let ((base-fun) ; (concat fun-start "-forward"))
        (new-fun)); (concat "tnsdl-" base-fun)))
    (dolist (direction '("forward" "backward"))
      (setq base-fun (concat fun-start "-" direction))
      (setq new-fun (concat "tnsdl-" base-fun))
      (apply 'tnsdl-def-ignore
             (intern direction)
             (intern new-fun)
             (intern-soft base-fun)
             t t ia-string
             (concat doc
                     "\n\nDefined via `tnsdl-def-ignore-guess';\n"
                     " Base function is `" base-fun "'.")
             fixed-params))))

(tnsdl-def-ignore-guess "search" 
                        "sSearch for string: "
                        "R is all the normal parameters of the base function.")

(tnsdl-def-ignore-guess "re-search"
                        "sSearch for RE: "
                        "R is all the normal parameters of the base function.")

(tnsdl-def-ignore-guess "skip-chars"
                        "sChars to skip: "
                        "R is all the normal parameters of the base function.")

(tnsdl-def-ignore 'forward
                  'tnsdl-skip-space-forward
                  'skip-chars-forward
                  t t t
                  "Skips spaces."
                  t "[:space:]")

(tnsdl-def-ignore 'backward
                  'tnsdl-skip-space-backward
                  'skip-chars-backward
                  t t t
                  "Skips spaces."
                  t "[:space:]")

(defun tnsdl-goto-balanced-start (look-for skip &optional non-balanced)
  "Search backward for LOOK-FOR (or NON-BALANCED) until an unbalanced non-SKIP is found...
Thus SKIP should be \"part\" of LOOK-FOR.
Also NON-BALANCED is searched, but only outside of any found
{LOOK-FOR,SKIP} pairs, i.e. only on \"outermost\" level, so inside embedded
{LOOK-FOR,SKIP} constructs, NON-BALANCED is skipped.
LOOK-FOR, SKIP and NON-BALANCED are regexps.
Use `tnsdl-re-search-backward' for re-search of LOOK-FOR...
Return new pos in case of success, otherwise return nil."
  ;; Well, non-balanced is added for DECISION branches... :-(
  ;; todo: find a better name; especially because this name is confusing taking into account `tnsdl-goto-pair-start'...
  (if non-balanced
      (setq non-balanced (concat "\\|" non-balanced))
    (setq non-balanced ""))
  (let ((orig-pos (point))
        (level 1))
    (while (and (> level 0)
                (tnsdl-re-search-backward (if (> level 1)
                                              look-for
                                            (concat look-for non-balanced))
                                          nil
                                          t))
      (if (looking-at skip)
          (setq level (1+ level))
        (setq level (1- level))))
    (if (= level 0)
        (point) ;; success case
      (goto-char orig-pos)
      nil)))

(defun tnsdl-goto-balanced-end (look-for skip &optional non-balanced)
  "Search forward for LOOK-FOR (or NON-BALANCED) until an unbalanced non-SKIP is found...
Thus SKIP should be \"part\" of LOOK-FOR.
Also NON-BALANCED is searched, but only outside of any found
{LOOK-FOR,SKIP} pairs, i.e. only on \"outermost\" level, so inside embedded
{LOOK-FOR,SKIP} constructs, NON-BALANCED is skipped.
LOOK-FOR, SKIP and NON-BALANCED are regexps.
Use `tnsdl-re-search-forward' for re-search of LOOK-FOR...
Return new pos in case of success, otherwise return nil."
  ;; todo: find a better name; especially because this name is confusing taking into account `tnsdl-goto-pair-end'...
  (if non-balanced
      (setq non-balanced (concat "\\|" non-balanced))
    (setq non-balanced ""))
  (let ((orig-pos (point))
        (level 1))
    (while (and (> level 0)
                (tnsdl-re-search-forward (if (> level 1)
                                              look-for
                                            (concat look-for non-balanced))
                                          nil
                                          t))
      (if (looking-back skip)
          (setq level (1+ level))
        (setq level (1- level))))
    (if (= level 0)
        (point) ;; success case
      (goto-char orig-pos)
      nil)))

(defun tnsdl-goto-block-start ()
  "Move point to the starting position of innermost enclosing
\(paired) block or decision branch.
Return new pos in case of success, otherwise return nil."
  (interactive)
  (tnsdl-goto-balanced-start tnsdl-paired-re tnsdl-endkeywords-re tnsdl-decision-branch-re))

(defun tnsdl-goto-block-end ()
  "Move point to the ending position of innermost enclosing
\(paired) block or decision branch.
Return new pos in case of success, otherwise return nil."
;; NOTE!!! "IMPLEMENTATION nazgul OF SYSTEM yxa;"'s ending par is "ENDIMPLEMENTATION nazgul;" (NOT ENDSYSTEM...)
  (interactive)
  (tnsdl-goto-balanced-end tnsdl-paired-re tnsdl-startkeywords-re tnsdl-decision-branch-re))

(defun tnsdl-goto-proc-start ()
  "Move point to the starting position of enclosing procedure.
This is a specialized variant of `tnsdl-goto-block-start'."
  (interactive)
  (let ((orig-pos (point)))
    (while (and (not (bobp))
                (not (looking-at "\\<procedure\\>"))
                (tnsdl-goto-block-start)))
    (if (looking-at "\\<procedure\\>")
        (point)
      (goto-char orig-pos)
      nil)))

(defun tnsdl-goto-proc-end ()
  "Move point to the ending position of enclosing procedure.
This is a specialized variant of `tnsdl-goto-block-end'."
  (interactive)
  (let ((orig-pos (point)))
    (while (and (not (bobp))
                (not (looking-back "\\<endprocedure\\>"))
                (tnsdl-goto-block-end)))
    (if (looking-back "\\<endprocedure\\>")
        (point)
      (goto-char orig-pos)
      nil)))

(defmacro tnsdl-when-real-code (sp &rest r)
  ;; better name: tnsdl-when-living-code ?
  "Eval R iff point is not in a comment or in a string.
In other words: do nothing if point is inside comment/string;
otherwise do R.
 Comment/string status is decided from SP using
`tnsdl-in-comment-p'/`tnsdl-in-string-p'.

Return the last evaluated form's value or nil.
So this is a special variant of `when'."
  ;; macro-sp is used to avoid multiple evaluation of ,sp, if e.g. it is `syntax-ppss'...
  (let ((macro-sp (make-symbol "sp-hidden-inside-macro")))
    `(let ((,macro-sp ,sp))
       (unless (or (tnsdl-in-string-p ,macro-sp)
                   (tnsdl-in-comment-p ,macro-sp))
         ,@r))))

(defun tnsdl-goto-pair-end ()
  "Move point to the end<keyword> pair of the current <keyword>.
Return new position of point if movement happened; otherwise return nil.

Currently do nothing inside comments/strings."
  ;; IMPORTANT NOTE: #compiler switches can confuse this.
  ;; (Think of #if ...\n DECISION ... \n #else \n DECISION ...) -->
  ;; Maybe it would worth checking if tnsdl-goto-pair-start comes back
  ;; to the calling point of this function.
  ;; If not: do not move point, and signal an error...
  ;; -- Though best would be to support compiler switches...

  ;; note: suspiciously many local variables...
  ;; todo: use tnsdl-goto-balanced-end...
  ;;(macroexpand '
  (tnsdl-when-real-code ;; maybe it would be better to use a special `tnsdl-looking-back' below
                        ;; (instead of `tnsdl-when-real-code' here and `looking-back' below.)..?
                        ;; -- no: current solution is more general...
   (syntax-ppss)
   (let ((orig-pos (point))
         (level 1)
         w-pos
         found
         re
         final-pos)
     (save-excursion
     (skip-syntax-forward "w") ; no difference between word- and simbol-constituents...(?)
     (setq w-pos (point))
     (when (looking-back tnsdl-startkeywords-re (- (point) 31)) ; 31 is the max len of an identifier -- also of keywords?
       (setq found (match-string-no-properties 0);(buffer-substring-no-properties (match-beginning 0) (match-end 0))
             re (regexp-opt (list found (concat "END" found)) 'words))
       ;; do not let OPERATORS confuse us:
       (unless (and (string= found "PROCEDURE")
                    (save-excursion
                      (tnsdl-re-search-backward (regexp-opt '("TYPE" "ENDTYPE") 'words) nil t))
                    (string= (match-string-no-properties 0) "TYPE"))
         (while (and (> level 0)
                     (tnsdl-re-search-forward re nil t))
           (if (string= (match-string-no-properties 0) found)
               (setq level (1+ level))
             (setq level (1- level)))))
       ;; set return value:
       (unless (= w-pos (point)) (setq final-pos (point)))))
     (when final-pos (goto-char final-pos)))))
;;            ;; no "real" movement happened --> move point back to its original position (like a save-excursion...)
;;            (progn (goto-char orig-pos)
;;                   nil)
;;          ;; "real" movement happened, so:
;;          (point))))))
    
(defun tnsdl-goto-pair-start ()
  "Move point to the <keyword> pair of the current end<keyword>.
Return new position of point if movement happened; otherwise return nil.

Currently do nothing inside comments/strings."
  ;; note: suspiciously many local variables...
  ;;(macroexpand '
  (tnsdl-when-real-code ;; maybe it would be better to use a special `tnsdl-looking-back' below
                        ;; (instead of `tnsdl-when-real-code' here and `looking-back' below.)..?
                        ;; -- no: current solution is more general...
   (syntax-ppss)
   ;; todo: use tnsdl-goto-balanced-start...
   (let ((orig-pos (point))
         (level 1)
         w-pos
         found
         re)
     (skip-syntax-backward "w") ; no difference between word- and simbol-constituents...(?)
     (setq w-pos (point))
     (when (looking-at tnsdl-endkeywords-re)
       (setq found (match-string-no-properties 0);(buffer-substring-no-properties (match-beginning 0) (match-end 0))
             re (regexp-opt (list found (substring found 3)) 'words))
       (while (and (> level 0)
                   (tnsdl-re-search-backward re nil t))
         (if (string= (match-string-no-properties 0) found)
             (setq level (1+ level))
           (setq level (1- level)))))
     ;; set return value:
     (if (= w-pos (point))
         ;; no "real" movement happened --> move point back to its original position (like a save-excursion...)
         (progn (goto-char orig-pos)
                nil)
       ;; "real" movement happened, so:
       (point)))))

(defun tnsdl-forward-sexp (&optional num)
  "Try behaving (almost) as the \"standard\" `forward-sexp':
if point is in
NOTE: THIS DOC IS OBSOLATE!!
* a `tnsdl-startkeywords-re', then go to its end<keyword> pair
  (using `tnsdl-goto-pair-end')
* a string or comment, then step out from it (using
  `tnsdl-goto-string-end'/`tnsdl-goto-comment-end')
  (Note: comments are not handled in original, elisp variant...)
* otherwise goto symbol end...

For more info see info node `(elisp)List Motion'.

Return new position of point if movement happened; otherwise nil.

Currently argument NUM is ignored..."
  ;; note: here symbol and word constituents are not distinguished....
  ;; todo: add #if -- #else -- #endif handling
  (interactive)
  (unless num (setq num 1))
  (if (< num 0) (tnsdl-backward-sexp (- 0 num))
  (skip-syntax-forward " ") ;; skip spaces anyway... -- todo: compare with tnsdl-backward-sexp: it uses tnsdl-skip-space-... instead!?
  (let ((pos (point)))
    (cond ((< 0 (tnsdl-skip-space-forward))) ;; skip (out from) comments/strings...
          ((tnsdl-goto-pair-end))
          ;;((tnsdl-goto-comment-end))
          ;;((tnsdl-goto-string-end))
          ((looking-at "\\<\\(fpar\\|dcl\\)\\>")
           (tnsdl-search-forward ";"))
          ((progn (when (looking-at tnsdl-e-startkeywords-re)
                    (goto-char (match-end 0)))
                  (tnsdl-goto-block-end)
                  (when (looking-back tnsdl-decision-branch-re)
                    (goto-char (match-beginning 0)))
                  t))
          ((< 0 (skip-syntax-forward "w_"))) ;; "w" = word constituent; "_" = symbol constituent
          ;;((< 0 (skip-syntax-forward "_"))) ;;  " " = space
          ;;((< 0 (skip-syntax-forward " "))) ;; " " = space ;; see (info "(elisp)Syntax Class Table")
          (t (forward-char)))
    (unless (= pos (point))
      (point)))))

(defun tnsdl-backward-sexp (&optional num)
  "Try behaving (almost) as the \"standard\" `backward-sexp':
if point is in
NOTE: THIS DOC IS OBSOLATE!!
* a `tnsdl-endkeywords-re', then go to its <keyword> pair
  (using `tnsdl-goto-pair-start')
* a string or comment, then step out from it (using
  `tnsdl-goto-string-start'/`tnsdl-goto-comment-start')
  (Note: comments are not handled in original, elisp variant...)
* otherwise goto symbol's start...

For more info see info node `(elisp)List Motion'.

Return new position of point if movement is happened; otherwise nil.

Currently argument NUM is ignored..."
  ;; note: here symbol and word constituents are not distinguished....
  ;; todo: add #if -- #else -- #endif handling
  (interactive)
  (unless num (setq num 1))
  (if (< num 0) (tnsdl-forward-sexp (- 0 num))
  (tnsdl-skip-space-backward) ;; skip (out from) spaces/comments/strings anyway...
  (let ((pos (point)))
    (cond ((tnsdl-goto-pair-start))
          ;;((tnsdl-goto-comment-start))
          ;;((tnsdl-goto-string-start))
          ((progn (when (looking-back tnsdl-e-startkeywords-re)
                    (goto-char (match-beginning 0)))
                  (when (and (tnsdl-goto-block-start)
                             (looking-at tnsdl-decision-branch-re))
                    (goto-char (match-end 0)))))
          ((< 0 (skip-syntax-backward "w_")))
          (t (backward-char)))
    (unless (= pos (point))
      (point)))))

(defun tnsdl-forward-sexp-inner (&optional num)
  "After doing `tnsdl-forward-sexp', go back to beginning of block ender.
Developed specially for using as forward-sexp-func in `hs-special-modes-alist'
for tsndl.
Currently argument NUM is ignored..."
  ;; todo: add check: if it is called in(??) a comment, then hide the comment (instead of surrounding block)...
  (tnsdl-forward-sexp)
  (when (or (looking-at tnsdl-decision-branch-re)
            (looking-back tnsdl-endkeywords-re))
    (goto-char (match-beginning 0))
    (end-of-line 0)))

(defun tnsdl-adjust-block-beginning (pos)
  "Developed for using as adjust-beg-func in `hs-special-modes-alist'
for tsndl."
  ;; should be in sync with tnsdl-forward-sexp
  (if (and (skip-syntax-forward " ")
           (not (< 0 (tnsdl-skip-space-forward)))
           (tnsdl-goto-pair-end))
      (progn
        (tnsdl-goto-pair-start)
        (end-of-line)
        (point))
    pos))

;; (defun tnsdl-goto-semicolon-starter ()
;;  ;; find better name? tnsdl-goto-root? (as all source files are trees?)
;;  "Move point to the first character of last XXX...; construct...
;; Return new position if movement happened; otherwise nil..."
;;  (let ((re (concat "\\()\\)\\|" tnsdl-keywords-re))
;;        (pos (point)))
;;    (while (and (tnsdl-re-search-backward re nil t)
;;                (or (and (string= (match-string-no-properties 0) ")")
;;                         (goto-char (nth 1 (syntax-ppss)))) ; here (nth 1...) can't be nil...
;;                    ;; keyword COMMENT is ignored:
;;                    (string= (downcase (match-string-no-properties 0)) "comment")
;;                    ;; end<keyword>-s are ignored (looking-at could be used here...):
;;                    (eq t (compare-strings (match-string-no-properties 0) 0 2 "end" 0 2 t)))))
;;    (unless (= pos (point)) (point))))

;;; words, words, words...
;; The base collection:
;;(setq tnsdl-words
(defvar tnsdl-words 
  (make-hash-table
   :test 'equal
   :size 130
   :rehash-size 20)
  "All the words what has some assiciated special treatment in `tnsdl-mode'.
Each special word is a key in this hash table with an alist value.
The alist values can have the following key-value pairs:

keyword: t means this is a keyword; this property should be in sync. with
         TNSDL Grammar, Chapter 5.7;
paired: 'start means this keyword is the car of a
         (<keyword> . END<keyword>) cons;
         'end --> this is the cdr...;
upcase: t means this word should be capitalized

Normally all paired are keyword and all keyword are upcase...

To check the default values for these keys, see `tnsdl-words-default'.")

(defvar tnsdl-words-default
  '((keyword . t)
    (paired . nil)
    (upcase . t))
  "Default values for all the valid keys (='properties') for a word in
`tnsdl-words'.")

;; The base operators:
(defun tnsdl-words-get (word key) ; todo? rename KEY to PROPERTY
  "Return the value of the KEY for WORD in `tnsdl-words'.
If WORD is not found or KEY is not a valid key: return nil (though
should `signal' an error?...).
If (valid) KEY is not found (for WORD): return appropriate default."
  ;;(implement-debug-on-entry)
  (let ((word-val (gethash word tnsdl-words 'not-found)))
    (if (eq word-val 'not-found)
        nil ; the word wasn't found
      (if (memq key (mapcar 'car word-val)) ; the key is set
          (eval (cdr (assoc key word-val))) ; return it, even if it is nil
        ;; the property is not set: return default or nil:
        (eval (cdr (assoc key tnsdl-words-default)))))))
;;(tnsdl-words-get "alternative" 'keyword)
;;(tnsdl-words-get "abstract" 'indent-at)

(defun tnsdl-words-all ()
  "Return a list with the whole content of `tnsdl-words'.
For testing."
  (let (all)
    (maphash (lambda (key value) (add-to-list 'all (cons key value) 'append))
             tnsdl-words)
    all))
;; (tnsdl-words-all)

(defun tnsdl-words-re (&optional key value only-list) ;; todo: should accept (key . value) instead...
  "Return an optimized (with `regexp-opt') regexp what matches all keys in
`tnsdl-words' whose alist's key's value is VALUE. Thus: if KEY is received
then VALUE must also be received.
Return just the (human readable) base list of words if ONLY-LIST is t."
  (let (re)
    (maphash (lambda (word alist)
               (when (or (not key)
                         (equal (tnsdl-words-get word key) value))
                   (add-to-list 're word 'append)))
             tnsdl-words)
    (if only-list
        re
      (regexp-opt re 'words))))
;;(tnsdl-words-re)
;;(tnsdl-words-re 'paired 'start t)

(defun tnsdl-words-put-default (word)
  "Put a word into `tnsdl-words' without setting any property for it.
Result: defaults will be used for it."
  (puthash word nil tnsdl-words))

;;(defun tnsdl-words-modify-property (word property new-val)...

(defun tnsdl-words-put-paired (word)
  "Put a paired keyword(!) pair into `tnsdl-words' with appropriate hardcoded
defaults."
  (puthash word '((paired . 'start))
           tnsdl-words)
  (puthash (concat "end" word) '((paired . 'end))
           tnsdl-words))

;; Now let's fill up our base structure:
(mapc 'tnsdl-words-put-paired
      (list
       "alternative" "bitstruct" "decision" "enum" "generator" "implementation" "library"
       "macro" "module" "procedure" "process" "programblock"
       "select" "serviceblock" "state" "struct" "subautomaton" "system" "systemblock"
       "type" "union" "while"))

;; BEGINCRITICAL / ENDCRITICAL do not follow the pattern assumed by
;; tnsdl-words-put-paired, because of the BEGIN-prefix. Insert manually.

(puthash "begincritical" '((paired . 'start)) tnsdl-words)
(puthash "endcritical" '((paired . 'end)) tnsdl-words)

;; if defaults
;; (=no pair, but is(!) keyword and do(!) upcase -- check tnsdl-words-default)
;; are OK for a word, then let's simply put it into the hash:
(mapc 'tnsdl-words-put-default
      (list
       "abstract" "accepts" "adding" "alarm" "all" "and" "array" "async" "axioms"
       "bits" "call" "commands" "comment" "constant" "create"
       "database" "dcl" "distributed" "else" "exit" "external" "far" "fpar"
       "has"
       "in" "indicates" "inherits" "input" "internal" "join" "literals"
       "macrodefinition" "macroid" "master" "mod" "near" "nextstate" "not"
       "of" "operators" "or" "out" "output" "packed" "pointer" "provided" "provides"
       "representation" "reset" "return" "returns" "revealed"
       "save" "services" "set" "signal" "signalset" "sizeof" "skip" "start" "stop" "sync" "synonym"
       "task" "timer" "to" "uses" "viewed" "where" "withwarming" "xor"))

;; some special words are still missing? Let's put them!
;; boolean T, F, NIL are not keywords, but we want to upcase them...
(puthash "t" '((keyword . nil)) tnsdl-words)
(puthash "f" '((keyword . nil)) tnsdl-words)
(puthash "nil" '((keyword . nil)) tnsdl-words)
;;(tnsdl-words-get "f" 'upcase)
;;(tnsdl-words-get "f" 'keyword)
;;(mapconcat 'concat (tnsdl-words-re 'upcase t t) "  ")

;; what to do with `bool'?!

;; after filling all special words into our base struct.,
;; let's generate the needed regexps!

(setq tnsdl-decision-branch-re
      "^ *\\(( *.+ *)\\|else\\) *:")
      ;;"^[:blank:]*([:blank:]*.+[:blank:]*)[:blank:]*:")
      ;;"^ *( *.+ *) *:")

;;(setq tnsdl-keywords-re
(defvar tnsdl-keywords-re
  (tnsdl-words-re 'keyword t)
  "An optimized regexp what should match exactly the official
keywords of TNSDL -- cf. TNSDL Grammar, Chapter 5.7")
;;(mapconcat 'concat (tnsdl-words-re 'keyword t t) "  ")

(defvar tnsdl-startkeywords-re
  (tnsdl-words-re 'paired 'start)
  "An optimized regexp what should match exactly the car of
all (keyword . <end>keyword) pairs.")

(defvar tnsdl-e-startkeywords-re
  (concat tnsdl-startkeywords-re "\\|" tnsdl-decision-branch-re)
  "Expanded `tnsdl-startkeywords-re': `tnsdl-decision-branch-re' is concatenated.")

(defvar tnsdl-endkeywords-re
  (tnsdl-words-re 'paired 'end)
  "An optimized regexp what should match exactly the <end>keywords.")

(defvar tnsdl-e-endkeywords-re
  (concat tnsdl-endkeywords-re "\\|" tnsdl-decision-branch-re)
  "Expanded `tnsdl-endkeywords-re': `tnsdl-decision-branch-re' is concatenated.")

(let ((sk (tnsdl-words-re 'paired 'start t))
      (ek (tnsdl-words-re 'paired 'end   t)))
  (defvar tnsdl-paired-re (regexp-opt (append sk ek) 'words)
    "An optimized regexp what should match all the paired keywords of TNSDL."))

(defvar tnsdl-e-paired-re
  (concat tnsdl-paired-re "\\|" tnsdl-decision-branch-re)
  "Expanded `tnsdl-paired-re': `tnsdl-decision-branch-re' is concatenated.")

;;(setq tnsdl-upcase-re
(defvar tnsdl-upcase-re
  (tnsdl-words-re 'upcase t)
  "An optimized regexp what should match all words whose upcase property is t.")
;;(mapconcat 'concat (tnsdl-words-re 'upcase t t) "  ")

;; (defvar tnsdl-sexp-delimiter tnsdl-paired-re
;;   ;; currently DECISION handling is missing...
;;   "A regexp matching any delimiter of a balanced expression:
;; a starter or an ender of a paired keyword, or a DECISION branch.")

;;; faces
;; this part is removed: now I recommend using color-theme.el instead...
;; (e.g. I found color-theme-gnome2 quite pleasant)
;; (defgroup tnsdl-faces nil
;;   "All the faces used by TNSDL major mode."
;;   :tag "TNSDL faces"
;;   :group 'tnsdl
;;   :group 'faces)

;; ;(copy-face font-lock-function-name-face 'tnsdl-function-name-face)
;; ;(set-face-attribute 'tnsdl-function-name-face nil
;; ;                    :weight 'bold)
;; (defcustom tnsdl-function-name-face 'bold ; 'info-title-3
;;   "Used to fontifying names like PROCEDURE names, TYPE names, etc."
;;   :tag "TNSDL function name face"
;;   :type 'face
;;   :group 'tnsdl-faces)

;;(copy-face font-lock-keyword-face 'tnsdl-keywords-face)
;;(set-face-attribute 'tnsdl-keywords-face nil
;;                    :foreground "SlateBlue1")
;;(defcustom tnsdl-keywords-face 'tnsdl-keywords-face
;;  "Used to fontifying TNSDL keywords: elements identified by `tnsdl-keywords-re',
;;like PROCEDURE, TYPE, ..."
;;  :tag "TNSDL keywords face"
;;  :type 'face
;;  :group 'tnsdl-faces)

;;; files, directories, paths, ...
;; file extensions
(defvar tnsdl-auto-mode
  (cons
   (concat "\\."
           (regexp-opt (list "sdl" "sdt" "spd" "sst" "sli"))
           "$")
   'tnsdl-mode)
  "Default extensions for tnsdl-mode")

(add-to-list 'auto-mode-alist tnsdl-auto-mode)

;; expand-file-name
;; locate-file
;; file-exists-p

;;; autoload
;;(autoload 'tnsdl-mode "tnsdl-mode" nil t)

;;; upcase

(defun tnsdl-upcase-word (&optional counter in-string in-comment)
  "Do (`upcase-word' COUNTER) unless point is inside a string and
IN-STRING is not t.
The same for comments...

Default values both for IN-STRING and IN-COMMENT are nil, i.e. words are
untouched inside strings or comments by default.

Does nothing in lines starting with `#' (even if they are in comments!...)

Note: this function is designed to work on one word, so currently string/comment
boundaries (between words) aren't handled, so COUNTER is safe
only if it is between -1 and 1..."

;; if we want to leave untouched strings or comments, then we'll need `syntax-ppss' +
;; if point is not fontified, it seems `syntax-ppss' is unreliable (???)
;; (this happens e.g. during `svn-status-ediff-with-revision') -->
  (interactive)
  (when (and (not (in-hashmark-line-p 'beginning-of-line))
             (or (and in-string in-comment) ; = no exceptions = all words should be upcased
                 ; otherwise: we need syntax-ppss -->
                 (and t ;(get-text-property (- (point) 1) 'fontified) ; = syntax-ppss is reliable; note: get-text-property returns nil at eob
                      (setq sp (syntax-ppss))
                      (and (or in-string ; do upcase inside strings or ...
                               (not (tnsdl-in-string-p sp))) ; we are outside of any strings
                           (or in-comment ; do upcase inside comments or ...
                               (not (tnsdl-in-comment-p sp))))))) ; we are outside of any comments
    (upcase-word (cond (counter) (t -1)))))

(defun tnsdl-upcase-region (beg end &optional in-string in-comment)
  "Call `tnsdl-upcase-word' for all words with upcase=t property (in
`tnsdl-words') in the received region.

Words are taken directly from `tnsdl-upcase-re'."
  (interactive "*r" ) ; accepts an already  selected region when called interactively
  (save-excursion 
    (goto-char beg)
    ;; optimization possibility: if in comment/string ... --> skip to its end and check END...
    (while (re-search-forward tnsdl-upcase-re end t)
      (tnsdl-upcase-word -1 in-string in-comment))))

(defun tnsdl-upcase-line (&optional pos in-string in-comment)
  "Call `tnsdl-upcase-region' for the line containing POS."
  (interactive "d")
  (unless pos (setq pos (point)))
  (save-excursion
    (goto-char pos)
    (tnsdl-upcase-region (progn (beginning-of-line) (point))
                         (progn (end-of-line) (point))
                         in-string
                         in-comment)))

(defun tnsdl-upcase-buffer (&optional in-string in-comment)
  "Call `tnsdl-upcase-region' for the whole buffer."
  (interactive)
  (tnsdl-upcase-region (point-min) (point-max) in-string in-comment))

;; this kind of autoupcase is completely removed;
;; though some toggle (in the menu?) could be reimplemented for the current
;; autoupcase as well...
;; (defun tnsdl-auto-upcase (&optional new-state)
;;   "Toggle auto-upcase state if NEW-STATE is nil or 0;
;; activate auto-upcase if NEW-STATE is positive;
;; deactivate auto-upcase if NEW-STATE is negative."
;;   (interactive)
;;   (if new-state
;;       (cond ((> new-state 0) (tnsdl-activate-auto-upcase))
;;             ((< new-state 0) (tnsdl-deactivate-auto-upcase)))
;;     (if (tnsdl-auto-upcase-p) (tnsdl-deactivate-auto-upcase)
;;       (tnsdl-activate-auto-upcase))))

;;; abbreviations
;;  Note: the user still need to "M-x abbrev-mode"!
;; note: dabbrev-expand is usually enough instead of abbrevs...

(define-abbrev-table 'tnsdl-abbrev-table
  (list 
   (list "proc" "PROCEDURE" nil nil t)
;(defvar tnsdl-abbrevs
;  '(("proc"  "PROCEDURE")
;    ("endp"  "ENDPROCEDURE")
;    ("cons"  "CONSTANT")
;    ("repr"  "REPRESENTATION")
;    ("deci"  "DECISION")
;    ("endd"  "ENDDECISION")
;    ("endw"  "ENDWHILE")
;    ("nex"   "NEXTSTATE")
;    ("inou"  "IN/OUT FAR")
;    ("invi"  "IN VIEWED")
;    ("des_"  "DESTROY_MSG_IF_NOT_WO_STATE")
;    ("del_"  "DELIVERY_RANGE")
;    ("imp_"  "IMPORTANT_MESSAGE")
;    ("snd_"  "SND_MSGCOPY_FROM_WO_TO_SPUP")
;    ("uni_"  "UNINTERPRETED_SIGNAL_DATA")
;    ("uni_h" "UNINTERPRETED_SIGNAL_HEADER")
;    ("uni_l" "UNINTERPRETED_SIGNAL_LENGTH")
   ))

;;; keymap
;; create tnsdl menu

;; note: when fontification level changer (radio) menu is added, take care of truncate-lines...
;;       when it is made customizable, use (tnsdl-mode . user-level) in font-lock-maximum-decoration...

(setq tnsdl-font-lock-menu
      (let ((map (make-sparse-keymap)))
        (define-key map [level-2]
          '(menu-item "Level-2"
                      reset-font-lock-level-2
                      :help "Full fontification..."
                      :key-sequence nil
                      :button (:radio
                               . (and font-lock-mode
                                      (equal 2 local-font-lock-maximum-decoration)))))
        (define-key map [level-1]
          '(menu-item "Level-1"
                      reset-font-lock-level-1
                      :help "Basic fontification: Level-0 and all keywords."
                      :key-sequence nil
                      :button (:radio
                               . (and font-lock-mode
                                      (equal 1 local-font-lock-maximum-decoration)))))
        (define-key map [level-0]
          '(menu-item "Level-0"
                      reset-font-lock-level-0
                      :help "Simplest fontification: comments and strings and PROC..."
                      :key-sequence nil
                      :button (:radio
                               . (and font-lock-mode
                                      (equal 0 local-font-lock-maximum-decoration)))))
        (define-key map [off]
          '(menu-item "Off"
                      font-lock-mode-off
                      :help "Turn off fontification."
                      :key-sequence nil
                      :button (:radio
                               . (not font-lock-mode))))
        map)
      ;; docstring...
      )

(setq tnsdl-goto-menu
      (let ((map (make-sparse-keymap)))
        (define-key map [block-end]
          '(menu-item "Block end"
                      tnsdl-goto-block-end
                      :help "Go to innermost enclosing block's end."
                      :key-sequence nil))
        (define-key map [block-start]
          '(menu-item "Block start"
                      tnsdl-goto-block-start
                      :help "Go to innermost enclosing block's start."
                      :key-sequence nil))
        (define-key map [sep-1]
          '(menu-item "--"))
         (define-key map [proc-end]
           '(menu-item "PROCEDURE end"
                       end-of-defun ;tnsdl-goto-proc-end
                       :help "Go to enclosing PROCEDURE's end."
                       :key-sequence [C-M-end]))
         (define-key map [proc-start]
           '(menu-item "PROCEDURE start"
                       beginning-of-defun ;tnsdl-goto-proc-start
                       :help "Go to enclosing PROCEDURE's start."
                       :key-sequence [C-M-home]))
         map)
      ;;"docstring for defvar..."
      )

(setq tnsdl-upcase-menu-keymap
      (let ((map (make-sparse-keymap)))
        (define-key map [tnsdl-upcase-buffer]
          '(menu-item "Buffer" tnsdl-upcase-buffer
                      :help "Do `tnsdl-upcase-buffer'."
                      :key-sequence nil))
        (define-key map [tnsdl-upcase-line]
          '(menu-item "Line" tnsdl-upcase-line
                      :help "Do `tnsdl-upcase-line'."
                      :key-sequence nil))
        (define-key map [tnsdl-upcase-region]
          '(menu-item "Region" tnsdl-upcase-region
                      :help "Do `tnsdl-upcase-region'."
                      :key-sequence nil))
        map)
      ;;"docstring for defvar..."
      )

;; (setq tnsdl-fontify-menu
;;       (let ((map (make-sparse-keymap)))
;;         (define-key map [level-0]
;;           '(menu-item "Level 0"
;;                       xxx
;;                       :help "xxx"
;;                       :key-sequence nil))
;;         map)
;;       ;;"docstring for defvar..."
;;       )

(setq tnsdl-compilation-menu
      (let ((map (make-sparse-keymap)))
        (define-key map [in-comp-search-path]
          '(menu-item "In search path"
                      toggle-compilation-search-path
                      :button (:toggle
                               . (in-compilation-search-path-p))
                      :help "Add/Remove `default-directory' to `compilation-search-path' using `toggle-compilation-search-path'."
                      ;; for some PRBs or other development tasks this approach
                      ;; (= either replace or remove -> no append/prepend...)
                      ;; might be oversimplified...
                      :key-sequence nil))
        map)
      ;;"docstring for defvar..."
      )

;(defvar tnsdl-menu-keymap
(setq tnsdl-menu-keymap
      (let ((map (make-sparse-keymap))); "TNSDLy")))
        (define-key map [customize-tnsdl-mode] ;; see (info "(elisp)Changing Key Bindings")
          '(menu-item "Customize"
                      tnsdl-customize-mode
                      :help "Start interactive customization process of Emacs for TNSDL mode"
                      :key-sequence nil))
        (define-key map [tnsdl-etag]
          '(menu-item "Etag"
                      tnsdl-etag
                      :help "Generate etag files for TNSDL sources in current `defult-directory'."
                      :key-sequence nil))
        map)
      ;;"Keymap to define a menu bar menu for `tnsdl-mode'.")
      )

(defun tnsdl-upcase-self-insert (&optional self-insert-function &rest args)
  "Call `tnsdl-upcase-region' for previous word, then apply
SELF-INSERT-FUNCTION to ARGS if SELF-INSERT-FUNCTION is not nil.
If it is nil, then apply `self-insert-command' to 1."
  (interactive)
  (unless self-insert-function
    (setq self-insert-function 'self-insert-command)
    (setq args '(1)))
  (save-excursion
    ;;(skip-chars-backward "[:space:]") ; consider stepping back 1 always: work only "after first space"
    ;;(backward-char 1) ;; note: when this is called, the just-typed (e.g. SPC) is not yet inserted...
    (let ((end (point))
          beg)
      ;(skip-chars-backward "[:word:]")
      (unless (= 0 (skip-syntax-backward "w"))
        (setq beg (point))
        (tnsdl-upcase-region beg end))))
  (apply self-insert-function args))
;;  (self-insert-command 1))

(defun tnsdl-upcase-tab ()
  "Call `tnsdl-upcase-self-insert' for tab..."
  (interactive)
  (tnsdl-upcase-self-insert 'indent-for-tab-command))

(defun tnsdl-indent-and-newline ()
  "Indent actual line, then insert newline.
C.f. `newline-and-indent'."
  (interactive)
  (save-excursion
    (beginning-of-line)
    (tnsdl-indent-line))
  (newline))

(defun tnsdl-indent-and-newline-and-indent ()
  "Indent actual line, then insert newline, then indent it.
C.f. `tnsdl-indent-and-newline' and `newline-and-indent'."
  (interactive)
  (tnsdl-indent-and-newline)
  (tnsdl-indent-line))

;(defvar tnsdl-mode-map
(setq tnsdl-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map [menu-bar tnsdl] (cons "Tnsdl" tnsdl-menu-keymap))
    (define-key map [menu-bar tnsdl compilation] (cons "Compilation" tnsdl-compilation-menu))
    (define-key map [menu-bar tnsdl font-lock] (cons "Font-lock" tnsdl-font-lock-menu))
    (define-key map [menu-bar tnsdl upcase] (cons "Upcase" tnsdl-upcase-menu-keymap))
    (define-key map [menu-bar tnsdl goto] (cons "Go to" tnsdl-goto-menu))
    (define-key map " " 'tnsdl-upcase-self-insert)
    (define-key map "\t" 'tnsdl-upcase-tab) ; TAB
    (define-key map ":" 'tnsdl-upcase-self-insert) ; for ELSE: branches...
    (define-key map ";" 'tnsdl-upcase-self-insert)
    (define-key map "(" 'tnsdl-upcase-self-insert)
    (define-key map "/" 'tnsdl-upcase-self-insert) ; for IN/OUT
    (define-key map "\r" 'tnsdl-indent-and-newline-and-indent) ; RET
    ;; todo: make upcase somehow after up/down also...
    ;; let's overdefine default assignements when we have a better, special variant...:
    ;; (define-key map [C-M-right] 'tnsdl-forward-sexp) ; we set `forward-sexp-function' instead!
    ;; (define-key map [C-M-left] 'tnsdl-backward-sexp)
    map)
;  "Keymap used in TNSDL mode.")
)

;;; Indentation
(defcustom tnsdl-base-tab 4
 "Base amount of spaces to use for indenting lines."
 :tag "TNSDL base tab"
 :type 'integer
 :group 'tnsdl)

(defun tnsdl-at-word-boundary (pos)
  "Return `t' if POS is at a word boundary."
  (not (= 2 (car (syntax-after pos))))) ;; 2 means word

(defun tnsdl-indent-line ()
  "Work for tnsdl as a decent `indent-line-function' should.
Indent current line of TNSDL code.
Directly handle the following cases:
 + eol (of non-empty lines)
 + align (between words)
 + comment lines are aligned
 + string (not implemented)
 + subsequent TABs for forced `indent-relative'.
Call `tnsdl-calculate-indentation' for \"real\" indent... "
  (interactive)
  (let (sp)
  (cond

   ;; if only spaces are to the eol _of a non-empty line_, then delete them and indent-relative:
   ((save-excursion
      (beginning-of-line)
      (and (not (looking-at "^[ \t]*$"))
           (looking-at "[ \t]*$")))
    (progn
      (replace-match "")
      (indent-relative)))

   ;; if we are between words, then skip to next word and indent-relative it:
   ((and (> (current-column) (current-indentation))
         (or (tnsdl-at-word-boundary (point))
             (tnsdl-at-word-boundary (1- (point)))))
    (progn
      (skip-chars-forward "[:blank:]")
      (indent-relative)))

   ;; if we are in a comment:
   ((tnsdl-in-comment-p (setq sp (syntax-ppss)))
    (indent-line-to (1+ (pos-to-column (nth 8 sp))))) ; here `1+' should be customizable...

   ;; if we are in a string:
   ;;((tnsdl-in-string-p sp) 'noindent) ; c.f. `indent-line-function' variable's doc...
   ;; otherwise...
   (t
    (progn
      (save-excursion
        (if (eq last-command 'indent-for-tab-command)
            (progn
              (back-to-indentation)
              (indent-relative))
          (let ((i (tnsdl-calculate-indentation)))
            (if (< i 0)
                (progn
                  (back-to-indentation)
                  (indent-relative))
              (indent-line-to i)))))
      (if (< (current-column) (current-indentation))
          (back-to-indentation)))))))

;; use `indent-region' instead; see comment for `indent-region-function'!
;; (defun tnsdl-indent-region (beg end)
;;   "Indent each line what has at least 1 character in the region with
;; `tnsdl-indent-line'."
;;   (interactive "*r")
;;   (let ((lcount (count-lines beg end)))
;;     (goto-char beg)
;;     (beginning-of-line)
;;     (while (< 0 lcount) ;; use dotimes instead
;;       (tnsdl-indent-line)
;;       (forward-line)
;;       (setq lcount (1- lcount)))))

;;(defun tnsdl-indent-buffer ())

(defun tnsdl-calculate-indentation ()
  "
Return <0 number if error happened..."
  (let (at-special opening-paren sp)
  ;;(save-excursion
  ;;(back-to-indentation)
  ;;(let ((sp (syntax-ppss)))
  ;; note: currently it is not supported if bol is in comment/string....
  (cond 

   ;; handle closing parens
   ((save-excursion
      ;;(edebug) ;; this is a permanent breakpoint -- if uncommented...
      (back-to-indentation)
      (when (eq (char-after) ?\))
        (goto-char (1+ (point)))
        (pos-to-column (nth 2 (syntax-ppss))))))

   ;; handle #compiler-directives (e.g. #if)
   ((when (in-hashmark-line-p 'back-to-indentation) 0))

   ;; handle string continuation
   ;; note: if multiline strings are OK, then this should be refined... -- but multiline comments are not valid in tnsdl...
   ;; 'xxx'\ is not handled
   ;; todo: add handling of empty lines (like of parameter list cont. below)
   ((save-excursion
      (back-to-indentation)
      (looking-at tnsdl-string-delim-re))
    (save-excursion
      (tnsdl-goto-string-start)
      (current-column)))

   ;; handle text wrapping after opening paren
   ;; todo: add (. handling
   ((save-excursion
      (end-of-line 0)
      (tnsdl-skip-space-backward)
      (when (eq (char-before) ?\()
        (goto-char (1- (point)))
        (tnsdl-skip-space-backward)
        (skip-syntax-backward "_w")
        (+ tnsdl-base-tab
           (current-column)))))
               
   ;; handle FPAR (continuation) -- compare with "handle parameter list continuation" below...
   ((save-excursion
      (back-to-indentation)
      (when (looking-at "\\<\\(IN\\|OUT\\)\\>")     ; for FPAR...
        (end-of-line 0)
        (tnsdl-skip-space-backward)
        (when (look-backward ",")
          (back-to-indentation)
          (when (tnsdl-re-search-forward "\\<\\(IN\\|OUT\\)\\>" nil t)
            (pos-to-column (match-beginning 0)))))))

   ;; handle parameter list continuation
   ((save-excursion
      (end-of-line 0)
      (tnsdl-skip-space-backward)
      (when (look-backward ",")         ;(eq (char-before) ?\,)
        (tnsdl-skip-space-backward)
        (if (setq opening-paren (nth 1 (setq sp (syntax-ppss))))
            (progn
              (goto-char (1+ opening-paren))
              (when (looking-at "\\.") (goto-char (1+ (point)))))
          (when (and (eq (char-before) ?\))
                     (setq opening-paren (nth 2 sp)))
            (goto-char opening-paren))
          (tnsdl-re-search-backward tnsdl-keywords-re nil t)
          (skip-syntax-forward "w"))
        (tnsdl-skip-space-forward)
        (current-column))))

   ;; handle COMMENT
   ((save-excursion
      (back-to-indentation)
      (looking-at "\\<COMMENT\\>"))
    (save-excursion
      (beginning-of-line 0)
      (+ (current-indentation)
         tnsdl-base-tab)))

   ;; handle end<keyword>
   ((save-excursion
      (back-to-indentation)
      (when (and (looking-at tnsdl-endkeywords-re)
                 (tnsdl-goto-pair-start))
        (current-indentation) ; using current-indentation instead of pos-to-column helps handling abstract types...
        )))

   ;; handle decision branch starters (`^(xxx):' or `^else:'...) -- NOTE: multiple lines long branch starters are not handled!!
   ((save-excursion
      (beginning-of-line)
      (looking-at tnsdl-decision-branch-re))
    (save-excursion
      ;;(tnsdl-re-search-backward "\\<DECISION\\>" nil t)
      (tnsdl-goto-balanced-start "\\<\\(end\\)?decision\\>" "\\<enddecision\\>")
      (current-indentation)))
          
   ;; indent lines starting with non-keywords
   ((save-excursion
      (back-to-indentation)
      (not (looking-at tnsdl-keywords-re)))
    (save-excursion
      (if (tnsdl-re-search-backward tnsdl-keywords-re nil t)
          (+ (current-indentation)
             (if (looking-at "\\<COMMENT\\>") ; is this possible? -- I think: no
                 (- 0 tnsdl-base-tab)
               tnsdl-base-tab))
        (current-indentation) ; do nothing -- should we return -1 or 'noindent ?
        )))

   ;; indent lines starting with keywords:
   ((save-excursion
      (back-to-indentation)
      (looking-at tnsdl-keywords-re))
    (save-excursion
      (back-to-indentation)
      (setq at-special (looking-at "\\<\\(FPAR\\|RETURNS\\|DCL\\|START\\)\\>"))
      ;; note: using a limit here can be meaningful -- and would result incorrect
      ;; handling of many-hundreds line long decisions...
      (unless (bobp) (backward-char))  ; avoid successful re-search at starting pos...
      (if (tnsdl-re-search-backward tnsdl-paired-re nil t)
          (progn (back-to-indentation)
                 (max 0
                      (+ (current-indentation)
                         ;;(min tnsdl-base-tab (+
                         (if (and (or (looking-at tnsdl-startkeywords-re)
                                      (looking-at "\\<abstract\\>"))
                                  (not (looking-at "\\<\\(process\\|implementation\\)\\>")))
                             tnsdl-base-tab
                           0)
                         (if at-special (- 0 tnsdl-base-tab)
                           0))))
        0)                              ;(current-indentation))
      )))))

;;(defvar tnsdl-name-re "[A-Za-z][A-Za-z0-9_]+")

;;; tag files
(defun tnsdl-etag ()
  "Generate etag file for TNSDL sources in the current directory.
Current directory is `default-directory'.
For more info on etag (=Emacs TAG) files and their usage see
info node `(emacs)Tags'."
  ;; todo: generate in all subdirs recursively
  ;; todo: generate for C files also (and take care of macros!)
  ;; todo: after successful tag file generation, visit it (and do not keep old tag files is they were visited previously)
  (interactive)
  (shell-command
   "etags --language=auto --regex=\"/[ \\t]*\\(PROCEDURE\\|\\(ABSTRACT[ \\t]+\\)?TYPE\\|STATE\\|INPUT\\)[ \\t]+\\([_a-zA-Z0-9]+\\)/\\3/\" *.sdl *.sdt *.h *.c *.sst *.spd --output=tags"))

;;; settings for supporting other (minor) modes
(defvar tnsdl-imenu-generic-expression
  '(("Types" "^[ \t]*\\(ABSTRACT[ \t]+\\)?TYPE[ \t]+\\([A-Za-z][A-Za-z0-9_]+\\)" 2)
    ("Procedures" "\\(^\\|\*/ *\\)PROCEDURE[ \t]+\\([A-Za-z][A-Za-z0-9_]+\\)" 2)
    ("States" "\\(^\\|\*/ *\\)STATE[ \t]+\\([A-Za-z][A-Za-z0-9_]+\\)" 2)
    ("INPUTs" "^ *INPUT[ \t]+\\([A-Za-z][A-Za-z0-9_]+\\)" 1))
  "Imenu generic expression for TNSDL mode.  See `imenu-generic-expression'.")

;; (;defvar
;;  setq tnsdl-outline-regexp
;;   (concat "^[ ]*" "proc\\|decision");tnsdl-startkeywords-re)
;;   ;"regexp for supporting outline-minor-mode..."
;; )

;;; fontification & syntax parsing
(defvar tnsdl-syntax-table
  (let ((st (make-syntax-table)))
    (modify-syntax-entry ?_ "w" st) ; here `_' would be correct instead of `w', but regexp-opt ...
    (modify-syntax-entry ?\" "w" st) ; " is a simple word constituent: not string delimiter!
    (modify-syntax-entry ?\- "." st) ; - is a punctuation character: not a word/symbol constituent!
    (modify-syntax-entry ?\$ "." st) ; $ is a punctuation character...
    (modify-syntax-entry ?/ ". 14" st)
    (modify-syntax-entry ?* ". 23" st)
    st)
  "Syntax table for `tnsdl-mode'.
Modify it to allow national characters in words...(?)")

(defconst tnsdl-syntactic-keywords
  (quote
   (("\\('\\)\\([^'\n]\\|'[a-z']\\)*\\('\\)[^'a-z]"
     (1 "\"") ; (15) = generic string delimiter = "|"
     (3 "\"")) ; string quote = "\""
    ("\\(`\\)`\\([^`]\\|`[^`]\\)*`\\(`\\)"
     (1 "\"")
     (3 "\""))))
  "Syntactic keywords for `tnsdl-mode'.")

(defconst tnsdl-font-lock-keywords-0
  (list
   (cons "^#.*$" 'font-lock-preprocessor-face)
   (list ; 1st font-lock-keyword is for "named blocks":
    (regexp-opt '("procedure" "endprocedure"
                  "type" "endtype"
                  "state" "endstate") 'words) ; todo: add other "major blocks", like PRB..., input...
    '(0 font-lock-keyword-face)
    '("\\(\\<[_[:word:]]+\\>\\).*" nil nil (1 font-lock-function-name-face)))) ;tnsdl-function-name-face)))
  "Font lock keywords for level-0 fontification for `tnsdl-mode':
only most basic elements are fontified =
+ compiler directives
+ proc/type/state \"headers\"
+ strings
+ comments.") ;; this is more or less what is suggested in (info "(elisp)Levels of Font Lock")

(defconst tnsdl-font-lock-keywords-1
  (append
   tnsdl-font-lock-keywords-0
   (list
    ;; 2nd font-lock-keyword is for other keywords:
    (cons tnsdl-keywords-re 'font-lock-keyword-face))) ;'tnsdl-keywords-face))
  "Font lock keywords for level-1 fontification for `tnsdl-mode':
+ level-0
+ all keywords.") ;; this is less than suggested in (info "(elisp)Levels of Font Lock")

(defconst tnsdl-font-lock-keywords-2
  (append
   tnsdl-font-lock-keywords-1
   (list
    (cons "\\_<\\(\\sw\\|\\s_\\)*_\\([e]?c\\|p\\)\\_>" 'font-lock-constant-face)
    (cons "\\_<\\(t\\|f\\|nil\\|null\\)\\_>" 'font-lock-constant-face)

    (cons "\\_<\\(\\sw\\|\\s_\\)*_\\(t\\|s\\)\\_>" 'font-lock-type-face) ; according to the "TNSDL layout standard" (yfr1129) "_a" means an alarm...
    (cons "\\_<\\(pid\\|bool\\(ean\\)?\\|byte\\|word\\|dword\\|shortint\\|integer\\|longint\\|\\(double\\)?real\\|character\\(_t\\)?\\|duration\\|\\(character\\|byte\\|any\\)?pointer\\)\\_>" 'font-lock-type-face) ; todo: check if further predefined data types are exist + regex-opt this

    (cons "\\_<\\(l\\|p\\|g\\)_\\(\\sw\\|\\s_\\)*\\_>" 'font-lock-variable-name-face)
    (cons "\\_<\\(memset\\|\\(test_\\)?write_to_log\\)\\_>" 'font-lock-builtin-face)))
  "Font lock keywords for level-2 fontification for `tnsdl-mode':
+ level-1
+ constants/types/variables
+ \"built-in\" (=basic, common library) functions...")  ;; this is less than suggested in (info "(elisp)Levels of Font Lock")

(;defvar
 setq tnsdl-font-lock-defaults
  (list
   '(tnsdl-font-lock-keywords-0 tnsdl-font-lock-keywords-1 tnsdl-font-lock-keywords-2)
   ;; other elements of font-lock-defaults: keywords-only, case-fold, ...
   nil t
   nil ; = syntax-alist -> font-lock-syntax-table = nil ->
       ; -> use major mode's syntax table for fontification
   nil
   '(font-lock-syntactic-keywords . tnsdl-syntactic-keywords))
  ;"Font lock defaults for `tnsdl-mode'.")
)

;;; definition of the major mode
(define-derived-mode tnsdl-mode fundamental-mode "tnsdl"
  "A major mode for developing TNSDL code.

\\{tnsdl-mode-map}"

  :group 'tnsdl
  :syntax-table tnsdl-syntax-table
  :abbrev-table tnsdl-abbrev-table

  ;;(use-local-map tnsdl-mode-keymap) ; tnsdl-mode-map is used automatically if `define-derived-mode' is used...

  ;; (add-to-list 'auto-mode-alist '("\\.wpd\\'" . wpdl-mode))

  (set (make-local-variable 'indent-line-function) 'tnsdl-indent-line)
  (set (make-local-variable 'forward-sexp-function) 'tnsdl-forward-sexp)

  (set (make-local-variable 'parse-sexp-ignore-comments) t)
  (set (make-local-variable 'parse-sexp-lookup-properties) t)

  ;; settings for supporting/configuring other features:

  (set (make-local-variable 'beginning-of-defun-function) 'tnsdl-goto-proc-start)
  (set (make-local-variable 'end-of-defun-function) 'tnsdl-goto-proc-end)

  ;; font-lock
  (set (make-local-variable 'font-lock-defaults) tnsdl-font-lock-defaults)
  (unless (listp font-lock-maximum-decoration)
    (setq font-lock-maximum-decoration (list (cons t font-lock-maximum-decoration))))
  (add-to-list 'font-lock-maximum-decoration (cons 'tnsdl-mode 2))

  ;; for newcomment.el (partially also required by hideshow (hs-minor-)mode...):
  (set (make-local-variable 'sentence-end) ";") ; forward-sentence = M-e; backward-sentence = M-a

  (set (make-local-variable 'comment-column) 41)
  (set (make-local-variable 'end-comment-column) 75)
  (set (make-local-variable 'comment-start) "/* ")
  (set (make-local-variable 'comment-end) " */") ; after these, `comment-dwim' works!!
  (set (make-local-variable 'comment-start-skip) "/\\*+ *") ; todo: add "^#if (F)"...
  (set (make-local-variable 'comment-padding) 1)
  (set (make-local-variable 'comment-multi-line) nil) ; indent-new-comment-line = C-M-j
  ;; (make-local-variable 'comment-indent-hook)
  ;; (setq comment-indent-hook 'c-comment-indent)

  ;; maybe non-local-variable-settings could be done outside of `define-derived-mode'?
  ;; for imenu:
  (setq imenu-generic-expression tnsdl-imenu-generic-expression)
  (setq imenu-sort-function 'imenu--sort-by-name)
  ;;(imenu-add-to-menubar "imenu-buffer-index")
  ;;(imenu-add-to-menubar "Index")
  ;;(setq imenu-case-fold-search t)

  ;; for outline-minor-mode (and foldout?)
  ;;(set (make-local-variable 'outline-regexp) tnsdl-outline-regexp)
  ;; outline-level (info "(emacs)Outline Format")

  ;; for hs-minor-mode (=hide-show mode):
  (add-to-list 'hs-special-modes-alist
               (list 'tnsdl-mode
                     (concat tnsdl-e-startkeywords-re "\\|\\<\\(fpar\\|dcl\\)\\>")
                     tnsdl-e-endkeywords-re
                     "/*"
                     'tnsdl-forward-sexp-inner
                     'tnsdl-adjust-block-beginning))

  ;; for etags.el
  ;; (put 'tnsdl-mode find-tag-default-function egy-fuggveny) -- !! NO: refine tnsdl-forward-sexp instead!
  ;; todo: remove this:
  (put 'tnsdl-mode
       'find-tag-default-function
       'current-word)
  ;;     (... (word-at-point)))
  ;;     (lambda ()
  ;;       "A quick-hack solution. Refine `tnsdl-forward-sexp' instead!!"
  ;;       (save-excursion
  ;;         (buffer-substring-no-properties (progn (skip-syntax-backward "w_")
  ;;                                                (point))
  ;;                                         (progn (skip-syntax-forward "w_")
  ;;                                                (point))))))

  ;; for compilation:
  ;; (set (make-local-variable 'compile-command)
  ;;        (concat "build -dstdout -mk2cd -rm2cd -test -timestamp " ; todo: make this string customizable
  ;;                "" ;(substring (file-name-sans-extension buffer-file-name) 0 3)
  ;;                )) ; this setting is useless, if `compile' is called from .pac file ...
  
  ;;(eval-after-load 'compile
  (require 'compile) ; how to customize `compilation-error-regexp-alist' without `require'ing 'compile? --> try `eval-after-load'
  ;;(defvar compilation-error-regexp-alist)
  ;; OK: "tnsdly:(E) ciaerrmx.sdt (125):syntax error near token :="
  ;; but doesn't handle "tnsdly:(W) ciax01mx.sdl: reminders do not match. dtmf_result_list__t_populate in line 1506, dtmf_result_list_t__populate in 1545"
  (let ((file-name-re "[^ ]+")
        (line-no-re "(\\([0-9]+\\))"))
    ;; todo: Instead of an alist element... use a symbol, which is looked up in `compilation-error-regexp-alist-alist'.
    ;; tnsdl:
    (add-to-list 'compilation-error-regexp-alist
                 '("^\\(tnsdl[opqrstuvwxy]?:(\\(E\\)?\\(W\\)?) \\)\\(\\([^ ]+\\) (\\([0-9]+\\))\\):"
                   5 6 nil (3) 4))
    ;; tncheck (a simple copy of tnsdl -- todo: verify!)
    (add-to-list 'compilation-error-regexp-alist
                 '("^\\(tncheck[ab]?:(\\(C\\)?\\(W\\)?) \\)\\(\\([^ ]+\\) (\\([0-9]+\\))\\):"
                   5 6 nil (3) 4))
    ;; sdlma:
    ;; todo: build this regexp up from parts with concat...
    (add-to-list 'compilation-error-regexp-alist
                 '("^\\(sdlma[def]?:(\\(E\\)?\\(W\\)?) \\)\\(\\([^ ]+\\) (\\([0-9]+\\))\\):\\(Id. [^ ]+ longer than 31 chars\\)?"
                   5 6 nil (3) 4 (7 compilation-warning-face nil t)))
    ;; ocpp:
    (add-to-list 'compilation-error-regexp-alist
                 (list (concat "^\\(error\\)?\\(warning\\)?: ocpp: \\(\\(" file-name-re "\\)" line-no-re "\\):")
                       4 5 nil '(2) 3)))

  ;;(set (make-local-variable 'outline-regexp) tnsdl-outline-regexp))
  (set (make-local-variable 'local-font-lock-maximum-decoration)
       (font-lock-value-in-major-mode font-lock-maximum-decoration))
)

(provide 'tnsdl)
;;; tnsdl.el ends here
