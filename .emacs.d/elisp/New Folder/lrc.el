;;; lrc.el ---  mpg123 addons

;; Copyright (C) 2004  Free Software Foundation, Inc.

;; Author: Jerry <unidevel@yahoo.com.cn>
;; Keywords: unix, i18n, wp

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; Author: jerry
;; 最新版可以从 http://zhdotemacs.sourceforge.net 获取
;; 
;; 替换掉mpg123.el, 删去原来的mpg123.el,mpg123.elc, 在~/.emacs中加入下面的代码就可以了
;; (setq lrc-lyric-dir "<path to lrc files>") to ~/.emacs
;; (require 'mpg123)
;; 
;; 
;;; Code:

(defconst lrc-time-regexp "Time: \\(..:..\\...\\) +\\[\\(..:..\\...\\)")
(defconst lrc-lyric-regexp "\\(\\(\\[[^\]]+\\]\\)+\\)\\([^\[]*\\)")
(defconst lrc-lyric-time-regexp "\\(\\(\\[[^\]]+\\]\\)+\\)")
(defconst lrc-lyric-time-separator "[]\\[]")
(defcustom lrc-lyric-dir "."
  "C:\Program Files\TTPlayer\Lyrics" 
  :group 'lyric)
(defvar lrc-lyric-list ())
(defvar lrc-lyric-offset 0)
(defvar lrc-last nil)

(defun lrc-get-time (mess)
  (if (stringp mess)
      (if (string-match lrc-time-regexp mess)
	  (let ((s (substring mess (match-beginning 1) (match-end 1))))
	    s)
	)
    ))

(defun lrc-open (file)
  (save-excursion
    (let ((fl nil)
	  (fn nil)
	  (lyric-bufffer nil)
	  (old-buf nil))
      (setq fl (directory-files lrc-lyric-dir t (lrc-get-search-regexp file)))
      (if fl (progn
	       (setq fn (car fl))
	       (setq old-buf (current-buffer))
	       ;;(setq lyric-buffer (create-file-buffer fn))
	       (setq lyric-buffer (find-file-noselect (car fl)))
	       (lrc-set-current-lyric lyric-buffer)
	       (switch-to-buffer old-buf)
	       (kill-buffer lyric-buffer)
	       t)
	(progn
	  (setq lrc-lyric-list ())
	  (setq lrc-last nil)
	  nil)
	))
    ))
(defun lrc-get-search-regexp (filename)
  (let ((reg1 "^\\([^.]+\\) by \\([^.]+\\)$")
	(reg2 "^\\([^.]+\\).[Mm][Pp]3"))
    (cond ((string-match reg1 filename)
	   (match-string 1 filename))
	  ((string-match reg2 filename)
	   (match-string 1 filename))
	  (t filename))
    ))
(defun lrc-set-current-lyric-debug ()
  "interactive"
  (interactive)
  (lrc-set-current-lyric (current-buffer))
  )
(defun lrc-set-current-lyric (buffer)
  (save-excursion
    (switch-to-buffer buffer)
    (setq lrc-lyric-list ())
    (setq lrc-last (list " " " "))
    (let ((lrc-list nil)
	  (pass t)
	  (lyric-list nil)
	  (pair nil))
      (setq lrc-list (split-string (buffer-string) "[\r\n]+"))
      (mapcar 'lrc-add-lyric-line lrc-list)
      (setq lyric-list lrc-lyric-list)
      ;(setq lrc-lyric-list ())
      (while pass
	(setq pass nil)
	(setq pair (car lyric-list))
	(while pair
	  ;(lrc-debug pair)
	  (setq lyric-list (cdr lyric-list))
	  (let ((tm1 "")(tm2 "")(tm ""))
	    (setq tm (car pair))
	    (if (string-match lrc-lyric-time-regexp tm)
		(progn
		  (setq tm1 (match-string 1 tm))
		  (setq tm2 (match-string 2 tm))
		  ;(lrc-debug (concat "time: " tm1 " " tm2))
		  (if (not (string= tm1 tm2))
		      (progn
			(setq tm1 (substring tm 0 (match-beginning 2)))
			;(add-to-list 'lrc-lyric-list (cons tm1 (cdr pair)) t)
			(setcar pair tm2)
			(setq pass t)
			))
		  ;(lrc-debug pair)
		  (add-to-list 'lrc-lyric-list (cons tm2 (cdr pair)) t)
		  ))
	    )
	  (setq pair (car lyric-list))
	  )
	)
      ;(lrc-debug lrc-lyric-list)
      )
    ))
;;(lrc-open "泪海")
;;(lrc-open "城里的月光")
;;(lrc-display "00:02.00")
;;(lrc-open "Proud Of You")
(defun lrc-add-lyric-line (line)
  (let ((lyric "")
	(timelist ""))
    (if (string-match lrc-lyric-regexp line)
	(progn
	  (setq timelist (match-string 1 line))
	  (setq lyric (match-string 3 line))
	  (add-to-list 'lrc-lyric-list (cons timelist lyric) t)
	  ))
    ))
(defun lrc-add-lyric-line (line)
  (let ((lyric "")
	(timelist ""))
    (if (string-match lrc-lyric-regexp line)
	(progn
	  (setq timelist (match-string 1 line))
	  (setq lyric (match-string 3 line))
	  (mapcar (lambda (tm) (if (not (string= tm ""))
				   (add-to-list 'lrc-lyric-list (cons tm lyric) t)))
		  (split-string timelist lrc-lyric-time-separator))  
	  ))
    ))
;;(lrc-time-less "[ai:ddsadsa]" "00:00.30")
;;(lrc-time-less "[00:00.20]" "00:00.30")
;;(lrc-time-less "[00:01.40]" "00:00.30")
;;(lrc-time-less "[00:00]" "00:01.30")
;;(lrc-time-less "[00:02]" "00:01.30")
(defun lrc-time-less (tm1 tm2)
  (let ((tmreg "\\([0-9]\\{2\\}\\):\\([0-9]\\{2\\}\\)\.\\([0-9]\\{2\\}\\)")
	(tmreg2 "\\([0-9]\\{2\\}\\):\\([0-9]\\{2\\}\\)")
	(m11 0)(m12 0)(m13 0)(m21 0)(m22 0)(m23 0))
    (if (string-match tmreg tm1)
	(progn
	  (setq m11 (string-to-int (match-string 1 tm1)))
	  (setq m12 (string-to-int (match-string 2 tm1)))
	  (setq m13 (string-to-int (match-string 3 tm1)))
	  (string-match tmreg tm2)
	  (setq m21 (string-to-int (match-string 1 tm2)))
	  (setq m22 (string-to-int (match-string 2 tm2)))
	  (setq m23 (string-to-int (match-string 3 tm2)))
	  (cond ((< m11 m21) t)
		((> m11 m21) nil)
		(t (cond ((< m12 m22) t)
			 ((> m12 m22) nil)
			 (t (if (< m13 m23) t nil))
			 )
		   )
		)
	  )
      (if (string-match tmreg2 tm1)
	  (progn
	    (setq m11 (string-to-int (match-string 1 tm1)))
	    (setq m12 (string-to-int (match-string 2 tm1)))
	    (string-match tmreg tm2)
	    (setq m21 (string-to-int (match-string 1 tm2)))
	    (setq m22 (string-to-int (match-string 2 tm2)))
	    (cond ((< m11 m21) t)
		  ((> m11 m21) nil)
		  (t (if (< m12 m22) t nil))
		  )
	    )
	t)
      )
    ))
;; (defun lrc-time-round (tm1 tm2)
;;   (let ((tmreg "")
;; 	(tmm1 0)
;; 	(tmm2 0))
;;     (setq tmreg (substring tm1 0 5))
;;     (if (string-match tmreg tm2)
;; 	(progn
;; 	  (setq tmm1 (string-to-int (substring tm1 6 8)))
;; 	  (setq tmm2 (string-to-int (substring tm2 6 8)))
;; 	  (if (> tmm1 tmm2) t nil))
;;       nil)
;;     ))
;;(lrc-open "泪海")
;;(lrc-open "城里的月光")
;;(lrc-display "00:02.00")
;;(lrc-open "Proud Of You")
;;(setq time "00:20.00")
;;(lrc-display "00:20.00")
;;
(defun lrc-display (time)
  (let ((lyric nil)
	(lyric-time ""))
    (if time
	(progn
	  (setq lyric (car lrc-lyric-list))
	  (while (and lyric (lrc-time-less (car lyric) time))
	    (if (not (string= (cdr lyric) ""))
		(progn
		  (setq lrc-last (cdr (cdr lrc-last)))
		  (setq lrc-last (add-to-list 'lrc-last "  " t))
		  (setq lrc-last (add-to-list 'lrc-last (cdr lyric) t))
		  ))
	    (setq lrc-lyric-list (cdr lrc-lyric-list))
	    (setq lyric (car lrc-lyric-list))
	    )
	  (if (and lrc-last lrc-lyric-list) (lrc-display-lyric (apply 'concat lrc-last)))
	  )
      )
    ))

;; (defun lrc-display2 (time)
;;   (let ((lyric "")
;; 	(lyric-time ""))
;;     (mapcar (lambda (pair) 
;; 	      (if (lrc-time-round time (car pair))
;; 		  (progn
;; 		    (setq lyric (cdr pair))
;; 		    (setq lyric-time (car pair))
;; 		    )))
;; 	    lrc-lyric-list)
;;     (if (not (string= lyric ""))
;; 	(lrc-display-lyric (concat "       " lyric)))
;;     ))

(defun lrc-display-lyric (line)
  (message line)  
  )

(defun lrc-debug (msg)
  (save-excursion
    (set-buffer "*DEBUG*")
    (prin1 msg (current-buffer))
    (prin1 "\n" (current-buffer))    
    ))

(provide 'lrc)
;;; lrc.el ends here
