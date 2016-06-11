# emacs_conf
##################################################################################
Materials:

wangying:
http://blog.csdn.net/superwen_go/article/details/8235185

emacs mainpage
http://www.gnu.org/software/emacs/

emacs wiki
https://www.emacswiki.org/

一个搜集 .emacs 文件的网站。你可以从这里学习怎么配置 .emacs.
http://dotemacs.de/

comp.emacs 上的一个帖子Emacs references: pointers to ports, packages, papers, lisp
http://docs.huihoo.com/homepage/shredderyin/emacs-resource.html

Richard Stallman 有关 Emacs 的论文
http://docs.huihoo.com/homepage/shredderyin/emacs-paper.html


##################################################################################
config files:

ac-comphist.dat:
auto-complete手册 
http://blog.chinaunix.net/uid-13539494-id-2380065.html
5.5. Candidate Suggestion
auto-complete-mode analyzes completion operations one by one and reduces overheads of completion as much as possible.
For example, having a candidate "foobar" been completed few times, auto-complete-mode arranges it to top of the candidates next time and make a situation
that allows users to complete the word with one time TAB or few times TAB. It is called comphist internally, 
and you can use it by setting ac-use-comphist to t. It is enabled by default. 
Collection operations data will be stored in user-emacs-directory or ~/.emacs.d/ with a name ac-comphist.dat.

.emacs.bmk
bookmark


ido.last
jk-basic-config.el:
;;Setting for ido, using for searching files
(require 'ido)
(ido-mode t)

http://www.cnblogs.com/bamanzi/archive/2011/04/22/choose-with-ido-or-anything.html	
ido - interactively do things with buffers and files
当你在 Emacs 中穿梭，ido-mode 有助于提高你的效率：通过M-x ido-mode打开后，在切换buffer(C-x b 或者M-x switch-buffer), 打开文件(C-x C-f 或者M-x find-file)，
打开目录浏览(C-x d 或者M-x dired)时，它会在minibuffer中列举出备选项，方便你选择（可以部分匹配，可以用左右键选择上一个/下一个备选项等等)。


ispell.el
https://www.emacswiki.org/emacs/AspellWindows
安装http://aspell.net/win32/
.emacs
(add-to-list 'exec-path "C:/Program Files (x86)/Aspell/bin/")
(setq ispell-program-name "aspell")
(setq ispell-personal-dictionary "D:/emacs/.emacs.d/ispell.el")
(require 'ispell)

(global-set-key (kbd "<f8>") 'ispell-word)
(global-set-key (kbd "C-<f8>") 'flyspell-mode)
