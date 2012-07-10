;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:kgb)

(defparameter seal-secret "~secret~")

(defun make-seal (person password)
  (checksum (join (alias person) seal-secret password)))

(defun check-seal (person password)
  (equal (seal person)
         (make-seal person password)))

(defun reset-seal (person password)
  (setf (seal person)
        (make-seal person password)))
