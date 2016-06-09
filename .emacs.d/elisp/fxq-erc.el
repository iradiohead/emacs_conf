;;加载erc.el包 
;;这个配置文件最好不要编译，否则下面定义的erc-sir等函数不能用 
;;不过这个应该可以修改，我以后试试 
(require 'erc) 
;;设定一个有关方便连接IRC服务器的函数 
(defmacro de-erc-connect (command server port nick) 
  "Create interactive command `command', for connecting to an IRC server. The 
command uses interactive mode if passed an argument." 
  (fset command 
    `(lambda (arg) 
       (interactive "p") 
       (if (not (= 1 arg)) 
           (erc-select ,server ,port ,nick) 
         (erc ,server ,port ,nick ,erc-user-full-name t))))) 
;;这是咱们Sir的IRC，大家记得常去 
(de-erc-connect erc-sir "linuxsir.org" 6667 "hvj") 
;;这是linuxfans的IRC，有些时日了 
(de-erc-connect erc-fans "irc.linuxfans.org" 6667 "hvj") 
;;下面是我所在局域网里的IRC 
(de-erc-connect erc-me "192.168.1.191" 6667 "hvj") 
(de-erc-connect erc-van "192.168.1.14" 6667 "hvj") 

;;设定一些有关变量 
(custom-set-variables 
;;进入linuxsir的IRC，自动加入#javalee频道，咱们的灌水频道，人气还不错 
'(erc-autojoin-channels-alist '(("linuxsir.org" "#javalee") 
;;进入linuxfans的IRC，自动加入#linuxfans和#linuxer频道，不过linuxfans的IRC已经自动这样设置了 
                 ("irc.linuxfans.org" "#linuxfans" "#linuxer"))) 
;;在默认情况下IRC里我的ID是hvj 
'(erc-email-userid "hvj") 
;;设定聊天时的行宽，方便阅读 
'(erc-fill-column 67) 
;;什么来着？ 
'(erc-fill-prefix "      ") 
;;屏蔽掉的一些命令 
'(erc-hide-list '("JOIN" "PART" "QUIT")) 
;;默认的昵称，这和userid有什么区别？还不清楚，清大家告诉我。 
'(erc-nick "hvj") 
;;默认的端口6667 
'(erc-port 6667) 
;;登录这些IRC不用密码登录 
;;我在linuxfans已经注册了我的ID，我不用密码登录，将会一分钟后将我改名 
;;下次我将改改这个变量 
'(erc-prompt-for-password nil) 
;;有关退出IRC的，什么意思来着？ 
'(erc-quit-reason 'erc-quit-reason-zippy) 
;;不保存IRC聊天记录 
;;大家可以找找，是可以保存的，只要你愿意 
'(erc-save-buffer-on-part nil)) 

;;设定erc模式的一个滚动设置，保持输入在当前窗口的最后一行 
(add-hook 'erc-mode-hook 'erc-add-scroll-to-bottom) 

;;erc中文的关键设置，这个一定需要，否则你只能看中文，而不能“说”中文 
(setq erc-encoding-default 'chinese-iso-8bit) 


