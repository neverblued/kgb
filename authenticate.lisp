(in-package #:kgb)

(defparameter *login-log* nil)
(defvar *user*)

(defun login-user (alias password)
  (let ((user (alias-user alias)))
    (unless user
      (error 'login-unknown-alias :user-alias alias))
    (unless (string= (user-password user) password)
      (error 'login-wrong-password :user-alias alias))
    (push (cons (get-universal-time) user) *login-log*)
    user))

(defgeneric authenticate (request))

(defmethod authenticate (request)
  nil)

(defmacro with-authentication (request &body body)
  `(let ((*user* (or (authenticate ,request)
                     (make-guest))))
     ,@body))
