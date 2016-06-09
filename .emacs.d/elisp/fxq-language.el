;;emacs环境设置
;;整体环境设置
(set-language-environment 'Chinese-GBK)
;(set-clipboard-coding-system 'euc-cn)
;(set-terminal-coding-system 'euc-cn)
;(set-buffer-file-coding-system 'euc-cn)
;(set-selection-coding-system 'euc-cn)
;(modify-coding-system-alist 'process "*" 'euc-cn)
;(setq default-process-coding-system 
;  '(euc-cn . euc-cn))
;(setq-default pathname-coding-system 'euc-cn)

;;应该和输入有关系
;;(set-keyboard-coding-system 'chinese-iso-8bit-with-esc)
;;终端下emacs的中文设置？
;(set-terminal-coding-system 'chinese-iso-8bit-with-esc)
;;文件保存时的编码设置
;(set-buffer-file-coding-system 'chinese-iso-8bit-with-esc)
;;下面两天是emacs和其他程序互相复制／粘贴的设置
;;在帖3（hvj-basicconfig.el）的最后一行中也有相关的一个设定
;;(set-selection-coding-system 'chinese-iso-8bit-with-esc)
;;(set-clipboard-coding-system 'chinese-iso-8bit-with-esc)
;;什么设置？忘了？有些人没用下面这些
;;(modify-coding-system-alist 'process "*" 'chinese-iso-8bit-with-esc)
;;(setq default-process-coding-system '(chinese-iso-8bit-with-esc . chinese-iso-8bit-with-esc))
;;(setq-default pathname-coding-system 'chinese-iso-8bit-with-esc)

;;Setting for the mule-gbk
;;(setq w32-charset-info-alist
;;    (cons '("gbk" w32-charset-gb2312 . 936) w32-charset-info-alist))
(set-w32-system-coding-system 'chinese-gbk)
(set-selection-coding-system 'chinese-gbk)
(set-keyboard-coding-system 'chinese-gbk)
(set-language-environment 'chinese-gbk)
(setq locale-coding-system 'chinese-gbk)
(setq current-language-environment "Chinese-GBK")

;;字体解码优先顺序
;;(setq font-encoding-alist
;;(append '(("MuleTibetan-0" (tibetan . 0))
;;("GB2312" (chinese-gb2312 . 0)) 
;;("JISX0208" (japanese-jisx0208 . 0)) 
;;("JISX0212" (japanese-jisx0212 . 0)) 
;;("VISCII" (vietnamese-viscii-lower . 0)) 
;;("KSC5601" (korean-ksc5601 . 0)) 
;;("MuleArabic-0" (arabic-digit . 0)) 
;;("MuleArabic-1" (arabic-1-column . 0)) 
;;("MuleArabic-2" (arabic-2-column . 0))) font-encoding-alist))
