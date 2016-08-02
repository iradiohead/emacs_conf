;;统一设置键帮定，并尽量放在配置文件的最后，以免被绑定的键不小心被后面的配置文件覆盖 

;;常用习惯，F1打开帮助，常用帮助有info和woman（就是在emacs中看man） 
;;kjin
;;(global-set-key [(f1)] 'info) 

;;kjin 
;;恢复，常用键 
(global-set-key [(f1)] 'undo) 
;;反恢复，不是很常用，但是绑定了还是方便些 
(global-set-key [(ctrl f1)] 'redo)

;;kjin add for bm
(global-set-key (kbd "<C-f2>") 'bm-toggle)
(global-set-key (kbd "<f2>")   'bm-next)
(global-set-key (kbd "<S-f2>") 'bm-previous)

;;高亮highlight
(global-set-key [(control f3)] 'highlight-symbol-at-point-2)
(global-set-key [f3] 'highlight-symbol-next)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
(global-set-key [(meta f3)] 'highlight-symbol-prev)
(global-set-key [(control meta f3)] 'highlight-symbol-query-replace)

;;F4,kill键，习惯设置，关闭当前buffer 
(global-set-key [(f4)] 'kill-this-buffer) 

;;打开一个终端，根据你的爱好可以绑定为：eshell,shell,terminal-emulator 
(global-set-key [(ctrl f5)] 'eshell) 
(global-set-key [(f5)] 'shell)

;;文件管理器，常用 
(global-set-key [(f6)] 'dired-jump)
(global-set-key [(ctrl f6)] 'dired-jump-other-window)

;;同clear相识，具体功能在fxq-functions.el讲过 
;;(global-set-key [(f7)] 'fxq-line-to-top-of-window) 

;;本人正在学scheme，常用 
;;(global-set-key [f8] 'run-scheme) 
;;打开我得日历 
;;(global-set-key [(f8)] 'calendar)

;;/* Added by kjin-F for ispell and flyspell mode 20120807*/
(global-set-key (kbd "<f8>") 'ispell-word)
(global-set-key (kbd "C-S-<f8>") 'flyspell-mode)
(global-set-key (kbd "C-M-<f8>") 'flyspell-buffer)
(global-set-key (kbd "C-<f8>") 'flyspell-check-previous-highlighted-word)
(defun flyspell-check-next-highlighted-word ()
  "Custom function to spell check next highlighted word"
  (interactive)
  (flyspell-goto-next-error)
  (ispell-word)
  )
(global-set-key (kbd "M-<f8>") 'flyspell-check-next-highlighted-word)

;;/* Added by kjin-F for adjusting font size 20130403 */
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

;;打开speedbar
(global-set-key [(f9)] 'bookmark-bmenu-list)
;;(global-set-key [(f9)] 'gnus) 

;;习惯设置，打开／关闭菜单 
(global-set-key [(f10)] 'menu-bar-mode) 
;;/*2007/6/13 added by Fu to set key for listing bookmark and adding current bookmark*/
;; (global-set-key [(f11)] 'list-bookmarks)
(global-set-key [(f11)] 'bookmark-jump)
(global-set-key [(f12)] 'bookmark-set)
;;编译等，暂时还不常用 
;;(global-set-key [f11] 'compile) 
;;(global-set-key [f12] 'gdb) 

;;习惯设置，Home键设定光标到文件开头 
(global-set-key [(home)] 'beginning-of-buffer) 
;;习惯设置，End键设定光标到文件结尾 
(global-set-key [(end)] 'end-of-buffer) 

;;添加清除备注
(global-set-key (kbd "C-c C-c") 'comment-region) 
(global-set-key (kbd "C-c C-v") 'uncomment-region) 

;;打开ECB compile window
(global-set-key (kbd "C-c t") 'ecb-toggle-compile-window) 

;;Hide/Show Related shortcut 17/12/2010
;;   hs-hide-block                      C-c @ C-h
;;   hs-show-block                      C-c @ C-s
;;   hs-hide-all                        C-c @ C-M-h
;;   hs-show-all                        C-c @ C-M-s
;;   hs-hide-level                      C-c @ C-l
;;   hs-toggle-hiding                   C-c @ C-c
(global-set-key (kbd "C-c h") 'hs-hide-block) 
(global-set-key (kbd "C-c x") 'hs-show-block) 
(global-set-key (kbd "C-c l") 'hs-hide-level) 
(global-set-key (kbd "C-c c") 'hs-toggle-hiding) 

;; Add by kjin-F to occur mode on 20121016
(define-key occur-mode-map "n" 'next-error-no-select)
(define-key occur-mode-map "p" 'previous-error-no-select)
(define-key occur-mode-map " " 'occur-mode-display-occurrence)
(define-key occur-mode-map "o" (lambda () (interactive)
                                 (occur-mode-goto-occurrence)
                                 (delete-other-windows)))
;;meta在常用PC键上就是Alt键 
;;这三个绑定主要是光标移动的 
(global-set-key [(meta up)]   'goto-line) 
(global-set-key [(meta down)] 'goto-line) 
(global-set-key [(meta left)] 'backward-sexp) 
(global-set-key [(meta right)] 'forward-sexp) 
(define-key esc-map [up]   'goto-line)
(define-key esc-map [down] 'goto-line)
(define-key esc-map [left] 'backward-sexp)
(define-key esc-map [down] 'forward-sexp)

(global-set-key [(meta p)] 'beginning-of-defun) 
(global-set-key [(meta n)] 'end-of-defun) 
(global-set-key [(meta m)] 'pop-to-mark-command) 
(global-set-key [(meta return)] 'pop-global-mark) 

;; find tag in another buffer 20091231
(global-set-key [(control .)] 'find-tag-other-window) 

;; refresh buffer
(global-set-key (kbd "C-c r") 'revert-buffer) 

;;用Emacs时常用多个窗口，窗口之间的移动很常见
(global-set-key [(meta o)] 'other-window)

;;这个设置是改变outline的快捷键前缀 
;;outline主要用于编程等，目前用的不多 
(setq outline-minor-mode-prefix [(control o)]) 

;;默认的Ctrl-z是什么来着，关闭emacs吧，好像还是强行关闭，不好，用C-x c就好了 
;;我就将Ctrl-z作为我的键的绑定 
(define-prefix-command 'ctl-z-map) 
(global-set-key (kbd "C-z") 'ctl-z-map) 
;;编译当前emacs-lisp源码为elc 
(global-set-key (kbd "C-z b") 'emacs-lisp-byte-compile) 
;;打开我的计算器
(global-set-key (kbd "C-z c") 'calculator) 
;;字典功能，就是查单词 
(global-set-key (kbd "C-z d d") 'dictionary-lookup-definition) 
;;与上面类似 
(global-set-key (kbd "C-z d s") 'dictionary-search) 
;;查询当前单词的匹配的单词，用于补全单词 
(global-set-key (kbd "C-z d m") 'dictionary-match-words) 
;;字典提示模式，同字典的自动取词功能相似 
(global-set-key (kbd "C-z d t") 'dictionary-tooltip-mode) 
;;Toggle ECB windows ON/OFF
(global-set-key (kbd "C-z e e") 'ecb-toggle-ecb-windows)
(global-set-key (kbd "C-z e l") 'ecb-toggle-layout)
;;启动我的IRC客户端，到sir去 
;;(global-set-key (kbd "C-z e s") 'erc-irc) 
;;到fans聊天去 
;;(global-set-key (kbd "C-z e f") 'erc-fans) 
;;启动拼写检查模式，只检查打开后输入的单词 
(global-set-key (kbd "C-z f m") 'flyspell-mode) 
;;对整个buffer进行拼写检查 
(global-set-key (kbd "C-z f b") 'flyspell-buffer) 
;;打开gnus 
(global-set-key (kbd "C-z g") 'gnus) 
;;数数本文件有多少文字 
(global-set-key (kbd "C-z h c") 'fxq-count-words-region) 
;;同Clear键 
(global-set-key (kbd "C-z h l") 'fxq-line-to-top-of-window) 
;;拼写检查 
(global-set-key (kbd "C-z i") 'ispell-minor-mode) 
;;debug 
(global-set-key (kbd "C-z j") 'jdb) 
;;查看前面删除的内容记录 
(global-set-key (kbd "C-z k") 'browse-kill-ring) 
;;Toggle line number mode 
(global-set-key (kbd "C-z l") 'wb-line-number-toggle) 
;;启动我得maxima，漂亮模式 
(global-set-key (kbd "C-z m") 'imaxima) 
;;绑定两个narrow功能 
(global-set-key (kbd "C-z n n") 'narrow-to-region) 
(global-set-key (kbd "C-z n w") 'widen) 
(global-set-key (kbd "C-z o") 'occur) 
;;几个小游戏 
(global-set-key (kbd "C-z p g") 'gomoku) 
(global-set-key (kbd "C-z p t") 'tetris) 
;;由于在html-helper-mode模式中F4键失效，用这个绑定来关闭buffer 
(global-set-key (kbd "C-z q") 'kill-this-buffer) 
;;将marked文件带正则表达式的搜索 
(global-set-key (kbd "C-z r") 'dired-do-query-replace-regexp) 
;;我得scheme也是可以在emacs中运行的
(global-set-key (kbd "C-z s") 'run-scheme) 
;;我的终端 
(global-set-key (kbd "C-z t") 'term) 
;;可以在emacs编辑文件使用vim习惯，常用的是vi-mode和viper-mode 
(global-set-key (kbd "C-z v") 'vi-mode) 
;;我的文件管理器 
;; (global-set-key (kbd "C-z u d") 'dired-jump) 
;; (global-set-key (kbd "C-z u f") 'folding-mode) 
;; (global-set-key (kbd "C-z u o") 'outline-minor-mode) 
;;查询service，见fxq-other-elisp 
(global-set-key (kbd "C-z u s") 'services-look-up) 
;;wiki中的绑定设置，还用的不多 
(global-set-key (kbd "C-z w c") 'emacs-wiki-change-project) 
(global-set-key (kbd "C-z w f") 'emacs-wiki-find-file) 
(global-set-key (kbd "C-z w h") 'emacs-wiki-preview-html) 
(global-set-key (kbd "C-z w i") 'emacs-wiki-index) 
(global-set-key (kbd "C-z w p") 'emacs-wiki-publish) 
(global-set-key (kbd "C-z w s") 'emacs-wiki-search) 
;;我的浏览器 
(global-set-key (kbd "C-z w w") 'w3m) 
;;同C-z b有点不同，在编译后并加载 
(global-set-key (kbd "C-z x") 'emacs-lisp-byte-compile-and-load) 
;;同yank有点不一样，但具体怎样忘了，感觉这个比yank好点 
(global-set-key (kbd "C-z y") 'clipboard-yank) 
;;修改后的设定mark的绑定，由于经常忘了放住control键，就给这个功能两个绑定了 
(global-set-key (kbd "C-z z") 'set-mark-command) 
(global-set-key (kbd "C-z C-z") 'set-mark-command) 
;;run rgrep command
(global-set-key (kbd "C-z C-s") 'rgrep) 
(setq grep-find-command "find . ! -name \"*svn*\" -type f -print0 | \"xargs\" -0 -e grep -in -ie ")

;;there are severl other key-map below in other files 
;;ctrl-f-folding-mode-prefix 
;;ido key-map 
;;severl self define functions related key-bindings. 

;; ;;; browse-url setting
(require 'browse-url)
(global-set-key [S-mouse-2] 'browse-url-at-mouse)

;;; Match-paren
;;  go to corresponding paren
(define-key emacs-lisp-mode-map "%" 'match-paren)
(global-set-key "%" 'match-paren) 

; M-? help-for-help
(global-set-key "\M-?" 'help-for-help)

; Compile
(global-set-key "\C-x\C-y" 'compile)

;; Add by kjin-F to replace Alt-x method on 20120416
;(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)

;; Add by kjin-F to modify ctrl-w on 20120416
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)

;; Use ALt-? for help command
(global-set-key "\M-?" 'help)

;;/*2007/6/8 added by Fu to set "make -k" to "make"*/
'(compile-command "make")
;;/*2007/6/23 added by Fu to "C-x C-b"*/
(global-set-key "\C-x\C-b" 'electric-buffer-list)
;;/*2007/6/23 added by Fu to keep end when next-line"*/
(setq track-eol t)
;;/*2007/6/23 added by Fu to show the binding keys when used "M-x COMMAND""*/
(setq suggest-key-bindings 1)
;;/*2007/6/13 added by Fu to set speedbar*/
(global-set-key (kbd "M-s") 'ecb-goto-window-directories)

;; his-speedbar-no-separate-frame
(defconst his-speedbar-buffer-name "SPEEDBAR")
(defun his-speedbar-no-separate-frame ()
  (intERACTIVE)
  (when (not (buffer-live-p speedbar-buffer))
    (setq speedbar-buffer (get-buffer-create his-speedbar-buffer-name)
          speedbar-frame (selected-frame)
          dframe-attached-frame (selected-frame)
          speedbar-select-frame-method 'attached
          speedbar-verbosity-level 0
          speedbar-last-selected-file nil)
    (set-buffer speedbar-buffer)
    (speedbar-mode)
    (speedbar-reconfigure-keymaps)
    (speedbar-update-contents)
    (speedbar-set-timer 1)
    (make-local-hook 'kill-buffer-hook)
    (add-hook 'kill-buffer-hook
              (lambda () (when (eq (current-buffer) speedbar-buffer)
                           (setq speedbar-frame nil
                                 dframe-attached-frame nil
                                 speedbar-buffer nil)
                           (speedbar-set-timer nil)))))
  (set-window-buffer (selected-window)
                     (get-buffer his-speedbar-buffer-name)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; ;;Setting for cscope
(global-set-key (kbd "C-c s d") 'cscope-find-this-symbol)
(global-set-key (kbd "C-c s g") 'cscope-find-global-definition)
(global-set-key (kbd "C-c s G") 'cscope-find-global-definition-no-prompting)
(global-set-key (kbd "C-c s c") 'cscope-find-functions-calling-this-function)
(global-set-key (kbd "C-c s C") 'cscope-find-called-functions)
(global-set-key (kbd "C-c s t") 'cscope-find-this-text-string)
(global-set-key (kbd "C-c s e") 'cscope-find-egrep-pattern)
(global-set-key (kbd "C-c s f") 'cscope-find-this-file)
;; (define-key global-map [(control f3)]  'cscope-set-initial-directory)
;; (define-key global-map [(control f4)]  'cscope-unset-initial-directory)
;; (define-key global-map [(control f5)]  'cscope-find-this-symbol)
;; (define-key global-map [(control f6)]  'cscope-find-global-definition)
;; ;;(define-key global-map [(control f7)]
;; ;;	  'cscope-find-global-definition-no-prompting)
;; (define-key global-map [(control f8)]  'cscope-pop-mark)
;; (define-key global-map [(control f9)]  'cscope-next-symbol)
;; (define-key global-map [(control f10)] 'cscope-next-file)
;; (define-key global-map [(control f11)] 'cscope-prev-symbol)
;; (define-key global-map [(control f12)] 'cscope-prev-file)
;; (define-key global-map [(meta f9)]  'cscope-display-buffer)
;; (define-key global-map [(meta f10)] 'cscope-display-buffer-toggle)

;;kjin
(global-linum-mode t) ;; buildin 

;;kjin copy line if no region selected
;; copy region or whole line
(global-set-key "\M-w"
(lambda ()
  (interactive)
  (if mark-active
      (kill-ring-save (region-beginning)
      (region-end))
    (progn
     (kill-ring-save (line-beginning-position)
     (line-end-position))
     (message "copied line")))))

;;kjin --this have some issue so comment it(C-c C-c / C-c C-v)  kill region or whole line
;; (global-set-key "\C-x\C-k"
;; (lambda ()
;;   (interactive)
;;   (if mark-active
;;       (kill-region (region-beginning)
;;    (region-end))
;;     (progn
;;      (kill-region (line-beginning-position)
;;   (line-end-position))
;;      (message "killed line")))))
