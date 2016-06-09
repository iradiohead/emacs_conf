;; -*- Mode: Emacs-Lisp -*-
;; -*- lisp -*-
;; Example .gnus file for IMAP mail, edit it to suit your mail preferences

;; We want to get news from news.online.no, change to get news from another server
(setq gnus-select-method '(nntp "news.online.no"))
;; Change the group format with some extra items
(setq gnus-group-line-format
      "%M\%S\%p\%P\%m\%5y/\%-5t: %(%-40,40g%) %2,2~(cut 6)d.%2,2~(cut 4)d.%4,4~(cut 0)d %2,2~(cut 9)d:%2,2~(cut 11)d %O\n")
(setq gnus-extract-address-components
      'mail-extract-address-components)
(setq gnus-use-cache t)
;; Turn on nntp and imap cache
(setq gnus-cacheable-groups "^\\(nntp\\)")
;; Turn off nnml cache
(setq gnus-uncacheable-groups "^\\(nnml\\|nnimap\\)")
;; Save gnus score files
(setq gnus-save-score t)
;; Set this to t if you've got a slow connection
(setq gnus-asynchronous nil)
;; Add some custom keys, press f5 to refresh the group at the cursors or press M-f5 to refresh all groups at level 1 or lower
;; (remember to set the group level to 1 to be refreshed by this)
(define-key gnus-group-mode-map [f5] 'gnus-group-get-new-news-this-group)
(define-key gnus-group-mode-map [(meta f5)] '(lambda ()
                                               (interactive)
                                               (gnus-group-get-new-news 1)))

(setq gnus-signature-separator
      '("^-- $"         ; The standard
        "^-- *$"        ; A common mangling
        "^-------*$"    ; Many people just use a looong
                        ; line of dashes.  Shame!
        "^ *--------*$" ; Double-shame!
        "^________*$"   ; Underscores are also popular
        "^========*$")) ; Pervert!
(setq gnus-message-archive-group "Sent")
;; Change imap-mail to your own server
(setq gnus-message-archive-method
      '(nnimap "imap-mail"))
;; Add more imap folders if you have
(setq nnimap-list-pattern
      '("mbox"
        "Drafts" "Sent"))

;; Insert your own spool dir here
(setq nnimap-split-inbox '("/var/spool/mail/user"))
;; Change imap-mail to your own server
(setq nnimap-address "imap-mail")
(setq nnimap-split-crosspost nil)
;; For more information on the split rule check out either http://www.gnus.org or http://zez.org/article/articleview/38/
(setq nnimap-split-rule
      (list
       '("mbox" ".*")))
;; Which files should be cached
(setq gnus-cache-enter-articles '(ticked dormant))
(setq gnus-cache-remove-articles nil)
 
