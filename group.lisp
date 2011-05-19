(in-package #:kgb)

(defclass depute ()
  ((subject :initarg :subject :accessor depute-subject :column t)
   (group :initarg :group :accessor depute-group :col-type string))
  (:metaclass dao-class)
  (:keys subject group))

(defclass person-depute (depute)
  ((subject :col-type integer))
  (:metaclass dao-class))

(defclass group-depute (depute)
  ((subject :col-type string))
  (:metaclass dao-class))

(defgeneric direct-groups (subject))

(defmethod direct-groups :around (subject)
  (aif (call-next-method)
       (mapcar (compost #'depute-group #'name-keyword) it)))

(defmethod direct-groups ((subject person))
  (select-dao 'person-depute (:= 'subject (id subject))))

(defmethod direct-groups ((subject symbol))
  (select-dao 'group-depute (:= 'subject (keyword-name subject))))

(defgeneric depute-dao (subject group))

(defmethod depute-dao ((subject person) group)
  (make-instance 'person-depute
                 :subject (id subject)
                 :group (keyword-name group)))

(defmethod depute-dao ((subject symbol) group)
  (make-instance 'group-depute
                 :subject (keyword-name subject)
                 :group (keyword-name group)))

(defun (setf direct-groups) (new-groups subject)
  (let* ((current (direct-groups subject))
         (fresh (set-difference new-groups current))
         (obsolete (set-difference current new-groups)))
    (iter (for group in obsolete)
          (delete-dao (depute-dao subject group)))
    (iter (for group in fresh)
          (insert-dao (depute-dao subject group)))))

(defun groups (subject)
  (labels ((rec-groups (subject)
             (awhen (direct-groups subject)
               (reduce #'union (adjoin it (mapcar #'rec-groups it))))))
    (let ((groups (adjoin subject (rec-groups subject))))
      (if (user? subject)
          (union groups (list :user))
          groups))))

(defun depute! (subject group)
  (pushnew group (direct-groups subject)))

(defun undepute! (subject group)
  (delete group (direct-groups subject)))

(defun depute-directly? (subject group)
  (true? (find group (direct-groups subject))))

(defun depute-indirectly? (subject group)
  (or (and (eql group :user) (user? subject))
      (notevery #'null (mapcar (lambda (subject)
                                 (depute? subject group))
                               (direct-groups subject)))))

(defun depute? (subject group)
  (or (depute-directly? subject group)
      (depute-indirectly? subject group)))
