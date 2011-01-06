(in-package #:kgb)

(define-condition achtung ()
  ())

(define-condition human-not-found (achtung)
  ())

(define-condition login-failure (achtung)
  (
   (user-alias :initform :user-alias
               :reader login-user-alias
               )
   ))

(define-condition login-unknown-alias (login-failure)
  ())

(define-condition login-wrong-password (login-failure)
  ())
