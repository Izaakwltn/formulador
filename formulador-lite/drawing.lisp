;;;; drawing.lisp
;;;;
;;;; Copyright (c) 2021-2022 Izaak Walton

(in-package #:formulador-lite)



;;; The simple drawing command: (simple-draw "1+2")

(defun simple-draw (formula-string)
  "Given a formula-string, returns pretty-printed formulador formula."
  (formulador::draw (first (block-cycle (block-list (lex-line formula-string))))))

;;;Interpreter

(defvar drawing-in-progress nil)

(defun command-input ()
  (let ((input (read)))
  (if (equal (princ-to-string input) "STOP")
      (progn (setq drawing-in-progress nil)
	     (princ "Drawing terminated"))
      (princ (simple-draw (princ-to-string input))))))

(defun start-drawing ()
  (setq drawing-in-progress t)
  (loop while drawing-in-progress
	do (progn (command-input) (terpri))))
