;;在需要的时候加载所需的elisp 
(autoload 'dictionary-search "dictionary" 
  "Ask for a word and search it in all dictionaries" t) 
(autoload 'dictionary-match-words "dictionary" 
  "Ask for a word and search all matching words in the dictionaries" t) 
(autoload 'dictionary-lookup-definition "dictionary" 
  "Unconditionally lookup the word at point." t) 
(autoload 'dictionary "dictionary" 
  "Create a new dictionary buffer" t) 
(autoload 'dictionary-mouse-popup-matching-words "dictionary" 
  "Display entries matching the word at the cursor" t) 
(autoload 'dictionary-popup-matching-words "dictionary" 
  "Display entries matching the word at the point" t) 
(autoload 'dictionary-tooltip-mode "dictionary" 
  "Display tooltips for the current word" t) 
(autoload 'global-dictionary-tooltip-mode "dictionary" 
  "Enable/disable dictionary-tooltip-mode for all buffers" t) 

;;设定字典服务器为本地服务器 
;;如果你在包月的宽带上，不妨设定为[url]http://www.dict.org[/url] 
;;如果你在局域网上，而局域网的某台机器有dictd服务器，你将服务器设定为他的IP即可。 
;(setq dictionary-server "localhost") 
(setq dictionary-server "http://www.dict.org") 
;;在字典提示模式中，使用wordnet字典数据库作为默认字典数据库 
;;当然你可以修改，取决于你dictd服务器里的字典数据库 
(setq dictionary-tooltip-dictionary "wn") 

;; 设定中文词典的解码 
;; 由qtjava兄告知，谢谢！ 
(setq dictionary-coding-systems-for-dictionaries '(("cdict" . gb2312) 
                                                   ("xdict" . gbk2312) 
                                                   ("stardic" . gb2312))) 

(setq-default ispell-program-name "aspell")
(setq-default ispell-extra-args '("--reverse"))

(autoload 'flyspell-mode "flyspell" "On-the-fly spelling checker." t)
(autoload 'flyspell-delay-command "flyspell" "Delay on command." t)
(autoload 'tex-mode-flyspell-verify "flyspell" "" t) 

(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(setq flyspell-sort-corrections nil)
(setq flyspell-doublon-as-error-flag nil)

;;Setting for aspell
;;(setq-default ispell-program-name "flypell")
(setq-default ispell-program-name "aspell")
(setq-default ispell-local-dictionary "american")
(global-set-key (kbd "") 'ispell-complete-word)
