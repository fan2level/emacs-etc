(autoload 'gtags-mode "gtags" "" t)
;; (require 'gtags)
(setq gtags-suggested-key-mapping t)
(add-hook 'c-mode-hook '(lambda () (gtags-mode 1)))
(add-hook 'c++-mode-hook '(lambda () (gtags-mode 1)))
(add-hook 'after-save-hook
	  (lambda ()
	    (and (boundp 'gtags-mode) gtags-mode
		 (let (root-dir current-dir shell-param)
		   (setq root-dir (gtags-get-rootpath))
		   ;; valid if gtags exist
		   (if root-dir
		       (progn
		   	 (setq current-dir (file-name-directory buffer-file-name))
		   	 (setq shell-param (concat "gtags --single-update " buffer-file-name))
		   	 (cd root-dir)
		   	 (shell-command shell-param)
		   	 ;; (start-process "gtags-update" nil "gtags" "--single-update" buffer-file-name)
		   	 (cd current-dir)
		   	 )
		     )
		   )
	      )
	    )
	  )

(setq gtags-mode-hook
     '(lambda ()
	(setq gtags-path-style 'relative)
	;; (setq gtags-suggested-key-mapping t)
	;; (setq gtags-auto-update t)
	))

(defun gtags-select-next-line-other-window ()
  "Select tags to other windows"
  (interactive)
  (forward-line 1)
  (gtags-select-tag-other-window)
  (previous-multiframe-window)
  )
(defun gtags-select-previous-line-other-window ()
  "Select tags to other windows"
  (interactive)
  (forward-line -1)
  (gtags-select-tag-other-window)
  (previous-multiframe-window)
  )
(defun gtags-select-pop-stack ()
  "pop stack"
  (interactive)
  (gtags-pop-stack)
  )
(setq gtags-select-mode-hook
      '(lambda ()
	 ;; (local-set-key (kbd "M-*") 'gtags-pop-stack)
	 (local-set-key (kbd "C-t") 'gtags-select-pop-stack)
	 ;; (local-set-key (kbd "n") 'next-line)
	 ;; (local-set-key (kbd "p") 'previous-line)
	 (local-set-key (kbd "n") 'gtags-select-next-line-other-window)
	 (local-set-key (kbd "p") 'gtags-select-previous-line-other-window)
	 (local-set-key (kbd "ESC") 'gtags-select-pop-stack)
	 ;; first tags is selected to other window
	 ;; (split-window-below)
	 ;; (gtags-select-tag-other-window)
	 ;; (previous-multiframe-window)
	 ))
