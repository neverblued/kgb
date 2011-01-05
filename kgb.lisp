(in-package #:kgb)

;; right

(defvar rights (make-hash-table))

(defun rights (subject)
  (gethash subject rights nil))

(defun (setf rights) (new-rights subject)
  (setf (gethash subject rights nil) new-rights))

;; expansion

(defvar expansions nil)

(flet ((expansion (source result)
         (cons source result))
       (source (expansion)
         (car expansion))
       (result (expansion)
         (cdr expansion)))

  (defun expand! (source result)
    (pushnew (expansion source result) expansions :test #'equal)
    result)

  (defun expand? (source result)
    (true? (find (expansion source result) expansions :test #'equal)))

  (defun expand (source)
    (append (list source)
            (mapcar #'result
                    (remove-if-not (lambda (expansion)
                                     (equal (source expansion) source))
                                   expansions)))))

;; groups

(defvar groups (make-hash-table))

(defun groups (subject)
  (gethash subject groups nil))

(defun (setf groups) (new-groups group)
  (setf (gethash group groups) new-groups))

(defun all-groups (subject)
  (labels ((rec-groups (subject)
             (let ((groups (groups subject)))
               (when groups
                 (union groups (reduce #'union (mapcar #'rec-groups groups)))))))
    (adjoin subject (rec-groups subject))))

;; depute

(defun depute! (subject group)
  (pushnew group (groups subject)))

(defun depute-directly? (subject group)
  (true? (find group (groups subject))))

(defun depute-indirectly? (subject group)
  (notevery #'null (mapcar (lambda (specific-group)
                             (depute? specific-group group))
                           (groups subject))))

(defun depute? (subject group)
  (or (depute-directly? subject group)
      (depute-indirectly? subject group)))

;; access

(defun allow! (subject right)
  (pushnew right (rights subject))
  t)

(defun group-rights (subject)
  (reduce #'union (mapcar #'rights (all-groups subject))))

(defun allow? (subject right)
  (true? (intersection (group-rights subject) (expand right))))

;; user

(defgeneric user-alias (user))
(defgeneric user-password (user))
(defgeneric user-ausweis (user))
(defgeneric user-name (user))

(defvar users (make-instance 'container :key #'user-alias :test #'equal))

(defclass user (containable)
  (
   (user-alias :initarg :alias
               :accessor user-alias
               )
   (user-password :initarg :password
                  :accessor user-password
                  )
   (user-name :initarg :name
              :initform "Anonymous"
              :accessor user-name
              )
   ))

(defun checksum (secret)
  (ironclad:byte-array-to-hex-string (ironclad:digest-sequence :sha256 (ironclad:ascii-string-to-byte-array secret))))

(defmethod user-ausweis ((user user))
  (checksum (join (user-alias user) (user-password user) "secret!")))

(defun find-user-alias (alias)
  (find-containing-key alias users))

(defun find-user-ausweis (ausweis)
  (find ausweis (container-list users) :key #'user-ausweis :test #'string=))

(defmethod initialize-instance :after ((user user) &key)
  (put-into user users))

;; authentication

(defun ensure-user-alias (alias)
  (or (find-user-alias alias)
      (make-instance 'user :alias alias)))

(defun make-guest ()
  (ensure-user-alias (join "guest" "123"))) ; (hunchentoot::session-cookie-value hunchentoot::*session*)

(defun signup-authentication (alias password)
  (let ((user (find-user-alias alias)))
    (when (and user (string= (user-password user) password))
      user)))

(defgeneric authenticate (request))

(defmethod authenticate (request)
  nil)

(defmacro with-authentication (request &body body)
  `(let ((*user* (authenticate ,request)))
     (declare (special *user*))
     ,@body))
