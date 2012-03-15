;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:kgb)

(defgeneric depute-dao (subject community))

(defmethod create-depute (subject community)
  (insert-dao (depute-dao subject community)))

(defmethod delete-depute (subject community)
  (delete-dao (depute-dao subject community)))

(defgeneric depute-subject (depute))
(defgeneric depute-community (depute))

(defmethod direct-communities :around (subject)
  (aif (call-next-method)
       (mapcar (compost #'depute-community #'name-keyword) it)))

(defclass depute ()
  ((subject :initarg :subject :accessor depute-subject :column t)
   (community :initarg :community :accessor depute-community :col-type string))
  (:metaclass dao-class)
  (:keys subject community))

(defclass person-depute (depute)
  ((subject :col-type integer))
  (:metaclass dao-class))

(defclass community-depute (depute)
  ((subject :col-type string))
  (:metaclass dao-class))

(defmethod depute-dao ((subject person) community)
  (make-instance 'person-depute
                 :subject (id subject)
                 :community (keyword-name community)))

(defmethod depute-dao ((subject symbol) community)
  (make-instance 'community-depute
                 :subject (keyword-name subject)
                 :community (keyword-name community)))

(defmethod direct-communities ((subject person))
  (select-dao 'person-depute (:= 'subject (id subject))))

(defmethod direct-communities ((subject symbol))
  (select-dao 'community-depute (:= 'subject (keyword-name subject))))
