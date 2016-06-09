;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.

(defun my/insert-line-before (times)
  (interactive "p")
  (save-excursion
    (move-beginning-of-line 1)
    (newline times)))




