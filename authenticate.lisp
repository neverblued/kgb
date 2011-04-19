(in-package #:kgb)

(defun login (alias password)
  (let ((user (alias-user alias)))
    (unless user
      (error 'unknown-login-alias :login-alias alias))
    (unless (string= (password user) password)
      (error 'wrong-login-password :login-alias alias))
    (push (cons (get-universal-time) user) (logbook system))
    user))

(defgeneric authenticate (request))

(defmethod authenticate (request)
  nil)

(defun introduce-guest ()
  (alias-ensure-user (guest-alias)))

(defmacro with-system (system &body body)
  `(let ((kgb::system ,system) kgb::user)
     ,@body))

(defmacro with-authentication (request &body body)
  `(let ((user (or (authenticate ,request)
                   (introduce-guest))))
     ,@body))
