(in-package #:kgb)

(defgeneric alias (person))
(defgeneric password (person))
(defgeneric name (person))
(defgeneric ausweis (person))

(defun guest-alias ()
  (if (boundp 'hunchentoot::*session*)
      (join "guest-" (subseq (hunchentoot::session-cookie-value hunchentoot::*session*) 2 12))
      "guest"))

(defparameter default-name "Незнакомец")

(defclass person ()
  ((alias :initarg :alias :accessor alias :initform (guest-alias))
   (password :initarg :password :accessor password :initform "")
   (name :initarg :name :accessor name :initform default-name)))

(defmethod print-object ((person person) stream)
  (format stream "<PERSON ~a (~a)>" (alias person) (name person)))

(defvar persons nil)

(defun alias-person (alias)
  (find alias persons :key #'alias :test #'string=))

(defun ausweis-person (ausweis)
  (find ausweis persons :key #'ausweis :test #'string=))

(defun kill (person)
  (declare (type person person))
  (setf persons (delete (alias person) persons :key #'alias :test #'string=))
  nil)

(defmethod initialize-instance :after ((person person) &key)
  (awhen (alias-person (alias person))
    (cerror (format nil "Заменить личность ~a свежесозданной ~a." it person)
            'alias-duplication :old-person it :new-person person)
    (kill it))
  (push person persons))

(defmethod ausweis ((person person))
  (checksum (join (alias person) "~secret~" (password person))))

(defun alias-ensure-person (alias)
  (handler-case
      (make-instance 'person :alias alias)
    (alias-duplication (condition)
      (return-from alias-ensure-person (old-person condition)))))
