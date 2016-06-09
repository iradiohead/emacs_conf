;; 设置背景颜色和字体颜色
(setq default-frame-alist
      (append (list '(foreground-color . "white")
            '(background-color . "black")
            '(background-color . "gray")
            '(border-color . "grey")
            '(mouse-color . "mediumpurple")
            '(cursor-color . "white")
;;          '(ime-font . (w32-logfont "ＭＳ ゴシック"
;;                        0 16 400 0 nil nil nil
;;                        128 1 3 49)) ; TrueType のみ
;;          '(font . "bdf-fontset")    ; BDF
;;          '(font . "private-fontset"); TrueType
            '(width . 80)
            '(height . 35)
            '(top . 50)
            '(left .100))
          default-frame-alist))

;;不要让光标闪烁(blink-cursor-mode -1)
;; 设置另外一些颜色：语法高亮显示的背景和主题，区域选择的背景和主题，二次选择的背景和选择
(set-face-foreground 'highlight "white")
(set-face-background 'highlight "black")
(set-face-foreground 'region "cyan")
(set-face-background 'region "black")
(set-face-foreground 'secondary-selection "skyblue")
(set-face-background 'secondary-selection "darkblue")

;;Other spcified color-theme
;;(require 'color-theme)
;;(color-theme-dark-laptop)
;;set the menu colors and font using the menu face.
;;(set-face-font 'menu "7x14")
;;(set-default-font "Courier New-10")
(set-default-font "Courier New-12")
(set-face-foreground 'menu "white")
;;;Tab is 4
;; 强制输入Tab时：C-q C-i
;;Forced set tab width
(setq default-tab-width 4)
;; 2012/06/30 Forced replace tab width with some whitespace
(setq-default indent-tabs-mode nil)
;; 2012/07/02 Set default TAGS file
;;(setq tags-file-name "D:/Current_Task/Source/RCY/ALL/TAGS_ALL")

;;/*2007/6/13 added by Fu to set path for cygwin*/
;;  ;; This assumes that Cygwin is installed in C:\cygwin (the
;;  ;; default) and that C:\cygwin\bin is not already in your
;;  ;; Windows Path (it generally should not be).
;;  ;;
;; (setenv "PATH" (concat "d:/emacs/cygwin64/bin;" (getenv "PATH")))
;; (setq exec-path (cons "d:/emacs/cygwin64/bin" exec-path))
(setenv "PATH" (concat "C:/APPS/cygwin/bin;" (getenv "PATH")))
(setq exec-path (cons "C:/APPS/cygwin/bin" exec-path))
(require 'cygwin-mount)
(cygwin-mount-activate)
(setenv "CYGWIN" "nodosfilewarning")

(defadvice grep-compute-defaults (around grep-compute-defaults-advice-null-device)
  "Use cygwin's /dev/null as the null-device."
  (let ((null-device "/dev/null"))
    ad-do-it))
(ad-activate 'grep-compute-defaults)

;;;Cancel mouse setting
(setq w32-hide-mouse-on-key t)
(setq w32-hide-mouse-timeout 5000)


(require 'w32-browser)
(eval-after-load "dire"
  '(define-key dired-mode-map [f3] (lambda()
                                     (internactive)
                                     (w32-browser
                                      (dired-replace-in-string
                                       "/" "\\"
                                       9dired-get-filename)))))
(setq print-region-function 'w32-print-region)

;;设置日历的一些颜色
(setq calendar-load-hook
'(lambda ()
(set-face-foreground 'diary-face "skyblue")
(set-face-background 'holiday-face "slate blue")
(set-face-foreground 'holiday-face "white")))

;;外观设置
;;去掉工具栏
;;(tool-bar-mode nil)
(tool-bar-mode -1)
;;去掉菜单栏，我将F10绑定为显示菜单栏，万一什么东西忘了，需要菜单栏了可以摁F10调出，再摁F10就去掉菜单
;;(menu-bar-mode nil)
(menu-bar-mode -1)
;;不要滚动栏，现在都用滚轴鼠标了，可以不用滚动栏了
;;(scroll-bar-mode nil)
(scroll-bar-mode -1)

;;备份设置
;;emacs还有一个自动保存功能，默认在~/.emacs.d/auto-save-list里，这个非常有用，我这里没有改动，具体可以参见Sams teach yourself emacs in 24hours(我简称为sams24)
;;启用版本控制，即可以备份多次
(setq version-control t)
;;备份最原始的版本两次，记第一次编辑前的文档，和第二次编辑前的文档
(setq kept-old-versions 2)
;;备份最新的版本五次，理解同上
(setq kept-new-versions 5)
;;删掉不属于以上7中版本的版本
(setq delete-old-versions t)
;;备份设置方法，直接拷贝
(setq backup-by-copying t)

;; disable auto-save and auto-backup
;; (setq auto-save-default nil)
;; (setq make-backup-files nil)

;; store all backup and autosave files in the tmp dir
;;设置备份文件的路径
(setq backup-directory-alist
      '((".*" . "~/.emacs.d/auto-save-list")))
(setq auto-save-file-name-transforms
      '((".*" "~/.emacs.d/auto-save-list" t)))

(setq fast-lock-cache-directories '("~/.emacs-flc" "."))

;;自动补全功能，这事从王垠的网站直接Copy过来的，引用一些他对此的说明
;;你可以设置以下 hippie-expand 的补全方式。它是一个优先列表， hippie-expand 会优先使用表最前面的函数来补全
;;这是说，首先使用当前的buffer补全，如果找不到，就到别的可见的窗口里寻找，如果还找不到，那么到所有打开的buffer去找，如果还……那么到kill-ring里，到文件名，到简称列表里，到list，…… 当前使用的匹配方式会在 echo 区域显示。
;;特别有意思的是 try-expand-line，它可以帮你补全整整一行文字。我很多时后有两行文字大致相同，只有几个字不一样，但是我懒得去拷贝粘贴以下。那么我就输入这行文字的前面几个字。然后多按几下 M-/ 就能得到那一行。
(global-set-key [(meta ?/)] 'hippie-expand)
(setq hippie-expand-try-functions-list
      '(try-expand-line
        try-expand-line-all-buffers
        try-expand-list
        try-expand-list-all-buffers
        try-expand-dabbrev
        try-expand-dabbrev-visible
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-complete-file-name
        try-complete-file-name-partially
        try-complete-lisp-symbol
        try-complete-lisp-symbol-partially
        try-expand-whole-kill))

;;时间戳设置(time-stamp)，设定文档上次保存的信息
;;只要里在你得文档里有Time-stamp:的设置，就会自动保存时间戳
;;启用time-stamp
(setq time-stamp-active t)
;;去掉time-stamp的警告？
(setq time-stamp-warn-inactive t)
;;设置time-stamp的格式，我如下的格式所得的一个例子：<hans 05/18/2004 12:01:12>
(setq time-stamp-format "%:u %02m/%02d/%04y %02H02M02S")
;;将修改时间戳添加到保存文件的动作里。
(add-hook 'write-file-hooks 'time-stamp)

;;时间显示设置
;;启用时间显示设置，
(display-time-mode 1)
;;时间使用24小时制
(setq display-time-24hr-format t)
;;时间显示包括日期和具体时间
(setq display-time-day-and-date t)
;;时间栏旁边启用邮件设置
(setq display-time-use-mail-icon t)
;;时间的变化频率，单位多少来着？
(setq display-time-interval 10)

;;启用minibuffer，好像是默认设置吧
(minibuffer-electric-default-mode 1)
;;启用部分补全功能，如输入M-x q r r相当于M-x query-replace-regexp
;; Commented by Ferry on 08/07/2012 for this command is not support in Emacs v24.1
;;(partial-completion-mode 1)
;;在minibuffer里启用自动补全函数和变量
(icomplete-mode 1)
;;所有的问题用y/n方式，不用yes/no方式。有点懒，只想输入一个字母
(fset 'yes-or-no-p 'y-or-n-p)
;;允许minibuffer自由变化其大小（指宽度）
(setq resize-mini-windows t)
;;当寻找一个同名的文件，自动关联上那个文件？
(setq uniquify-buffer-name-style 'forward)
;;在emacs读man文档时，使用当前buffer
(setq Man-notify-method 'pushy)
;;鼠标自动避开指针，如当你输入的时候，指针到了鼠标的位置，鼠标有点挡住视线了
(mouse-avoidance-mode 'animate)
;;允许自动打开图片，如wiki里面
(auto-image-file-mode t)
;;可以操作压缩文档
(auto-compression-mode 1)
;;在minibuffer上面可以显示列号
(column-number-mode t)
;;显示默认的文档的宽度，看起来比较舒服？
(setq default-fill-column 60)
;;指针不要闪，我得眼睛花了
(blink-cursor-mode -1)
(transient-mark-mode 1)
;;当指针到一个括号时，自动显示所匹配的另一个括号
(show-paren-mode 1)
;;是用滚轴鼠标
(mouse-wheel-mode t)
;;去掉烦人的警告铃声
(setq visible-bell -1)
;;滚动页面时比较舒服，不要整页的滚动
(setq scroll-step 1
      scroll-margin 3
      scroll-conservatively 10000)
;;设定句子结尾，主要是针对中文设置
(setq sentence-end "\\([?￡￡?￡?]\\|?-?-\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*")
(setq sentence-end-double-space nil)
;;去掉Emacs和gnus启动时的引导界面
(setq inhibit-startup-message t)
(setq gnus-inhibit-startup-message t)
;;当指针移到另一行，不要新增这一行？
(setq next-line-add-newlines nil)
;;在文档最后自动插入空白一行，好像某些系统配置文件是需要这样的
(setq require-final-newline t)
(setq track-eol t)
;;使用C-k删掉指针到该行末的所有东西
(setq-default kill-whole-line t)
;;设定删除保存记录为200，可以方便以后无限恢复
(setq kill-ring-max 200)
;;增大使用查找函数和变量的寻找范围
(setq apropos-do-all t)
;;使用narrow功能时的一个设置
(put 'narrow-to-region 'disabled nil)
;;启动Emacs自动设置为两个窗口(上下各一个)
(split-window-vertically)
;;改变emacs标题栏的标题
(setq frame-title-format "%b@Ferry")
;;允许emacs和外部其他程序的粘贴
(setq x-select-enable-clipboard t)

;;Setting for auctex start
;;(require 'tex-mik)
;;(setq TeX-electric-escape t)

;;(load "auctex.el" nil t t)
;;(load "preview-latex.el" nil t t)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

(setq TeX-auto-untabify t) ;; 不使用 TAB字符缩进
(setq LaTeX-document-regexp "document\\|CJK\\*?")  ;; CJK 环境中不缩进
(add-hook 'LaTeX-mode-hook #'LaTeX-install-toolbar)
(add-hook 'LaTeX-mode-hook 'turn-on-auto-fill)
;;Setting for auctex end


;;Setting for ibuffer
(require 'ibuffer)


;;Setting for wb-line-number
(require 'wb-line-number)
(setq truncate-partial-width-windows nil) ; use continuous line
(set-scroll-bar-mode nil)                 ; no scroll bar, even in x-window system

;;Setting for keisen-mode
(if window-system
    (autoload 'keisen-mode "keisen-mouse" "MULE table" t)
  (autoload 'keisen-mode "keisen-mule" "MULE table" t))

;;Setting fo MPG123歌词同步显示
;;(setq lrc-lyric-dir "C:\Program Files\TTPlayer\Lyrics")
;;(require 'mpg123)

;;Setting for code-reading
(require 'xcscope) ;;加载xcscope
(add-hook 'plm-mode-common-hook '(lambda() (require 'xcscope)))
(add-hook 'tnsdl-mode-common-hook '(lambda() (require 'xcscope)))
;;---------------------------------------------------
;;cedet 安装
;Added by Ferry on 08/07/2012 for omitting the warning in Emacs 24.1.1
(setq byte-compile-warnings nil)
(add-hook 'texinfo-mode-hook (lambda () (require 'sb-texinfo)))
(load-file "~/share/emacs/24.5/site-lisp/cedet/common/cedet.el")
(load-file "~/share/emacs/24.5/site-lisp/cedet/contrib/cedet-contrib.el")
(load-file "~/share/emacs/24.5/site-lisp/cedet/ede/ede.el")
(load-file "~/share/emacs/24.5/site-lisp/cedet/cogre/cogre.el")
(load-file "~/share/emacs/24.5/site-lisp/cedet/speedbar/speedbar.el")
(load-file "~/share/emacs/24.5/site-lisp/cedet/eieio/eieio.el")
(semantic-load-enable-code-helpers)
(autoload 'speedbar-frame-mode "speedbar" "Popup a speedbar frame" t)
(autoload 'speedbar-get-focus "speedbar" "Jump to speedbar frame" t)
(define-key-after (lookup-key global-map [menu-bar tools])
  [speedbar]
  '("Speedbar" .
    speedbar-frame-mode)
  [calendar])
;----------------------------------------------------------
;;ecb
;Added by Ferry on 08/07/2012 for omitting the warning in Emacs 24.1.1
(setq stack-trace-on-error nil)
(add-to-list 'load-path "~/share/emacs/24.5/site-lisp/ecb")
(load-file "~/share/emacs/24.5/site-lisp/ecb/ecb.el")
(require 'ecb)
(setq ;;ecb-auto-activate t
          ecb-tip-of-the-day nil
          ecb-tree-indent 4
          ecb-windows-height 0.5
          ecb-windows-width 0.2
          ecb-auto-compatibility-check nil
          ecb-version-check nil
          inhibit-startup-message t)
;--------------------------------------------
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
'(column-number-mode t)
'(display-time-mode t)
'(ecb-gzip-setup (quote cons))
'(ecb-options-version "2.40")
'(ecb-source-path (quote ("d:/Current_Task/Source")))
'(ecb-tar-setup (quote cons))
'(ecb-wget-setup (quote cons))
'(show-paren-mode t)
'(tabbar-buffer-groups-function (quote tabbar-buffer-ignore-groups))
'(tabbar-buffer-list-function (quote tabbar-buffer-list))
'(tabbar-cycling-scope nil)
'(tabbar-mode t)
'(transient-mark-mode t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
)
;----------------------------------------------
(setq semanticdb-project-roots
          (list
        (expand-file-name "/")))
(setq semanticdb-default-save-directory "~/.emacs.d/auto-save-list")
;;设置semantic.cache路径

(defun my-indent-or-complete ()
   (interactive)
   (if (looking-at "\\>")
          (hippie-expand nil)
          (indent-for-tab-command))
)

(global-set-key [(control tab)] 'my-indent-or-complete)


(autoload 'senator-try-expand-semantic "senator")

(setq hippie-expand-try-functions-list
          '(
                senator-try-expand-semantic
                try-expand-dabbrev
                try-expand-dabbrev-visible
                try-expand-dabbrev-all-buffers
                try-expand-dabbrev-from-kill
                try-expand-list
                try-expand-list-all-buffers
                try-expand-line
        try-expand-line-all-buffers
        try-complete-file-name-partially
        try-complete-file-name
        try-expand-whole-kill
        )
)


(require 'doxymacs) ;; 启动doxymacs
(add-hook 'c-mode-common-hook 'doxymacs-mode) ;; 启动doxymacs-mode
(add-hook 'c++-mode-common-hook 'doxymacs-mode) ;; 启动doxymacs-mode


;;Setting for autex
;;(require 'tex-mik)
;;(setq TeX-electric-escape t)


;;Setting for ido, using for searching files
(require 'ido)
(ido-mode t)


;;Setting for GDB
;; (setq gdb-many-windows t)

;; (load-library "multi-gud.el")
;; (load-library "multi-gdb-ui.el")


;;Setting for ahk-mode, AutoHotkey
;; (setq ahk-syntax-directory "D:/Program Files/AutoHotkey/Extras/Editors/Syntax")
;; (add-to-list 'auto-mode-alist '("\\.ahk$" . ahk-mode))
;; (autoload 'ahk-mode "ahk-mode")


;; turn on automatic bracket insertion by pairs. New in emacs 24
(electric-pair-mode 1)
