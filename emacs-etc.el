(defun select-word (&optional string)
  "return string pointed by word

"
  (save-excursion
    (let ((begin)
	  (end)
	  (select-word)
	  (exclude-chars "^=*>&[]!(){}\"'`.,/;:\n\t\s")
	  )
      (skip-chars-backward exclude-chars)
      (setq begin (point))
      (skip-chars-forward exclude-chars)
      (setq end (point))
      (if (not (= begin end))
	  (setq select-word (buffer-substring-no-properties begin end))
	)
      select-word)
    )
  )

(defun highlight-select-word (&optional string)
  "highlight word"
  (interactive)
  (require 'hi-lock)
  (let ((select-word)
	(word (select-word string))
	)

    (cond ((null word) (error "you can't select exclude characters"))
	  ((= (length word) 1) (error "you should select more a characters"))
	  (t 
	   ;; (setq select-word (concat "\\<" word "\\>"))
	   (setq select-word (concat "" word ""))
	   (if (null (assoc select-word hi-lock-interactive-patterns))
	       (highlight-regexp select-word)
	     (unhighlight-regexp select-word))
	   ))
    )
  )

(defun highlight-word (&optional string)
  "highlight word"
  (interactive)
  (require 'hi-lock)
  (let ((select-word)
	(word (select-word string))
	)

    (cond ((null word) (error "you can't select exclude characters"))
	  ((= (length word) 1) (error "you should select more a characters"))
	  (t 
	   (setq select-word (concat "\\<" word "\\>"))
	   (if (null (assoc select-word hi-lock-interactive-patterns))
	       (highlight-regexp select-word)
	     (unhighlight-regexp select-word))
	   ))
    )
  )
