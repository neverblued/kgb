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

(defun make-seal (person password)
  (checksum (join (id person) "~secret~" password)))

(defun reset-seal (person password)
  (setf (seal person) (make-seal person password)))

(defun check-seal (person password)
  (equal (seal person) (make-seal person password)))

;; fetch

(defun id-person (id)
  (get-dao 'person id))

(defun alias-person (alias)
  (car (query-dao 'person (:select '* :from 'person :where (:= 'alias alias)))))

(defun seal-person (seal)
  (car (query-dao 'person (:select '* :from 'person :where (:= 'seal seal)))))

;; count

(defun count-person ()
  (query (:select (:count 'id) :from 'person) :single))

(defun max-id ()
  (let ((max-id (query (:select (:max 'id) :from 'person) :single)))
    (if (eql max-id :null) 0 max-id)))

(defun next-id ()
  (+ 1 (max-id)))

;; manipulate

(defmethod insert-dao :before ((person person))
  (setf (id person) (next-id)))

(defun kill (person)
  (delete-dao person))

(defun create-person (&rest args)
  (apply #'make-dao 'person args))

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

(defun user? (subject)
  (and (person? subject)
       (not (string= "" (alias subject)))))
