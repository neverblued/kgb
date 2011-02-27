(in-package #:kgb)

(define-condition achtung (simple-error) ())

(define-condition human-not-found (achtung) ())

(define-condition login-failure (achtung)
  ((user-alias :initform :user-alias :reader condition-user-alias))
  (:report (lambda (condition stream)
             (declare (ignore condition))
             (format stream "����� �� �������."))))

(define-condition login-unknown-alias (login-failure) ()
  (:report (lambda (condition stream)
             (declare (ignore condition))
             (format stream "����������� ��������."))))

(define-condition login-wrong-password (login-failure) ()
  (:report (lambda (condition stream)
             (declare (ignore condition))
             (format stream "������������ ������."))))
