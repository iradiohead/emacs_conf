;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Gnus
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Googlize Me
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(set-default-font "Bitstream Vera Sans Mono-16")
(set-fontset-font (frame-parameter nil 'font)
              'unicode '("AR PL KaitiM GB" . "unicode-bmp")) ;To use this font, aptitude isnatll ttf-arphic-gkai00mp

(setq user-full-name "Ferry")
(setq user-mail-address "xiaoqiang.fu@gmail.com")
;; SMTP
(setq message-send-mail-function 'smtpmail-send-it)
(setq smtpmail-default-smtp-server "smtp.gmail.com")
(setq smtpmail-smtp-service 587)
(setq smtpmail-starttls-credentials
      '(("smtp.gmail.com"
         587
         nil
         nil)))
(setq smtpmail-auth-credentials
      '(("smtp.gmail.com"
         587
         "xiaoqiang.fu@gmail.com"
         nil)))
;; IMAP - To use Gmail's IMAP access: Sign in to your account, Settings --> Forwarding and POP/IMAP --> Enable IMAP
(setq gnus-select-methods
      '((nnimap "imap.gmail.com"
                (nnimap-address "imap.gmail.com")
                (nnimap-server-port 993)
                (nnimap-stream ssl))))
(setq nnimap-split-inbox '("INBOX"))
(setq nnimap-split-rule 'nnmail-split-fancy)
(setq gnus-parameters
      '(("nnimap+imap.gmail.com.*" (gcc-self . t))))
(setq gnus-fetch-old-headers t)


(add-to-list 'gnus-secondary-select-methods '(nnimap "gmail"
                                  (nnimap-address "imap.gmail.com")
                                  (nnimap-server-port 993)
                                  (nnimap-stream ssl)))


(setq gnus-select-method
      '(nnimap "gmail"
	       (nnimap-address "imap.gmail.com")
	       (nnimap-server-port 993)
	       (nnimap-stream ssl)))

(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
      smtpmail-auth-credentials '(("smtp.gmail.com" 587
				   "xiaoqiang.fu@gmail.com" nil))
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\"]\"[#'()]")

;;(setq tls-program '("C:/apps/cygwin/bin/openssl.exe s_client -connect %h:%p -no_ssl2 -ign_eof"))

;;(setq gnus-select-method '(nntp "news.cn99.com"))
 ;; or news.yaako.com 


(set-language-environment 'Chinese-GB)
(setq gnus-default-charset 'chinese-iso-8bit
      gnus-group-name-charset-group-alist '((".*" . chinese-iso-8bit))
      gnus-summary-show-article-charset-alist
      '((1 . chinese-iso-8bit)
        (2 . gbk)
        (3 . big5)
        (4 . utf-8))
      gnus-newsgroup-ignored-charsets 
      '(unknown-8bit x-unknown iso-8859-1))

;; (eval-after-load "mm-decode"
;;   '(progn
;;      (add-to-list 'mm-discouraged-alternatives "text/html")
;;      (add-to-list 'mm-discouraged-alternatives "text/richtext")))

;; (setq gnus-default-subscribed-newsgroups 
;;   '("gnu.emacs.help"     ;; 这里不错噢，有关 emacs 使用的问题都在这里讨论
;;     "cn.comp.os.linux")) ;; 这里也有一个 emacs 小团伙，
;;                          ;; 有空去凑个热闹吧，中文的哟 

(setq gnus-use-cache 'passive)
