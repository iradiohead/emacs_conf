(autoload 'imaxima "imaxima" "Image support for Maxima." t)
(autoload 'maxima-mode "maxima" "Maxima mode" t)
(autoload 'maxima "maxima" "Maxima interaction" t)
(setq auto-mode-alist (cons '("\\.max" . maxima-mode) auto-mode-alist))

(setq imaxima-use-maxima-mode-flag t)
(setq maxima-use-dynamic-complete t)
(setq imaxima-fnt-size "Large")
(setq imaxima-scale-factor 1.0)
(setq imaxima-label-color "red")
(setq imaxima-equation-color "white")
(setq imaxima-max-scale 0.5)
(setq imaxima-linearize-flag t)
(setq maxima-info-dir "/usr/share/info/")

(defun wy-maxima-mode-hook ()
  (setq wy-starting-imaxima nil)
  (defun maxima-start ()
    "Start the Maxima process."
    (interactive)
    (if (not (processp inferior-maxima-process))
        (if (not wy-starting-imaxima)
            (let ((origbuffer (current-buffer)))            
              (setq wy-starting-imaxima t)
              (imaxima)
              (setq wy-starting-imaxima nil)
              (switch-to-buffer origbuffer))))
    (if (processp inferior-maxima-process)
        (unless (eq (process-status inferior-maxima-process) 'run)
          (delete-process inferior-maxima-process)
          (save-excursion
            (set-buffer "*maxima*")
            (erase-buffer))
          (setq inferior-maxima-process nil)))
    (unless (processp inferior-maxima-process)
      (setq maxima-input-end 0)
      (let ((mbuf)
            (cmd))
        (if maxima-args
            (setq cmd 
                  (append (list 'make-comint "maxima" maxima-command
                                nil) (split-string maxima-args))) 
          (setq cmd (list 'make-comint "maxima" maxima-command)))
        (setq mbuf (eval cmd))
        (save-excursion
          (set-buffer mbuf)
          (setq inferior-maxima-process (get-buffer-process mbuf))
          (if maxima-fix-double-prompt
              (add-to-list 'comint-output-filter-functions
                           'maxima-remove-double-prompt))
          (accept-process-output inferior-maxima-process)
          (while (not (maxima-new-prompt-p))
            (accept-process-output inferior-maxima-process))
          (inferior-maxima-mode)))
      (sit-for 0 maxima-after-output-wait))))

(add-hook 'maxima-mode-hook 'wy-maxima-mode-hook)
