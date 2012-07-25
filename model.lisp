;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:kgb)

;; subject

(defgeneric subject= (subject-1 subject-2))

(defclass subject ()
  ((alias :initarg :alias :accessor alias :initform nil)))

;; person

(defclass person (subject)
  ((seal :initarg :seal :accessor seal :initform nil)
   (name :initarg :name :accessor name :initform nil)))

(defgeneric default-name (person))

(defmethod name :around ((it person))
  (or (call-next-method)
      (default-name it)
      (alias it)))

(defmethod default-name ((it person))
  nil)

;; community

(defclass community (subject) ())

;; depute

(defgeneric begin-depute (subject community))

(defgeneric end-depute (subject community))

(defgeneric check-depute (subject community))

(defgeneric depute= (depute-1 depute-2))

(defclass depute ()
  ((subject :initarg :subject :accessor subject)
   (community :initarg :community :accessor community)))

;; right

;(defgeneric spreads (root))

;(defgeneric spread? (root branch))

;(defclass right (secure-object) ())

;(defclass power ()
;  ((power-subject :initarg :power-subject :accessor power-subject)
;   (power-right :initarg :power-right :accessor power-right)))

;(defclass spread ()
;  ((spread-root :initarg :spread-root :accessor spread-root)
;   (spread-branch :initarg :spread-branch :accessor spread-branch)))

;; authentication

(defgeneric guest-alias (request))
(defgeneric guest-password (request))

;(defgeneric introduce-guest (request &key person-class))
