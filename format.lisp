;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:kgb)

(defmethod print-object ((it person) stream)
  (format stream "#<:) ~a>" (name it)))

(defmethod print-object ((it community) stream)
  (format stream "#<%) ~a>" (or (alias it) "?")))
