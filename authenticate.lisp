(in-package #:kgb)

(defvar user)

(defvar *login-log* nil)

(defun login (alias password)
  (let ((person (alias-person alias)))
    (unless person
      (error 'unknown-login-alias :login-alias alias))
    (unless (string= (password person) password)
      (error 'wrong-login-password :login-alias alias))
    (push (cons (get-universal-time) person) *login-log*)
    person))

(defgeneric authenticate (request))

(defmethod authenticate (request)
  nil)

(defun guest ()
  (alias-ensure-person (guest-alias)))

(defmacro with-authentication (request &body body)
  `(let ((user (or (authenticate ,request)
                   (guest))))
     ,@body))
