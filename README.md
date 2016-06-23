steps to run emacs on your windows
**** you do not need install emacs just clone this repository! ****

1：put emacs.bat under your windows envirment variable path
2: open emacs.bat, set emacs_dir=d:\emacs_win\  -- this is for example
3: rum emacs in DOS cmd line

-----------------------------------------------------------------------

4: it is better to install cygwin in your system.
update below path in .\emacs_win\.emacs.d\elisp\jk-basic-config.el
(setenv "PATH" (concat "C:/APPS/cygwin/bin;" (getenv "PATH")))
(setq exec-path (cons "C:/APPS/cygwin/bin" exec-path))

5: comment below line in .emacs file or change the temp file path with your own's
(find-file "D:/Dropbox/emacs_docs/temp.txt")

6：usage manual by myself in below folder with prefix "My"
e.g
d:\emacs_win\.emacs.d\tutorial_mine\MyNotePlus.txt