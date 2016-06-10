;;设置你的全名和邮件，在发邮件时可以用到
(setq user-full-name "radiohead")
(setq user-mail-address "kjin1983@gmail.com")
;;设置你的书签文件，默认是~/.emacs.bmk，我喜欢把有关emacs的文件尽量放在一个文件夹，所以就修改了。
(setq bookmark-default-file "~/.emacs.d/.emacs.bmk")
;;load-path就同bash中的$PATH相似，emacs所需要的Elisp包都得在load-path里的文件夹中，~/.emacs.d/elisp是我自己添加的Elisp包
(setq load-path (cons "~/.emacs.d/elisp" load-path))
;;设置info的路径，也可通过Shell的全局变量$INFOPATH设置
(add-to-list 'Info-default-directory-list "~/local/info/")
;;设置gnus启动的文件。默认是为~/.gnus.el
(setq gnus-init-file "~/.emacs.d/elisp/fxq-gnus.el")
;;由于我的配置文件很长，所以按照分类分别放在不同的文件里，方便管理
(load "jk-basic-config")
(load "fxq-language")
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
(load "fxq-key-bindings")
(load "fxq-tnsdl")
(load "fxq-robot-mode")
(load "fxq-python-mode")
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
(require 'wb-line-number)

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

;;Add tramp plink method by Ferry on 20120412
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

;; add tab mode by Ferry on 20120413
(require 'tabbar)  
(tabbar-mode 1)  	
(define-prefix-command 'lwindow-map)

;; added by Ferry on 09072012 for adding auto-complete function
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/site-lisp/auto-complete/ac-dict")
(ac-config-default)
(ac-set-trigger-key "TAB")
(ac-set-trigger-key "<tab>")
(global-auto-complete-mode t)

;; added by Ferry on 07082012 for Aspell function
(add-to-list 'exec-path "C:/Program Files (x86)/Aspell/bin/")
(setq ispell-program-name "aspell")
(setq ispell-personal-dictionary "D:/emacs/.emacs.d/ispell.el")
(require 'ispell)

;; added by Ferry on 30072013 for ignoring different directory and file in special mode
;; (require 'ignoramus)
;; (ignoramus-setup)

;; added by Ferry on 15112013 to use whitespace
(require 'whitespace)

;;(setq ecb-auto-activate t)

;;(find-file "D:/Current_Task/Source/RCYVSP/Makefile")
;;(find-file "D:/emacs/diary/TimeQuadrant.org")
;;(find-file "D:/Current_Task/Source/Preprocessor_Source/PPLIST_SPM/pplist.var")
(find-file "D:/Dropbox/emacs_testfolder/temp.txt")

;;这个东西必须放在最后
;;desktop.el是一个可以保存你上次emacs关闭时的状态，下一次启动时恢复为上次关闭的状态。就和vmware的suspend一样。
(load "desktop") 
;; (desktop-save-mode) 
;; (desktop-read)


(c-set-offset 'case-label '+)
