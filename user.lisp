(in-package #:kgb)

(defgeneric user-alias (user))

(defgeneric user-password (user))

(defgeneric user-name (user))

(defgeneric user-ausweis (user))

(defvar users (make-instance 'container :key #'user-alias :test #'equal))

(defclass user (containable)
  (
   (alias :initarg :alias
          :accessor user-alias
          )
   (password :initarg :password
             :initform ""
             :accessor user-password
             )
   (name :initarg :name
         :initform "Anonymous"
         :accessor user-name
         )
   ))

(defmethod initialize-instance :after ((user user) &key)
  (put-into user users))

(defun checksum (secret)
  (ironclad:byte-array-to-hex-string (ironclad:digest-sequence :sha256 (ironclad:ascii-string-to-byte-array secret))))

(defmethod user-ausweis ((user user))
  (checksum (join (user-alias user) "~secret~" (user-password user))))

(defun find-user-alias (alias)
  (find-containing-key users alias))

(defun find-user-ausweis (ausweis)
  (find ausweis (container-list users) :key #'user-ausweis :test #'string=))

(defun ensure-user-alias (alias)
  (or (find-user-alias alias)
      (make-instance 'user :alias alias)))

(defun make-guest ()
  (ensure-user-alias "guest")) ; (join "guest-" (hunchentoot::session-cookie-value hunchentoot::*session*))))
