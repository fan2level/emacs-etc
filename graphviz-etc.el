;; fixme : dot.exe

(defun my-graphviz-dot-preview ()
  ""
  (interactive)
  (let ((preview-buffer-name)
	(shell-param)
	(current-filename))

    (setq preview-buffer-name (concat "*graphviz preview*"))
    (if (get-buffer preview-buffer-name)
	(kill-buffer preview-buffer-name)
      )
    (setq current-filename (concat (file-name-nondirectory (buffer-file-name)))) ;get only filename
    (setq shell-param (format "dot -Tpng %s" current-filename))
    (shell-command shell-param (get-buffer-create preview-buffer-name))
    (switch-to-buffer-other-window preview-buffer-name)
    (image-mode)
    (setq buffer-read-only t)
    (previous-multiframe-window)
  )
)

(add-hook 'graphviz-dot-mode-hook
	  '(lambda ()
	     (setq graphviz-dot-indent-width 4)
	     (setq graphviz-dot-auto-indent-on-semi nil)
	     (local-set-key (kbd "M-p") 'my-graphviz-dot-preview)
	     )
	  )
