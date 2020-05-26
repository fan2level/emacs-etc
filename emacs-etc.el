(defun lcd-timing-do (hpw hbp width hfp vs vbp height vfp &optional refresh)
  "calculate lcd vsync hsync pixel-clock, frequency"
  (interactive)
  (let ((pixel-clock)
	(frequency)
	(refresh (or refresh 1))
	)
    (setq pixel-clock (* (+ hpw hbp width hfp) (+ vs vbp height vfp) refresh))
    (setq frequency (/ 1.0 pixel-clock))
    (message "pixel-clock : %d\nfrequency : %g" pixel-clock frequency)
    ))

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

(defun ci (ratio years fund &optional capital)
  "복리계산(compound-interest)
2020년을 투자 원년으로 한다
`ratio' 연이자율(%) : 2 ( 2%)
`years' 투자기간(년): 10(10년)
`(expt 여이율 투자기간)' = 투자수익율
`(log 투자수익율 연이율)' = 투자기간
"
  (interactive "n이율: \nn투자기간: \nn월납입액: ")
  (with-help-window "*복리계산*"
    (let ((year 1)
	  (ratio (/ ratio 100.0))
          (capital (or capital 0))
	  (total (or capital 0))
	  )
      (princ "=================================\n")
      ;; 횟수 원금 평가금 이율
      (while (<= year years)
	(setq capital (+ capital fund))
	(setq total (* (+ total fund) (+ 1 ratio)))

	(princ (format "%3d %10d %10d %3.2f\n" year capital total (/ total capital)))
	
	(setq year (+ year 1))
	)
      (princ "=================================\n")
      (princ (format "투자기간: %10d(년)\n" years))
      (princ (format "원금    : %10d(원)\n" capital))
      (princ (concat (format "연이율  : %10.2f" (* ratio 100)) "(%)\n"))
      (princ "---------------------------------\n")
      (princ (format "평가금  : %10d(원)\n" total))
      (princ (concat (format "수익율  : %10.2f" (* (- (/ total capital) 1) 100)) "(%)\n"))
      (princ (format "수익금  : %10d(원)\n" (- total capital)))
      (princ "=================================\n")
      (- total capital)
      )
    )
  )

(defun tax (earning type &optional exemption)
  "`type' : 세율
  0 : 보통세율 : 소득세(14%) + 농특세(1.4%) = 15.4%
  1 : 저과세 : 소득세(0%) + 농특세(1.4%) = 1.4% (농협,수협,신협등 한도 3000만원)
  2 : 세금우대 : 소득세( 9%) + 농특세(0.5%) =  9.5%
`exemption' : 비과세한도
  "
  (with-help-window "*세금*"
    (let ((비과세한도 (or exemption 0))
	  (세율)
	  (earning1))
      (cond ((eq type 0) (progn
			   (setq 세율 15.4)
			   (setq tax (* (- earning 비과세한도) (/ 세율 100)))))
	    ((eq type 1) (progn
			   (setq 세율 1.4)
			   (setq tax (* (- earning 비과세한도) (/ 세율 100)))))
	    ((eq type 2) (progn
			   (setq 세율 9.5)
			   (setq tax (* (- earning 비과세한도) (/ 세율 100)))))
	    )
      (princ "=================================\n")
      (princ (format "수익금 : %10d(원)\n" earning))
      (princ (concat (format "세율   : %10.2f" 세율) "(%)\n"))
      (princ (format "비과세한도 : %10d(원)\n" 비과세한도))
      (princ (format "세금   : %10d(원)\n" tax))
      (princ "=================================\n")
      )
    )
  )
