;; Set org-agenda-files for Org-Mode
;;(setq org-agenda-files (list "~/diary/TimeQuadrant.org"))

;;kjin add here
(setq org-agenda-files (list 
							 ;;"~/diary/TimeQuadrant.org"
                             ;;"~/.emacs.d/tutorial_mine/"
                             "d:/Dropbox/emacs_docs/"
							 "d:/Dropbox/emacs_docs/tutorial_mine/"
                           ))

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;;kjin  org-capture
;;http://blog.csdn.net/jiluben/article/details/39532273
;;然后在emacs中按下C-c c即可出现选择界面，选择“j”，就会出现文字输入框，输入日记的内容，
;;按C-c C-c，日记就自动保存在了我们的文件中，按照上面的配置，我的日记会保存在journal.org
;;文件中。并且日记是按时间分类的，非常方便。
;; kjin - 不起作用,不知道为啥!!
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "d:/Dropbox/emacs_docs/task.org" "Tasks")
         "* TODO %?\n %i\n %a")
        ("j" "Journal" entry (file+datetree "d:/Dropbox/emacs_docs/journal.org")
         "* %?\nEntered on %U\n %i\n %a")))
						   
;;日历基本配置
;;设置我所在地方的经纬度，calendar里有个功能是日月食的预测，和你的经纬度相联系的。
(setq calendar-latitude +30.0)
(setq calendar-longitude +120.2)
;;/*time display                          */
(set-time-zone-rule "GMT-8")
(display-time-mode 1)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)

;;我的所在地杭州.
(setq calendar-location-name "Hangzhou")
;; 设置 calendar 的显示
(setq calendar-remove-frame-by-deleting t)
(setq calendar-week-start-day 1)            ; 设置星期一为每周的第一天
(setq mark-holidays-in-calendar nil)        ; 为了突出有diary的日期，calendar上不标记节日

;;节日和生日提醒设置
;;我不过基督徒的节日、希伯来人的节日和伊斯兰教的节日。
;;我是无神论者，不过我喜欢神话
(setq christian-holidays nil)
(setq hebrew-holidays nil)
(setq islamic-holidays nil)
;;设定一些自定义的生日和节日
;;后面那些农历节日需要每年根据日历修改
;;有些可惜，没有中国传统农历，谁能写个扩展elisp包弄一下
(setq general-holidays '((holiday-fixed 1 1 "元旦")
                         (holiday-fixed 2 14 "情人节")
                         (holiday-fixed 3 14 "白色情人节")
			             (holiday-fixed 3 8 "妇女节")
				         (holiday-fixed 4 1 "愚人节")
					     (holiday-fixed 5 1 "劳动节")
                         (holiday-float 5 0 2 "母亲节")
                         (holiday-fixed 6 1 "儿童节")
                         (holiday-float 6 0 3 "父亲节")
                         (holiday-fixed 7 1 "建党节")
                         (holiday-fixed 8 1 "建军节")
                         (holiday-fixed 9 10 "教师节")
					     (holiday-fixed 10 1 "国庆节")
					     (holiday-fixed 12 25 "圣诞节")))
;;					     (holiday-fixed 2 5 "元宵节")
;;     				     (holiday-fixed 4 4 "清明节")
;;					     (holiday-fixed 4 21 "鬼节")
;;					     (holiday-fixed 6 22 "端午节")
;;					     (holiday-fixed 9 28 "中秋节")

;;Diary

;;(setq diary-file "~/diary/diary")

(setq diary-file "d:/Dropbox/emacs_docs/diary")
(setq diary-mail-addr "kjin1983@gmail.com")

;;其他的一些设置
;;日历和日记相
(setq mark-diary-entries-in-calendar t)
;;todo模式并不能在某个时间提醒你做一件事情，这个功能可以通过约会提醒来实现。在.emacs中加入
(setq appt-issue-message nil)
;;在日历中突出标记节日和生日
(setq mark-holidays-in-calendar t)
;;打开calendar自动打开节日和生日列表
(setq view-calendar-holidays-initially t)

;;下面两个是设置年份为中国年，好像默认的是用英文写的。
;;这个设置在节日列表的春节那天能看到，如今年的春节他就写着
;;Thursday, January 22, 2004: Chinese New Year (甲-申)
(setq chinese-calendar-celestial-stem
["甲" "乙" "丙" "丁" "戊" "己" "庚" "辛" "壬" "癸"])
(setq chinese-calendar-terrestrial-branch
["子" "丑" "寅" "卯" "辰" "巳" "戊" "未" "申" "酉" "戌" "亥"])

;;kjin;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Here is some code to make your calendar and diary display fancier:
 (setq view-diary-entries-initially t
       mark-diary-entries-in-calendar t
       number-of-diary-entries 7)
 (add-hook 'diary-display-hook 'fancy-diary-display)
 (add-hook 'today-visible-calendar-hook 'calendar-mark-today)


;;Here is some code to get rid of the ugly equal signs under the date
 (add-hook 'fancy-diary-display-mode-hook
	   '(lambda ()
              (alt-clean-equal-signs)))
  
 (defun alt-clean-equal-signs ()
   "This function makes lines of = signs invisible."
   (goto-char (point-min))
   (let ((state buffer-read-only))
     (when state (setq buffer-read-only nil))
     (while (not (eobp))
       (search-forward-regexp "^=+$" nil 'move)
       (add-text-properties (match-beginning 0) 
	                    (match-end 0) 
			    '(invisible t)))
     (when state (setq buffer-read-only t))))
