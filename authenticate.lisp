;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:kgb)

;; user

(defvar user)

(defun assert-user ()
  (unless (user? user)
    (error 'authentication-missing)))

(defun status? (subject)
  (aif subject
       (handler-case
           (progn (assert-user)
                  (check-depute user it))
         (achtung ()
           nil))
       t))

;; with-authentication

(defgeneric authentication-possible? ())

(defgeneric request-user (request))

(defmacro with-authentication (request &body body)
  `(if (authentication-possible?)
       (let ((user (request-user ,request)))
         ,@body)
       (error 'authentication-impossible)))

;; request-user

(defgeneric authenticate (request))

(defgeneric introduce-guest (request))

(defmethod request-user (it)
  (or (authenticate it)
      (introduce-guest it)))

(defmethod authenticate (it)
  (login (alias it) (password it)))

;; login

(defgeneric log-authentication (person))

(defun login (alias password)
  (awith (alias-person alias)
    (unless it
      (error 'unknown-login-alias :login-alias alias))
    (unless (check-seal it password)
      (error 'wrong-login-password :login-alias alias))
    (log-authentication it)
    it))

;; guest

(defparameter guest-class 'person)

(defgeneric guest-alias (request))

(defgeneric guest-password (request))

(defmethod guest-alias (request)
  (symbol-name (gensym "USER")))

(defmethod guest-password (request)
  (symbol-name (gensym)))

(defun make-guest (&rest args)
  (unless (subtypep guest-class 'person)
    (error 'type-error :expected-type 'person :datum guest-class))
  (apply #'make-instance guest-class args))

(defmethod introduce-guest (request)
  (awith (make-guest :alias (guest-alias request))
    (reset-seal it (guest-password request))
    it))

;; credentials

(defclass credentials ()
  ((alias :initarg :alias :reader alias)
   (password :initarg :password :reader password)))

(defun alias+password (alias password)
  (make-instance 'credentials
                 :alias alias
                 :password password))

(defun request-credentials (request)
  (macrolet ((extract (request)
               `(awhen ,request
                  (with-accessors ((alias alias)
                                   (password password)) it
                    (when (and alias password)
                      (alias+password alias password))))))
    (handler-case (extract request)
      (error () nil))))
