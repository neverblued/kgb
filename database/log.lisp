;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:kgb)

(defclass log-record ()
  ((date :initarg :date :accessor log-date :col-type timestamp)
   (person :initarg :person :accessor log-person :col-type string))
  (:metaclass dao-class))

(defmethod write-log (person)
  (insert-dao (make-instance 'log-record
                             :date (universal-time-to-timestamp (get-universal-time))
                             :person (alias person))))
