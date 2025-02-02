;;;; formulador-lite/lexical-analysis.lisp
;;;;
;;;; Copyright (c) 2021 Izaak Walton

(in-package :formulador-lite)

;;; Defining tokens

(deftype token ()
  '(cons keyword t))

(defun tok (type &optional val)
  (cons type val))

;;; The Analysis

(defun string-space (string)
  (concatenate 'string " " string " "))

(defun as-is (fraction-string)
  "Converts an %input% into a string."
  (subseq fraction-string 1 (- (length fraction-string) 1)))

(alexa:define-string-lexer formulexer
  "A lexical analyzer for formulador-lite"
  ((:num "\\d+")
   (:infix-oper "[+*-=]")
   (:symbol "[A-Za-z][A-Za-z0-9_]*")
   (:as-is "\\%[A-Za-z0-9]\\/[A-Za-z0-9]\\%"))
  ("\\/"      (return (tok :frac)))
  ("{{AS-IS}}"
   (return (tok :symbol (funcall #'formulador::box (as-is (princ-to-string $@))))))
  ("{{NUM}}"
   (return (tok :number (funcall #'formulador::box (string-space (princ-to-string $@))))))
  ("{{SYMBOL}}"
   (return (tok :symbol (funcall #'formulador::box (string-space (princ-to-string $@))))))
  ("{{INFIX-OPER}}"
   (return (tok :infix-oper (funcall #'formulador::box (string-space (princ-to-string $@))))))
  ;("\\/"      (return (tok :frac)))
  ("\\^"      (return (tok :exponent)))
  ("\\("      (return (tok :left-paren)))
  ("\\)"      (return (tok :right-paren)))
  ("\\["      (return (tok :left-brack)))
  ("\\]"      (return (tok :right-brack)))
  ("\\s+"     nil))  
;(alexa:define-string-lexer formulexer
 ; "A lexical analyzer for formulador input."
;  ((:oper   "[=+*-]")
;   (:num  "\\d+")
;   (:symb "[A-Za-z][A-Za-z0-9_]*"))
 ; ("{{OPER}}" (return (tok :operator (princ-to-string $@))))
 ; ("{{NUM}}"  (return (tok :number (princ-to-string $@))))
;  ("{{SYMB}}" (return (tok :variable (princ-to-string $@))))
;  ("\\/"      (return (tok :frac (intern $@ 'keyword))))
;  ("\\^"      (return (tok :exponent)))
;  ("\\("      (return (tok :left-paren)))
;  ("\\)"      (return (tok :right-paren)))
;  ("\\["      (return (tok :left-brack)))
;  ("\\]"      (return (tok :right-brack)))
;  ("\\s+"     nil))

(defun lex-line (string)
  "Breaks down a formula string into tokens."
  (loop :with lexer := (formulexer string)
	:for tok := (funcall lexer)
	:while tok
	:collect tok))
