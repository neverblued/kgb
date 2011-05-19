(in-package #:kgb)

(defvar user)

(defclass log-record ()
  ((date :initarg :date :accessor log-date :col-type timestamp)
   (person :initarg :person :accessor log-person :col-type string))
  (:metaclass dao-class))

(defun log-authentication (person)
  (insert-dao (make-instance 'log-record
                             :date (universal-time-to-timestamp (get-universal-time))
                             :person (alias person))))

(defun login (alias password)
  (let ((person (alias-person alias)))
    (unless person
      (error 'unknown-login-alias :login-alias alias))
    (unless (check-seal person password)
      (error 'wrong-login-password :login-alias alias))
    (log-authentication person)
    person))

(defgeneric authenticate (request))

(defmethod authenticate (request)
  nil)

(defun authentication-possible? ()
  (and (typep *database* 'database-connection)
       (table-exists-p :person)))

(defmacro with-authentication (request &body body)
  (with-gensyms (req)
    `(let* ((,req ,request)
            (kgb::user (and (kgb::authentication-possible?)
                            (or (kgb::authenticate ,req)
                                (kgb::introduce-guest ,req)))))
       ,@body)))
