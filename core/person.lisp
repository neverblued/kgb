;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:kgb)

;; class

(defgeneric id (person))
(defgeneric alias (person))
(defgeneric seal (person))
(defgeneric name (person))

(defparameter default-name "Незнакомец")

(defclass person ()
  ((id :initarg :id :accessor id :col-type integer)
   (alias :initarg :alias :accessor alias :initform "" :col-type string)
   (seal :initarg :seal :accessor seal :initform "" :col-type string)
   (name :initarg :name :accessor name :initform default-name :col-type string))
  (:metaclass dao-class)
  (:keys id))

(defmethod print-object ((person person) stream)
  (format stream "#<~a №~a ~a {~a}>" (class-name (class-of person)) (id person) (alias person) (name person)))

;; seal

(defparameter seal-secret "~secret~")

(defun make-seal (person password)
  (checksum (join (id person) seal-secret password)))

(defun reset-seal (person password)
  (setf (seal person) (make-seal person password)))

(defun check-seal (person password)
  (equal (seal person) (make-seal person password)))

;; guest

(defgeneric guest-password (request))

(defmethod guest-password (request)
  "")

(defgeneric introduce-guest (request))

(defmethod introduce-guest (request)
  (let ((guest (create-person)))
    (reset-seal guest (guest-password request))
    (update-dao guest)
    guest))

;; check

(defun person? (subject)
  (typep subject 'person))

(defun user? (subject)
  (true? (and (person? subject)
              (id subject))))

(defun check-user ()
  (unless (person? user)
    (error 'authentication-missing)))
