;; geiser-compile.el -- compile/load scheme files

;; Copyright (C) 2009 Jose Antonio Ortega Ruiz

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the Modified BSD License. You should
;; have received a copy of the license along with this program. If
;; not, see <http://www.xfree86.org/3.3.6/COPYRIGHT2.html#5>.

;; Start date: Wed Feb 11, 2009 00:16



(require 'geiser-debug)
(require 'geiser-eval)
(require 'geiser-base)


;;; Auxiliary functions:

(defun geiser-compile--buffer/path (&optional path)
  (let ((path (or path (read-file-name "Scheme file: " nil nil t))))
    (let ((buffer (find-file-noselect path)))
      (when (and (buffer-modified-p buffer)
                 (y-or-n-p "Save buffer? "))
        (save-buffer buffer))
      (cons buffer path))))

(defun geiser-compile--display-result (title ret)
  (if (not (geiser-eval--retort-error ret))
      (message "%s %s" title (or (geiser-eval--retort-result ret) "done."))
    (message ""))
  (geiser-debug--display-retort title ret))

(defun geiser-compile--file-op (path compile-p msg)
  (let* ((b/p (geiser-compile--buffer/path path))
         (buffer (car b/p))
         (path (cdr b/p))
         (msg (format "%s %s ..." msg path)))
    (message msg)
    (geiser-compile--display-result
     msg (geiser-eval--send/wait `(,(if compile-p :comp-file :load-file) ,path)))))


;;; User commands:

(defun geiser-compile-file (path)
  "Compile and load Scheme file."
  (interactive "FScheme file: ")
  (geiser-compile--file-op path t "Compiling"))

(defun geiser-compile-current-buffer ()
  "Compile and load current Scheme file."
  (interactive)
  (geiser-compile-file (buffer-file-name (current-buffer))))

(defun geiser-load-file (path)
  "Load Scheme file."
  (interactive "FScheme file: ")
  (geiser-compile--file-op path nil "Loading"))

(defun geiser-load-current-buffer ()
  "Load current Scheme file."
  (interactive)
  (geiser-load-file (buffer-file-name (current-buffer))))



(provide 'geiser-compile)
;;; geiser-compile.el ends here
