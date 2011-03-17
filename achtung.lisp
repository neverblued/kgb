(in-package #:kgb)

(define-condition achtung (simple-error)
  ((timestamp :initform (get-universal-time) :reader timestamp)))

(define-condition alias-duplication (achtung)
  ((old-person :initarg :old-person :reader old-person)
   (new-person :initarg :new-person :reader new-person))
  (:report (lambda (condition stream)
             (format stream "Попытка создать личность с существующим позывным '~a'."
                     (alias (old-person condition))))))

(define-condition user-not-found (achtung) ())

(define-condition login-failure (achtung)
  ((login-alias :initform :login-alias :reader login-alias))
  (:report (lambda (condition stream)
             (declare (ignore condition))
             (format stream "Войти не удалось."))))

(define-condition unknown-login-alias (login-failure) ()
  (:report (lambda (condition stream)
             (declare (ignore condition))
             (format stream "Неизвестный позывной."))))

(define-condition wrong-login-password (login-failure) ()
  (:report (lambda (condition stream)
             (declare (ignore condition))
             (format stream "Неправильный пароль."))))
