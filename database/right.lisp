;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:kgb)

(defgeneric power-dao (subject right))

(defmethod create-power (subject right)
  (insert-dao (power-dao subject right)))

(defmethod delete-power (subject right)
  (delete-dao (power-dao subject right)))

(defgeneric power-subject (power))
(defgeneric power-right (power))

(defmethod direct-rights :around (subject)
  (aif (call-next-method)
       (mapcar (compost #'power-right #'name-keyword) it)))

(defclass power ()
  ((subject :initarg :subject :accessor power-subject :column t)
   (right :initarg :right :accessor power-right :col-type string))
  (:metaclass dao-class)
  (:keys subject right))

(defclass person-power (power)
  ((subject :col-type integer))
  (:metaclass dao-class))

(defclass community-power (power)
  ((subject :col-type string))
  (:metaclass dao-class))

(defmethod direct-rights ((subject person))
  (select-dao 'person-power (:= 'subject (id subject))))

(defmethod direct-rights ((subject symbol))
  (select-dao 'community-power (:= 'subject (keyword-name subject))))

(defmethod power-dao ((subject person) right)
  (make-instance 'person-power
                 :subject (id subject)
                 :right (keyword-name right)))

(defmethod power-dao ((subject symbol) right)
  (make-instance 'community-power
                 :subject (keyword-name subject)
                 :right (keyword-name right)))
