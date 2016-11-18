;;将默认模式从fundemental-mode改为text-mode 
(setq default-major-mode 'text-mode) 
;;启动语法高亮模式 
(global-font-lock-mode t) 
;;一些具体的设置，从别的地方拷过来的，目前编程较少，所以也没具体改了，感觉目前配置还是非常不错的 
;;如果你是一个程序员，这块你可以仔细改改 
(setq font-lock-maximum-decoration t) 
(setq font-lock-global-modes '(not text-mode)) 
(setq font-lock-verbose t) 
(setq font-lock-maximum-size '((t . 1048576) (vm-mode . 5250000))) 

;;对相应的文件设定相应的模式，以便正确的语法显亮 
;;文件名用正则表达式表示，注意不要后面覆盖了前面的而引起的误会 
;;修改这个之前先C-h v auto-mode-alist查查已有的设置 
(mapcar 
(function (lambda (setting) 
         (setq auto-mode-alist 
           (cons setting auto-mode-alist)))) 
'(("\\.\\(xml\\|rdf\\)\\'" . sgml-mode) 
   ("\\.\\([ps]?html?\\|cfm\\|asp\\)\\'" . html-helper-mode) 
   ("\\.css\\'" . css-mode) 
   ("\\.\\(emacs\\|session\\|gnus\\)\\'" . emacs-lisp-mode) 
   ("\\.wiki\\'" . emacs-wiki-mode) 
   ("\\.\\(jl\\|sawfishrc\\)\\'" . sawfish-mode) 
   ("\\.scm\\'" . scheme-mode) 
   ("\\.py\\'" . python-mode) 
   ("\\.\\(ba\\)?sh\\'" . sh-mode) 
   ("\\.l\\'" . c-mode) 
   ("\\.cex\\'" . c-mode) 
   ("\\.cii\\'" . c-mode) 
   ("\\.cin\\'" . c-mode) 
   ("\\.cli\\'" . c-mode) 
   ("\\.cva\\'" . c-mode) 
   ("\\.cdt\\'" . c-mode) 
   ("\\.cpd\\'" . c-mode) 
   ("\\.asm\\'" . asm-mode)
   ("\\.inc\\'" . asm-mode)
   ("\\.a86\\'" . asm-mode)
   ("\\.a30\\'" . asm-mode)
   ("\\.a38\\'" . asm-mode)
   ("\\.pac\\'" . dcl-mode)
   ("\\.html\\'" . html-mode)
   ("\\.img\\'" . hexl-mode)
   ("\\.hex\\'" . hexl-mode)
   ("\\.lnk\\'" . hexl-mode)
   ("\\.obj\\'" . hexl-mode)
   ("\\.text\\'" . markdown-mode)
   ("\\.markdown\\'" . markdown-mode)
   ("\\.md\\'" . markdown-mode)
   ("\\.max\\'" . maxima-mode)
   ("\\.hst\\'" . org-mode)))
;;;
;;; cc-mode
;;;
;   style & indent in c-mode
(add-hook 'c-mode-common-hook
          '(lambda ()
             (c-set-style "bsd")
             (setq c-basic-offset 4)
             (c-set-offset 'case-label '+)))

; Externals to which Tab can be stricken even in case of being on right edge

(setq c-tab-always-indent nil)


(add-hook 'c-mode-hook 'linux-c-mode)
(add-hook 'c++-mode-hook 'linux-cpp-mode)
;; 设置imenu的排序方式为按名称排序
(setq imenu-sort-function 'imenu--sort-by-name)
(defun linux-c-mode()
;; 将回车代替C-j的功能，换行的同时对齐
  (define-key c-mode-map [return] 'newline-and-indent)
  (interactive)
;; 自动模式，在此种模式下当你键入{时，会自动根据你设置的对齐风格对齐
  (c-toggle-auto-state)
;; 选择C对齐模式
  (c-set-style "bsd")
;;(c-set-style "K&R")
;; 此模式下，当按Backspace时会删除最多的空格
  (c-toggle-hungry-state)
;; TAB键的宽度设置为8
  (setq c-basic-offset 4)
;; 在菜单中加入当前Buffer的函数索引
  (imenu-add-menubar-index)
;; 在状态条上显示当前光标在哪个函数体内部
  (which-function-mode)
 )
(defun linux-cpp-mode()
  (define-key c++-mode-map [return] 'newline-and-indent)
  (define-key c++-mode-map [(control c) (c)] 'compile)
  (interactive)
  (c-set-style "bsd")
;;(c-set-style "K&R")
  (c-toggle-auto-state)
  (c-toggle-hungry-state)
  (setq c-basic-offset 4)
  (imenu-add-menubar-index)
  (which-function-mode)
  )

;; org -mode huan hang issue
(add-hook 'org-mode-hook (lambda () (setq truncate-lines nil)))
