(in-package #:kgb)

(defgeneric user-alias (user))
(defgeneric user-password (user))
(defgeneric user-name (user))
(defgeneric user-ausweis (user))

(defvar users (make-instance 'container :key #'user-alias :test #'equal))

(defclass user (containable)
  ((alias :initarg :alias :accessor user-alias)
   (password :initarg :password :accessor user-password :initform "")
   (name :initarg :name :accessor user-name :initform "Anonymous")))

(defmethod initialize-instance :after ((user user) &key)
  (put-into user users))

(defmethod user-ausweis ((user user))
  (checksum (join (user-alias user) "~secret~" (user-password user))))

(defun alias-user (alias)
  (find-containing-key users alias))

(defun alias-ensure-user (alias)
  (or (alias-user alias)
      (make-instance 'user :alias alias)))

(defun ausweis-user (ausweis)
  (find ausweis (container-list users) :key #'user-ausweis :test #'string=))

(defun make-guest ()
  (alias-ensure-user (join "guest-" (subseq (hunchentoot::session-cookie-value hunchentoot::*session*) 2 12))))
