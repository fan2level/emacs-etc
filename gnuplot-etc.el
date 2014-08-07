(autoload 'gnuplot-mode "gnuplot" "gnuplot major mode" t)
(autoload 'gnuplot-make-buffer "gnuplot" "open a buffer in gnuplot-mode" t)
(setq auto-mode-alist (append '(("\\.gp$" . gnuplot-mode))
			      auto-mode-alist))
(add-hook 'gnuplot-mode-hook
	  '(lambda ()
	     (local-set-key (kbd "M-p") 'gnuplot-etc-preview)
	     )
	  )
(require 'gnuplot)
(setq gnuplot-program (executable-find "gnuplot"))

(defun gnuplot-etc-preview (&optional file)
  "gnuplot using emacs"
  (interactive)
  (let ((filepath)
	(buffer-name "*gnuplot*")
	)
    (if (get-buffer buffer-name)
	(kill-buffer buffer-name))
    (if file
	(setq filepath file)
      (setq filepath (buffer-file-name))
      )
    
    (with-temp-buffer
      (insert "gnuplot -e \"")

      (insert "set term png size 1400,400" ";")
      (insert "set style data linespoints" ";")
      ;; (insert "set key box linestyle -1" ";")
      (insert "set grid ytics lt 0 lw 1 lc rgb \\\"#bbbbbb\\\"" ";")
      (insert "set grid xtics lt 0 lw 1 lc rgb \\\"#bbbbbb\\\"" ";")
      (insert "set ylabel \\\"Voltage(V)\\\"" ";")
      (insert "set ytics 3,0.1,4.3" ";")
      (insert "set yrange [3.000:4.300]" ";")
      (insert "set y2label \\\"Temperature(\\260C)\\\"" ";")
      (insert "set y2tics -20,5,80" ";")
      (insert "set y2range [-20:80]" ";") ;

      (insert "set xtics 60*30 rotate by -45" ";")
      (insert "set xlabel \\\"Time(Seconds)\\\"" ";")
      (insert (format "stats \\\"%s\\\" using 2 name \\\"A\\\" nooutput" filepath) ";")
      (insert "set label 1 at A_index_min, graph 0.1 sprintf(\\\"min=%.3f\\\",A_min) center offset 0,-1" ";")
      (insert "set label 2 at A_index_max, graph 0.9 sprintf(\\\"max=%.3f\\\",A_max) center offset 0,1" ";")
      (insert "plot")
      (insert (format " \\\"%s\\\" using 1:2 axis x1y1 title 'Voltage'" filepath))
      (insert ",")
      (insert (format " \\\"%s\\\" using 1:3 axis x1y2 title 'Temperature'" filepath))

      (insert "\"")
      (shell-command (buffer-string) (get-buffer-create buffer-name))
      )

    (switch-to-buffer-other-window buffer-name)
    (image-mode)
    (previous-multiframe-window)
    )
  )
