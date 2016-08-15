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
;;Ȼ����emacs�а���C-c c���ɳ���ѡ����棬ѡ��j�����ͻ������������������ռǵ����ݣ�
;;��C-c C-c���ռǾ��Զ������������ǵ��ļ��У�������������ã��ҵ��ռǻᱣ����journal.org
;;�ļ��С������ռ��ǰ�ʱ�����ģ��ǳ����㡣
;; kjin - ��������,��֪��Ϊɶ!!
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "d:/Dropbox/emacs_docs/task.org" "Tasks")
         "* TODO %?\n %i\n %a")
        ("j" "Journal" entry (file+datetree "d:/Dropbox/emacs_docs/journal.org")
         "* %?\nEntered on %U\n %i\n %a")))
						   
;;������������
;;���������ڵط��ľ�γ�ȣ�calendar���и�����������ʳ��Ԥ�⣬����ľ�γ������ϵ�ġ�
(setq calendar-latitude +30.0)
(setq calendar-longitude +120.2)
;;/*time display                          */
(set-time-zone-rule "GMT-8")
(display-time-mode 1)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)

;;�ҵ����ڵغ���.
(setq calendar-location-name "Hangzhou")
;; ���� calendar ����ʾ
(setq calendar-remove-frame-by-deleting t)
(setq calendar-week-start-day 1)            ; ��������һΪÿ�ܵĵ�һ��
(setq mark-holidays-in-calendar nil)        ; Ϊ��ͻ����diary�����ڣ�calendar�ϲ���ǽ���

;;���պ�������������
;;�Ҳ�������ͽ�Ľ��ա�ϣ�����˵Ľ��պ���˹���̵Ľ��ա�
;;�����������ߣ�������ϲ����
(setq christian-holidays nil)
(setq hebrew-holidays nil)
(setq islamic-holidays nil)
;;�趨һЩ�Զ�������պͽ���
;;������Щũ��������Ҫÿ����������޸�
;;��Щ��ϧ��û���й���ͳũ����˭��д����չelisp��Ūһ��
(setq general-holidays '((holiday-fixed 1 1 "Ԫ��")
                         (holiday-fixed 2 14 "���˽�")
                         (holiday-fixed 3 14 "��ɫ���˽�")
			             (holiday-fixed 3 8 "��Ů��")
				         (holiday-fixed 4 1 "���˽�")
					     (holiday-fixed 5 1 "�Ͷ���")
                         (holiday-float 5 0 2 "ĸ�׽�")
                         (holiday-fixed 6 1 "��ͯ��")
                         (holiday-float 6 0 3 "���׽�")
                         (holiday-fixed 7 1 "������")
                         (holiday-fixed 8 1 "������")
                         (holiday-fixed 9 10 "��ʦ��")
					     (holiday-fixed 10 1 "�����")
					     (holiday-fixed 12 25 "ʥ����")))
;;					     (holiday-fixed 2 5 "Ԫ����")
;;     				     (holiday-fixed 4 4 "������")
;;					     (holiday-fixed 4 21 "���")
;;					     (holiday-fixed 6 22 "�����")
;;					     (holiday-fixed 9 28 "�����")

;;Diary

;;(setq diary-file "~/diary/diary")

(setq diary-file "d:/Dropbox/emacs_docs/diary")
(setq diary-mail-addr "kjin1983@gmail.com")

;;������һЩ����
;;�������ռ���
(setq mark-diary-entries-in-calendar t)
;;todoģʽ��������ĳ��ʱ����������һ�����飬������ܿ���ͨ��Լ��������ʵ�֡���.emacs�м���
(setq appt-issue-message nil)
;;��������ͻ����ǽ��պ�����
(setq mark-holidays-in-calendar t)
;;��calendar�Զ��򿪽��պ������б�
(setq view-calendar-holidays-initially t)

;;�����������������Ϊ�й��꣬����Ĭ�ϵ�����Ӣ��д�ġ�
;;��������ڽ����б�Ĵ��������ܿ����������Ĵ�������д��
;;Thursday, January 22, 2004: Chinese New Year (��-��)
(setq chinese-calendar-celestial-stem
["��" "��" "��" "��" "��" "��" "��" "��" "��" "��"])
(setq chinese-calendar-terrestrial-branch
["��" "��" "��" "î" "��" "��" "��" "δ" "��" "��" "��" "��"])

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
