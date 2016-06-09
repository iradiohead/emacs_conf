From: Christopher J. Madsen <cjm at pobox com>
Date: Fri, 20 Dec 2002 14:46:22 -0600 (CST)

The attached patch will notify aspell of the replacements you make so
it can improve the suggestion list in the future.

This patch has not undergone much testing; use at your own risk.

I wrote this patch for ispell.el version 3.5 (available from
<http://kdstevens.com/~stevens/ispell-page.html>), but it should also
apply against the ispell.el 3.4 that comes with Emacs 21.2 (in the
lisp/textmodes directory).


*** ispell.el$	Mon Dec 16 00:49:49 2002
--- ispell.el	Fri Dec 20 14:03:10 2002
***************
*** 729,734 ****
--- 729,736 ----
  
  (defconst ispell-version "ispell.el 3.5 - 07/11/01")
  
+ (defvar ispell-really-aspell nil) ;Non-nil if aspell extensions should be used
+ 
  
  ;;;###autoload
  (defun check-ispell-version (&optional interactivep)
***************
*** 795,801 ****
  		 (< (car (read-from-string (buffer-substring-no-properties
  					    (match-beginning 3)(match-end 3))))
  		    (car (cdr (cdr ispell-required-version)))))
! 	    (setq ispell-offset 0)))
        (kill-buffer (current-buffer)))
      result))
  
--- 797,808 ----
  		 (< (car (read-from-string (buffer-substring-no-properties
  					    (match-beginning 3)(match-end 3))))
  		    (car (cdr (cdr ispell-required-version)))))
! 	    (setq ispell-offset 0))
!         ;; check to see if it's really aspell.
!         (goto-char (point-min))
!         (let (case-fold-search)
!           (setq ispell-really-aspell
!                 (and (search-forward "(but really Aspell " nil t) t))))
        (kill-buffer (current-buffer)))
      result))
  
***************
*** 1352,1357 ****
--- 1359,1370 ----
  			      (delete-region start (point)))
  			  (setq more-lines (= 0 (forward-line))))))))))))))
  
+ (defun ispell-send-replacement (misspelled replacement)
+   "Notify aspell that MISSPELLED should be spelled REPLACEMENT.
+ This allows it to improve the suggestion list based on actual mispellings."
+   (and ispell-really-aspell
+        (ispell-send-string (concat "$$ra " misspelled "," replacement "\n"))))
+ 
  
  
  ;;;###autoload
***************
*** 2815,2824 ****
--- 2828,2839 ----
  	      (if (not (listp replace))
  		  (progn
  		    (insert replace)	; insert dictionary word
+ 		    (ispell-send-replacement (car poss) replace)
  		    (setq accept-list (cons replace accept-list)))
  		(let ((replace-word (car replace)))
  		  ;; Recheck hand entered replacement word
  		  (insert replace-word)
+ 		  (ispell-send-replacement (car poss) replace-word)
  		  (if (car (cdr replace))
  		      (save-window-excursion
  			(delete-other-windows) ; to correctly show help.

