;;设置你的全名和邮件，在发邮件时可以用到
(setq user-full-name "radiohead")
(setq user-mail-address "kjin1983@gmail.com")

;;设置你的书签文件，默认是~/.emacs.bmk，我喜欢把有关emacs的文件尽量放在一个文件夹，所以就修改了。
(setq bookmark-default-file "~/.emacs.d/.emacs.bmk")

;;load-path就同bash中的$PATH相似，emacs所需要的Elisp包都得在load-path里的文件夹中，~/.emacs.d/elisp是我自己添加的Elisp包
(setq load-path (cons "~/.emacs.d/elisp" load-path))

;;设置info的路径，也可通过Shell的全局变量$INFOPATH设置 ;kjin set INFOPATH=%emacs_dir%\share\info , no need to set below
;;(add-to-list 'Info-default-directory-list "~/local/info/")

;;设置gnus启动的文件。默认是为~/.gnus.el   ;kjin Emacs Gnus 是 Emacs 用来收发邮件与上新闻组的一个模式
(setq gnus-init-file "~/.emacs.d/elisp/jk-gnus.el")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;kjin put to here because it can be overlapped by jk-basic-config.el later
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
 '(column-number-mode t)
 '(custom-enabled-themes (quote (tango-dark)))
 '(display-time-mode t)
 '(ecb-gzip-setup (quote cons))
 '(ecb-options-version "2.40")
 '(ecb-source-path (quote ("d:/Dropbox/emacs_doc/")))
 '(ecb-tar-setup (quote cons))
 '(ecb-wget-setup (quote cons))
 '(show-paren-mode t)
 '(tabbar-buffer-groups-function (quote tabbar-buffer-ignore-groups) t)
 '(tabbar-buffer-list-function (quote tabbar-buffer-list) t)
 '(tabbar-cycling-scope nil)
 '(tabbar-mode t nil (tabbar))
 '(transient-mark-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;由于我的配置文件很长，所以按照分类分别放在不同的文件里，方便管理
(load "jk-basic-config")
(load "jk-language")
(load "jk-calendar")
(load "fxq-folding")
;;(load "fxq-ido")
;;(load "fxq-dictionary")
(load "fxq-function")
;;(load "fxq-mew")
(load "fxq-w3m")
;;(load "fxq-erc")
(load "fxq-dired")
(load "fxq-mode")
(load "jk-key-bindings")
(load "fxq-tnsdl")
;;kjin(load "fxq-robot-mode")
;;kjin(load "fxq-python-mode")
;;(load "fxq-ipython-mode")
(load "fxq-psvn");;SVN(SubVersion) plugin
(load "fxq-plm");;PL/M highlight
;;(load "plm-mode");;PL/M highlight
;; (load "color-theme")
(load "ascii-table")

(load "highlight-symbol")
(require 'highlight-symbol)
(add-hook 'text-mode-hook 'highlight-symbol-mode)
(add-hook 'c-mode-hook 'highlight-symbol-mode)
(add-hook 'c++-mode-hook 'highlight-symbol-mode)
(add-hook 'tnsdl-mode-hook 'highlight-symbol-mode)
(add-hook 'java-mode-hook 'highlight-symbol-mode)
(add-hook 'perl-mode-hook 'highlight-symbol-mode)
(add-hook 'php-mode-hook 'highlight-symbol-mode)
(add-hook 'emacs-lisp-mode-hook 'highlight-symbol-mode)
(load "highlight-parentheses")
(require 'highlight-parentheses)
(add-hook 'c-mode-hook 'highlight-parentheses-mode)
(add-hook 'c++-mode-hook 'highlight-parentheses-mode)
(add-hook 'tnsdl-mode-hook 'highlight-parentheses-mode)
(add-hook 'java-mode-hook 'highlight-parentheses-mode)
(add-hook 'perl-mode-hook 'highlight-parentheses-mode)
(add-hook 'php-mode-hook 'highlight-parentheses-mode)
(add-hook 'emacs-lisp-mode-hook 'highlight-parentheses-mode)

;;(load "webkit")
;;(require 'webkit)

(add-to-list 'load-path
   "~/.emacs.d/elisp/iedit")
(load "iedit")
(require 'iedit)

(add-to-list 'load-path
             "~/.emacs.d/elisp/git-emacs-master/")
(load "git-emacs")
(require 'git-emacs)

(load "yasnippet-bundle")
(require 'yasnippet)
(setq yas/root-directory "~/.emacs.d/snippets")
(yas/load-directory yas/root-directory)
(yas/global-mode 1)

;;(add-to-list 'load-path
;;             "~/.emacs.d/elisp/demo-it-master")
;;(load-library "demo-it")   ;; Load this library of functions

(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)

;;Setting for gnuserv
(require 'gnuserv)
(gnuserv-start)
;; 在当前frame打开
(setq gnuserv-frame (selected-frame))
;; 打开后让emacs跳到前面来
(setenv "GNUSERV_SHOW_EMACS" "1")

;;强大的自动补齐功能
;; ensure abbrev mode is always on
(setq-default abbrev-mode t)
;; do not bug me about saving my abbreviations
(setq save-abbrevs nil)

;; load up modes I use
(require 'cc-mode)
(require 'perl-mode)
(require 'cperl-mode)
(require 'sh-script)
(require 'shell)
;;(require 'tex-site) ;; I use AUCTeX
;;(require 'latex)    ;; needed to define LaTeX-mode-hook under AUCTeX
;;(require 'tex)      ;; needed to define TeX-mode-hook under AUCTeX
;;(require 'python)   ;; I use python.el from Emacs CVS, uncomment if you do also
(setq auto-mode-alist
	  (cons '("\\.py$" . python-mode) auto-mode-alist))
(setq interpreter-mode-alist
	  (cons '("python" . python-mode)
			interpreter-mode-alist))
(autoload 'python-mode "python-mode" "Python editing mode." t)
;;; add these lines if you like color-based syntax highlighting
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

;;(setq ipython-command "D:\Program Files\Python25\Lib\site-packages\IPython")
;;(require 'ipython)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; redo.el
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'redo)
(tool-bar-add-item "stock_redo"
                   'redo
                   'redo
                   :help "Redo(control f3)")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; find-recursive.el
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'find-recursive)

;;(load "maxima")
;;(setq auto-mode-alist (cons '("\\.max" . maxima-mode) auto-mode-alist))
;(setq load-path (cons "D:\Program Files\Maxima-5.12.0\share\maxima\5.12.0\emacs" load-path ))
;;(autoload 'maxima "maxima" "Running Maxima interactively" t)
;;(autoload 'maxima-mode "maxima" "Maxima editing mode" t)

;;add line number for display
;;kjin comment it(require 'wb-line-number)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; psvn.el
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; combined the SVN(SubVersion) in emacs
(require 'psvn)

;;代码折叠
(load-library "hideshow")
(add-hook 'c-mode-hook 'hs-minor-mode)
(add-hook 'c++-mode-hook 'hs-minor-mode)
(add-hook 'tnsdl-mode-hook 'hs-minor-mode)
(add-hook 'java-mode-hook 'hs-minor-mode)
(add-hook 'perl-mode-hook 'hs-minor-mode)
(add-hook 'php-mode-hook 'hs-minor-mode)
(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
;;
;;   hs-hide-block                      C-c @ C-h
;;   hs-show-block                      C-c @ C-s
;;   hs-hide-all                        C-c @ C-M-h
;;   hs-show-all                        C-c @ C-M-s
;;   hs-hide-level                      C-c @ C-l
;;   hs-toggle-hiding                   C-c @ C-c
;;   hs-mouse-toggle-hiding             [(shift mouse-2)]
;;   hs-hide-initial-comment-block

;;Add tramp plink method by kjin-F on 20120412
;;(require 'tramp)
;;(setq tramp-default-method "plink")
;;(setq tramp-auto-save-directory "~/.emacs.tmp")
;;(let ((my-tramp-methods nil)  
;;      (my-tramp-ssh-method   
;;       '("ssh"   
;;         (tramp-login-program "ssh")   
;;         (tramp-login-args (("%h")   
;;                            ("-l" "%u")  
;;                            ("-p" "%p")   
;;                            ("-e" "none")   
;;                            ("-A")))  
;;         (tramp-remote-sh "C:/APPS/cygwin/bin")   
;;         (tramp-copy-program nil)   
;;         (tramp-copy-args nil)  
;;         (tramp-copy-keep-date nil)  
;;         (tramp-password-end-of-line nil)   
;;         (tramp-gw-args (("-o" "GlobalKnownHostsFile=/dev/null")   
;;                         ("-o" "UserKnownHostsFile=/dev/null")  
;;                         ("-o" "StrictHostKeyChecking=no")))   
;;         (tramp-default-port 22))))  
;;  (setq tramp-methods (dolist (elt tramp-methods my-tramp-methods)  
;;    (if (string= (car elt) "ssh")  
;;        (setq my-tramp-methods (cons my-tramp-ssh-method my-tramp-methods))  
;;      (setq my-tramp-methods (cons elt my-tramp-methods))))))  



;; added by kjin-F on 09072012 for adding auto-complete function
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/site-lisp/auto-complete/ac-dict")
(ac-config-default)
(ac-set-trigger-key "TAB")
(ac-set-trigger-key "<tab>")
(global-auto-complete-mode t)


;;(require 'auto-complete-clang)  

;; added by kjin-F on 07082012 for Aspell function ;;kjin http://aspell.net/win32/
(add-to-list 'exec-path "C:/Program Files (x86)/Aspell/bin/")
(setq ispell-program-name "aspell")
(setq ispell-personal-dictionary "D:/emacs_conf/.emacs.d/ispell.el")
(require 'ispell)

;; added by kjin-F on 30072013 for ignoring different directory and file in special mode
;; (require 'ignoramus)
;; (ignoramus-setup)

;; added by kjin-F on 15112013 to use whitespace
(require 'whitespace)

;;(setq ecb-auto-activate t)

;;(find-file "D:/emacs/diary/TimeQuadrant.org")
;;(find-file "D:/Current_Task/Source/Preprocessor_Source/PPLIST_SPM/pplist.var")
;;(find-file "D:/Dropbox/emacs_docs/temp.txt")
;;(find-file "D:/Dropbox/emacs_docs/my_todo_list.org")
;;(find-file "D:/emacs_conf/.emacs.d/.emacs.bmk")

;;kjin
(require 'bm)

;;这个东西必须放在最后
;;desktop.el是一个可以保存你上次emacs关闭时的状态，下一次启动时恢复为上次关闭的状态。就和vmware的suspend一样。
(load "desktop") 
;(desktop-save-mode) 
;(desktop-read)

(c-set-offset 'case-label '+)
(put 'upcase-region 'disabled nil)



;; add tab mode by kjin-F on 20120413
(require 'tabbar)  
(tabbar-mode 1)  	
(define-prefix-command 'lwindow-map)
;;kjin add for tabbar color, this needed if customize-theme choosed!
(setq tabbar-buffer-list-function
    (lambda ()
        (remove-if
          (lambda(buffer)
             (find (aref (buffer-name buffer) 0) " *"))
          (buffer-list))))
(setq tabbar-buffer-groups-function
      (lambda()(list "All")))
(set-face-attribute 'tabbar-button nil)

;;set tabbar's backgroud color
(set-face-attribute 'tabbar-default nil
                    :background "gray"
                    :foreground "gray30")
(set-face-attribute 'tabbar-selected nil
                    :inherit 'tabbar-default
                    :background "green"
                    :box '(:line-width 3 :color "DarkGoldenrod") )
(set-face-attribute 'tabbar-unselected nil
                    :inherit 'tabbar-default
                    :box '(:line-width 3 :color "gray"))
;; USEFUL: set tabbar's separator gap
(custom-set-variables '(tabbar-separator (quote (1.5))))


;;python support 2016-10-24
(require 'python-mode)
(add-to-list 'auto-mode-alist '("\\.py'" . python-mode))


;;kjin org mode export chinese pdf xelatex
(setq org-latex-pdf-process '("xelatex -interaction nonstopmode %f"
							  "xelatex -interaction nonstopmode %f"))

(setq org-latex-to-pdf-process
'("xelatex -interaction nonstopmode %f"
"xelatex -interaction nonstopmode %f"))
;; (require 'org-latex)
;; (add-to-list 'org-export-latex-classes
;;              '("yivanus"
;;                "\\documentclass{ctexart}"
;;                ("\\section{%s}" . "\\section*{%s}")
;;                ("\\subsection{%s}" . "\\subsection*{%s}")
;;                ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
;;                ("\\paragraph{%s}" . "\\paragraph*{%s}")
;;                ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))


(require 'ox-latex)
(unless (boundp 'org-latex-classes)
  (setq org-latex-classes nil))
(add-to-list 'org-latex-classes
             '("article"
               "\\documentclass{article}"
               ("\\section{%s}" . "\\section*{%s}")))

(add-to-list 'org-latex-classes
             '("article"
               "\\documentclass{article}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
