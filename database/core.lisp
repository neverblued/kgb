;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:kgb)

(defun max-id (table)
  (let ((max-id (query (:select (:max 'id) :from table) :single)))
    (if (eql max-id :null)
        0
        max-id)))

(defparameter dao-names '(person
                          person-depute
                          community-depute
                          person-power
                          community-power
                          power-expansion
                          log-record))

(defun authentication-possible? ()
  (and (typep *database* 'database-connection)
       (ensure-dao-tables dao-names)
       t))

(defmacro with-authentication (request &body body)
  (once-only (request)
    `(if (authentication-possible?)
         (let ((user (or (authenticate ,request)
                         (introduce-guest ,request))))
           ,@body)
         (error 'authentication-impossible))))
