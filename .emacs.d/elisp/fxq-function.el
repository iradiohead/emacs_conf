;;如果你正在编辑一个东西（在位置A），突然想到别的某处（位置B）要修改或查看或别的，总之你要过去看看，你可以用C-.来在当前位置做个标记，然后去你想去的地方B，看了一会你觉的我可以回A去了，用C-,就回到刚才做标记的地方A，再用C-,又会回到B 
(global-set-key [(control ?.)] 'fxq-point-to-register) 
(global-set-key [(control ?\,)] 'fxq-jump-to-register) 
(defun fxq-point-to-register() 
  "Store cursorposition _fast_ in a register. 
Use fxq-jump-to-register to jump back to the stored 
position." 
  (interactive) 
  (setq zmacs-region-stays t) 
  (point-to-register 8)) 

(defun fxq-jump-to-register() 
  "Switches between current cursorposition and position 
that was stored with fxq-point-to-register." 
  (interactive) 
  (setq zmacs-region-stays t) 
  (let ((tmp (point-marker))) 
        (jump-to-register 8) 
        (set-register 8 tmp))) 

;;F7, 查找 TAGS 文件（更新 TAGS 表） 
;;C-F7, 在当前目录下生成包含所有递归子目录的 TAGS 文件（使用了shell中的find命令） 
;;C-. 开个小窗查看光标处的 tag 
;;C-, 只留下当前查看代码的窗口（关闭查看 tag 的小窗） 
;;C-M-, 提示要查找的 tag，并跳转 
;;C-M-. 要匹配的 tag 表达式（系统已定义） 
;;Shift-Tab, C/C++ 和 lisp 等模式中补全函数名（一般情况下M-Tab被窗口管理器遮屏了） 
(global-set-key [(f7)] 'visit-tags-table)         ; visit tags table
(global-set-key [C-f7] 'sucha-generate-tag-table) ; generate tag table
;;(global-set-key [(control .)] '(lambda () (interactive) (lev/find-tag t)))
;;(global-set-key [(control ,)] 'sucha-release-small-tag-window)
(global-set-key (kbd "C-M-,") 'find-tag)
(define-key lisp-mode-shared-map [(shift tab)] 'complete-tag)
(add-hook 'c-mode-common-hook      ; both c and c++ mode
          (lambda ()
            (define-key c-mode-base-map [(shift tab)] 'complete-tag)))

(defun sucha-generate-tag-table ()
  "Generate tag tables under current directory(Linux)."
  (interactive)
  (let 
      ((exp "")
       (dir ""))
    (setq dir
          (read-from-minibuffer "generate tags in: " default-directory)
          exp
          (read-from-minibuffer "suffix: "))
    (with-temp-buffer
      (shell-command
       (concat "find " dir " -name \"" exp "\" | xargs etags")
       (buffer-name)))))

(defun sucha-release-small-tag-window ()
"Kill other window also pop tag mark."
  (interactive)
  (delete-other-windows)
  (ignore-errors
    (pop-tag-mark)))
;; 这个忘了是从哪个地方弄来的，在保存~/.emacs文件自动编译为.elc文件 
;;目前只是对~/.emacs有效，其余的*.el文件还没有去弄，以后有空我会改的 
;;小知识：由于配置文件越来越大，你的*.el配置文件最好都编译为*.elc文件，这样在启动emacs速度会有很大的提升 
(defun autocompile nil 
  "compile itself if ~/.emacs" 
  (interactive) 
  (if (string= (buffer-file-name) (concat default-directory ".emacs"))
      (byte-compile-file (buffer-file-name)))) 
(add-hook 'after-save-hook 'autocompile) 


;;这个是从emacs-lisp-introduction的那个文档拷过来 
;;功能同word的计算文字数相似，不过这个功能有待完善，对中文不大好使 
     (defun fxq-recursive-count-words (region-end) 
       "Number of words between point and REGION-END." 
       (if (and (< (point) region-end) 
                (re-search-forward "\\w+\\W*" region-end t)) 
           (1+ (fxq-recursive-count-words region-end)) 
         0)) 
     (defun fxq-count-words-region (beginning end) 
       "Print number of words in the region.      
     Words are defined as at least one word-constituent 
     character followed by at least one character that is 
     not a word-constituent.  The buffer's syntax table 
     determines which characters these are." 
       (interactive "r") 
       (message "Counting words in region ... ") 
       (save-excursion 
         (goto-char beginning) 
         (let ((count (fxq-recursive-count-words end))) 
           (cond ((zerop count) 
                  (message 
                   "The region does NOT have any words.")) 
                 ((= 1 count) 
                  (message "The region has 1 word.")) 
                 (t 
                  (message 
                   "The region has %d words." count)))))) 


;;功能是将当前行设为本页第一行，同终端下的clear命令有点相似 
(defun fxq-line-to-top-of-window () 
  "Move the line point is on to top of window." 
  (interactive) 
  (recenter 0)) 
;;match-paren 将光标移到对应刮号位置
(defun match-paren (arg)
  "Go to the matching parenthesis if on parenthesis otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
		((looking-at "\\s\)") (forward-char 1) (backward-list 1))
		(t (self-insert-command (or arg 1)))))





;;; code-publish.el --- convert codes into html, used for msn space
;; Because of the limited allowed file types,
;; if the extension of this file is not .el, please change it manually.

;; Author: Qichen Huang <jasonal00+emacs at gmail.com>
;; Version: 0.2

;;; Commentary:
;; (require 'code-publish)

;; Usage:
;; M-x code-publish
;; the converted html code will be copied to kill-ring,
;; which could be directly pasted onto msn space as html code.

;; History:
;; 14.08.2006 Version 0.2
;; 14.08.2006  Added: tag <div>
;; 28.07.2006 Version 0.1

;;; Code:

(defun code-publish ()
  "Convert region between mark and point into HTML, save the result into kill ring."
  (interactive)
  (kill-new (code-publish-region (mark) (point)))
  (message "Code convert completed."))



(defvar font-header "<font size=\"2\">")
(defvar div-header "<div style=\"background-color:rgb(255,255,224);\">")
(defvar footer "</div></font>")
(defvar tag-open "<span style=\"font-family: Courier New,Courier,Monospace;")
(defvar tag-close ">")
(defvar tag-end "</span>")
(defvar newline-tag "<br>")
(defvar space "&nbsp;")
(defvar space2 "&nbsp;&nbsp;")
(defvar space4 "&nbsp;&nbsp;&nbsp;&nbsp;")

(defvar code-builtin-color       " color: rgb(0,139,0);\"")
(defvar code-comment-color       " color: rgb(205,0,0); font-style: italic;\"")
(defvar code-constant-color      " color: rgb(47,79,79);\"")
(defvar code-doc-color           " color: rgb(0,139,0);\"")
(defvar code-function-name-color " color: rgb(0,0,255); font-weight: bold;\"")
(defvar code-keyword-color       " color: rgb(160,32,240);\"")
(defvar code-preprocessor-color  " color: rgb(250,128,114);\"")
(defvar code-string-color        " color: rgb(0,139,0);\"")
(defvar code-type-color          " color: rgb(0,0,128);\"")
(defvar code-variable-name-color " color: rgb(139,90,40);\"")
(defvar code-warning-color       " color: rgb(255,0,0);\"")
(defvar code-default-color       " \"")

(defun code-publish-region (begin-point end-point)
  (let ((beg (min begin-point end-point))
        (end (max begin-point end-point))
        (str "")
        (tmp nil)
        (result nil)
        (tface nil)
        (color "")
        )
    ;;(beginning-of-buffer)
    (unless (= beg end)
      (save-excursion
        (setq result (concat result font-header))
        (setq result (concat result div-header))
        (goto-char beg)
        (while (< (point) end)
          (setq tmp (next-single-property-change (point) 'face))
          (unless tmp
            (setq tmp end)) ;; there is no face change, set tmp to end point
          ;; no cross-line properties
          (when (> tmp (line-end-position))
            (setq tmp (line-end-position))) ;; New line
          ;; skip spaces and tabs
          (save-excursion
            (goto-char tmp)
            (when (looking-at "[ \t]+")
              (re-search-forward "[ \t]+" (line-end-position) t)
              (setq tmp (point))))
          (when (> tmp end)
            (setq tmp end))
          (setq str (buffer-substring-no-properties (point) tmp))
          (while (string-match "<" str)
            (setq str (replace-match "&lt;" t nil str)))
          (while (string-match ">" str)
            (setq str (replace-match "&gt;" t nil str)))
          (while (string-match "  " str)
            (setq str (replace-match space2 t nil str)))
          (while (string-match "\t" str)
            (setq str (replace-match space4 t nil str)))
          (setq tface (get-text-property (point) 'face))
          (when (listp tface)
            (setq tface (car tface)))
          (cond
           ((eq tface font-lock-builtin-face)
            (setq color code-builtin-color))
           ((eq tface font-lock-comment-face)
            (setq color code-comment-color))
           ((eq tface font-lock-constant-face)
            (setq color code-constant-color))
           ((eq tface font-lock-doc-face)
            (setq color code-doc-color))
           ((eq tface font-lock-function-name-face)
            (setq color code-function-name-color))
           ((eq tface font-lock-keyword-face)
            (setq color code-keyword-color))
           ((eq tface font-lock-preprocessor-face)
            (setq color code-preprocessor-color))
           ((eq tface font-lock-string-face)
            (setq color code-string-color))
           ((eq tface font-lock-type-face)
            (setq color code-type-color))
           ((eq tface font-lock-variable-name-face)
            (setq color code-variable-name-color))
           ((eq tface font-lock-warning-face)
            (setq color code-warning-color))
           (t (setq color code-default-color)))
          ;; (setq color "<span color=\"\">")
          (setq result (concat result tag-open color tag-close str tag-end))
          (when (= tmp (line-end-position))
            (setq result (concat result newline-tag))
            (setq tmp (+ 1 (line-end-position))))
          (goto-char tmp))
        (setq result (concat result footer))
        result
        ))))

(provide 'code-publish)

;;; ################ code-publish ends here #######################
