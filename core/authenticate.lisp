;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:kgb)

(defvar user)

(defgeneric write-log (person))

(defun login (alias password)
  (let ((person (alias-person alias)))
    (unless person
      (error 'unknown-login-alias :login-alias alias))
    (unless (check-seal person password)
      (error 'wrong-login-password :login-alias alias))
    (write-log person)
    person))

(defgeneric authenticate (request))

(defmethod authenticate (request)
  nil)
