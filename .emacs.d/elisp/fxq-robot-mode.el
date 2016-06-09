;; Robot mode
;; ==========
;;
;; A major mode for editing robot framework text files.
;; Add the following to your .emacs file
;;
;;    (load-file "path/to/robot-mode.el")
;;    (add-to-list 'auto-mode-alist '("\\.txt\\'" . robot-mode))
;;
;; Type "M-x load-file" and give the path to the .emacs file (e.g. ~/.emacs)
;; to reload the file. Now when you open a .txt file emacs automatically sets 
;; the robot-mode on for that buffer. This will also be done automatically when
;; you start emacs.
;;
;; Please report problem to http://code.google.com/p/robot-mode
;;
;; Copyright 2010 Sakari Jokinen Licensed under the Apache License, Version 2.0 (the "License"); 
;; you may not use this file except in compliance with the License. You may obtain a copy of 
;; the License at 
;;        http://www.apache.org/licenses/LICENSE-2.0 
;; Unless required by applicable law or agreed to in writing, software distributed under the 
;; License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
;; either express or implied. See the License for the specific language governing permissions 
;; and limitations under the License. 

(setq robot-mode-keywords
      '(
        ;;normal comment
        ("#.*" . font-lock-comment-face)
        ;;Section headers
        ("\\*\\*\\* [^\\*]+ \\*\\*\\*" . font-lock-keyword-face)
        ;;keyword definitions
        ("^[^ \t\n].+" . font-lock-function-name-face)
        ;;Variables
        ("\\(\\$\\|@\\){\\( ?[^ }$]\\)+}" 0 font-lock-variable-name-face t)
        ;;tags etc
        ("\\[[^\]]+\\]+" . font-lock-constant-face)
        ;;comment kw
        ("comment  .*" . font-lock-comment-face)
        )
      )

(defun robot-mode-kw-at-point()
  "Return the robot keyword (or possibly infix variable) around the current point in buffer"
  (defun extract-kw (str)
    (defun trim (str)
      (replace-regexp-in-string "\\(^\s+\\)\\|\\(\s+$\\)\\|\n$" "" str))
    (defun cut-kw (str)
      (replace-regexp-in-string "  .*$" "" str))
    (defun cut-bdd (str) 
      (replace-regexp-in-string "^\\(given\\)\\|\\(then\\)\\|\\(when\\)\\s*" "" str))
    (cut-kw (cut-bdd (trim str)))
    )
  (let* ((kw-end (save-excursion (re-search-forward "$\\|\\(  \\)")))
         (kw-start (save-excursion (re-search-backward "^\\|\\(  \\)")))
         )
    (save-excursion 
      (let* ((variable-end (re-search-forward "[^}]*}" kw-end t))
             (variable-start (re-search-backward "\\(\\$\\|@\\){[^{]*" kw-start t)))
        (if (and variable-end variable-start) 
            (buffer-substring variable-start variable-end)
          (extract-kw (buffer-substring kw-start kw-end))
          )
        )
      )
    )
  )

(defun robot-mode-continue-find-kw()
  "Find the next matching robot kw."
  (interactive)
  (find-tag-regexp "" t)
  )

(defun robot-mode-make-kw-regexp(kw)
  (defun match-underscores (str)
    (replace-regexp-in-string "\\(_\\| \\)" "[_ ]?" str t t))
  (defun match-infix-args (str)
    (replace-regexp-in-string "'[^']+'" "'\\($\\|@\\){[^}]+}'" str t t))
  (match-infix-args (match-underscores kw))
  )

(defun robot-mode-find-first-kw()
  "Start the robot kw search."
  (setq default-kw (if (and transient-mark-mode mark-active)
					   (buffer-substring-no-properties (region-beginning) (region-end))
					 (robot-mode-kw-at-point)
					 ))
  (let ((kw (read-from-minibuffer (format "Find kw (%s): " default-kw))))
    (if (string= "" kw) (find-tag-regexp (robot-mode-make-kw-regexp default-kw))
      (find-tag-regexp (robot-mode-make-kw-regexp kw)) 
      )
    )
  )

(defun robot-mode-complete(kw-prefix)
  "Complete the symbol before point.

\\<robot-mode-map>
This function is bound to \\[robot-mode-complete].
"
  (interactive (list (robot-mode-kw-at-point)))
  (let ((kw-regexp (robot-mode-make-kw-regexp kw-prefix)))
    (defun normalize-candidate-kw(kw) 
      (replace-regexp-in-string "_" " " kw)
      )
    (let ((possible-completions ()))
      (let ((enable-recursive-minibuffers t)
            (pick-next-buffer nil)
            (kw-full (format "^ *\\(def +\\)?\\([^\177 \n]*%s[^\177\n]*?\\)(?\177\\(\\(.+\\)\\)?" kw-regexp)))
        (save-excursion
          (visit-tags-table-buffer pick-next-buffer)
          (set 'pick-next-buffer t)
          (goto-char (point-min))
          (while (re-search-forward kw-full nil t)
            (if (or (match-beginning 2) (match-beginning 4))
                (let ((got (buffer-substring 
                            (or (match-beginning 4) (match-beginning 2)) 
                            (or (match-end 4) (match-end 2)))))
                  (add-to-list 'possible-completions (normalize-candidate-kw got) )
                  )
              )
            )
          )
        )
      (cond ((not possible-completions) (message "No completions found!"))
            ((= (length possible-completions) 1) 
             (insert (substring (car possible-completions) (length kw-prefix))))
            (t (with-output-to-temp-buffer "*Robot KWs*"
				 (display-completion-list possible-completions kw-prefix))
               )
            )
      )
    )
  )

(defun robot-mode-find-kw(continue)
  "Find the kw in region or in the line where the point is from TAGS.

If 'continue' is is non nil or interactively if the function is called
with a prefix argument (i.e. prefixed with \\[universal-argument]) then continue from the last
found kw.

\\<robot-mode-map>
This function is bound to \\[robot-mode-find-kw].
"
  (interactive "P")
  (if continue (robot-mode-continue-find-kw)
    (robot-mode-find-first-kw)
    )
  )

(define-derived-mode robot-mode fundamental-mode
  "robot mode"
  "Major mode for editing Robot Framework text files.

This mode rebinds the following keys to new function:
\\{robot-mode-map}
In the table above <remap> <function> means that the function is bound to whatever 
key <function> was bound previously. To see the actual key binding press enter on
top of the bound function. 

You can use \\[beginning-of-defun] to move to the beginning of the kw 
the cursor point is at and \\[end-of-defun] to move to the end of the kw. 
To select (i.e. put a region around) the whole kw definition press \\[mark-defun].
"
  (require 'etags)
  (set (make-local-variable 'font-lock-defaults) '(robot-mode-keywords))

  (set (make-local-variable 'comment-start) "#")
  (set (make-local-variable 'comment-start-skip) "#")

  (set (make-local-variable 'beginning-of-defun-function) (lambda()
                                                            (re-search-backward "^[^ \t\n]")
                                                            )
       )
  (set (make-local-variable 'end-of-defun-function) (lambda() 
                                                      (end-of-line)
                                                      (if (not (re-search-forward "^[^ \t\n]" nil t))
                                                          (goto-char (point-max))
                                                        (beginning-of-line)
                                                        )
                                                      )
       )

  (define-key robot-mode-map [remap find-tag] 'robot-mode-find-kw)
  (define-key robot-mode-map [remap complete-symbol] 'robot-mode-complete)
  )
   
