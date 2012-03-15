;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:kgb)

(define-condition achtung (simple-error)
  ((timestamp :initform (get-universal-time) :reader timestamp)))

(define-condition authentication-impossible (achtung) ()
  (:report (lambda (condition stream)
             (declare (ignore condition))
             (format stream "Отказ системы безопасности, опознание невозможно."))))

(define-condition alias-duplication (achtung)
  ((old-person :initarg :old-person :reader old-person)
   (new-person :initarg :new-person :reader new-person))
  (:report (lambda (condition stream)
             (format stream "Попытка создать личность с существующим позывным '~a'."
                     (alias (old-person condition))))))

(define-condition authentication-missing (achtung) ()
  (:report (lambda (condition stream)
             (declare (ignore condition))
             (format stream "Опознание личности не произошло."))))

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

(define-condition access-denied (achtung) ()
  (:report (lambda (condition stream)
             (declare (ignore condition))
             (format stream "Нет доступа."))))
