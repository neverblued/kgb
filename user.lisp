(in-package #:kgb)

(defgeneric alias (user))
(defgeneric password (user))
(defgeneric name (user))
(defgeneric ausweis (user))

(defun guest-alias ()
  (if (boundp 'hunchentoot::*session*)
      (join "guest-" (subseq (hunchentoot::session-cookie-value hunchentoot::*session*) 2 12))
      "guest"))

(defparameter default-user-name "Незнакомец")

(defclass user ()
  ((alias :initarg :alias :accessor alias)
   (password :initarg :password :accessor password :initform "")
   (name :initarg :name :accessor name :initform default-user-name)))

(defmethod print-object ((user user) stream)
  (format stream "<USER ~a (~a)>" (alias user) (name user)))

(defun alias-user (alias)
  (find alias (users system) :key #'alias :test #'string=))

(defun ausweis-user (ausweis)
  (find ausweis (users system) :key #'ausweis :test #'string=))

(defun kill (user)
  (declare (type user user))
  (setf (users system)
        (delete (alias user) (users system) :key #'alias :test #'string=))
  nil)

(defmethod initialize-instance :after ((user user) &key)
  (awhen (alias-user (alias user))
    (cerror (format nil "Заменить личность ~a свежесозданной ~a." it user)
            'alias-duplication :old-user it :new-user user)
    (kill it))
  (push user (users system)))

(defmethod ausweis ((user user))
  (checksum (join (alias user) "~secret~" (password user))))

(defun alias-ensure-user (alias)
  (handler-case (make-instance 'user :alias alias)
    (alias-duplication (condition)
      (return-from alias-ensure-user (old-user condition)))))
