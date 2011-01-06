(in-package #:kgb)

(defun login-user (alias password)
  (let ((user (find-user-alias alias)))
    (if user
        (if (string= (user-password user) password)
            user
            (signal (make-condition 'login-wrong-password :user-alias alias)))
        (signal (make-condition 'login-unknown-alias :user-alias alias)))))

(defgeneric authenticate (request))

(defmethod authenticate (request)
  nil)

(defparameter *user* nil)

(defmacro with-authentication (request &body body)
  `(let ((*user* (or (authenticate ,request)
                     (make-guest))))
     (declare (special *user*))
     ,@body))
