(in-package #:kgb)

(defclass power ()
  ((subject :initarg :subject :accessor power-subject :column t)
   (right :initarg :right :accessor power-right :col-type string))
  (:metaclass dao-class)
  (:keys subject right))

(defclass person-power (power)
  ((subject :col-type integer))
  (:metaclass dao-class))

(defclass group-power (power)
  ((subject :col-type string))
  (:metaclass dao-class))

(defgeneric direct-rights (subject))

(defmethod direct-rights :around (subject)
  (aif (call-next-method)
       (mapcar (compost #'power-right #'name-keyword) it)))

(defmethod direct-rights ((subject person))
  (select-dao 'person-power (:= 'subject (id subject))))

(defmethod direct-rights ((subject symbol))
  (select-dao 'group-power (:= 'subject (keyword-name subject))))

(defgeneric power-dao (subject right))

(defmethod power-dao ((subject person) right)
  (make-instance 'person-power
                 :subject (id subject)
                 :right (keyword-name right)))

(defmethod power-dao ((subject symbol) right)
  (make-instance 'group-power
                 :subject (keyword-name subject)
                 :right (keyword-name right)))

(defun (setf direct-rights) (new-rights subject)
  (let* ((current (direct-rights subject))
         (fresh (set-difference new-rights current))
         (obsolete (set-difference current new-rights)))
    (iter (for right in obsolete)
          (delete-dao (power-dao subject right)))
    (iter (for right in fresh)
          (insert-dao (power-dao subject right)))))

(defclass power-expansion ()
  ((root :initarg :root :accessor expansion-root :col-type string)
   (branch :initarg :branch :accessor expansion-branch :col-type string))
  (:metaclass dao-class)
  (:keys root branch))

(defun expand (root)
  (adjoin root (aif (select-dao 'power-expansion (:= 'root (keyword-name root)))
                    (mapcar (compost #'expansion-branch #'name-keyword) it))))

(defun expand! (root branch)
  (save-dao (make-instance 'power-expansion
                           :root (keyword-name root)
                           :branch (keyword-name branch))))

(defun expand? (root branch)
  (true? (select-dao 'power-expansion (:and (:= 'root (keyword-name root))
                                            (:= 'branch (keyword-name branch))))))

(defun rights (subject)
  "All rights of the SUBJECT."
  (awhen (reduce #'union (mapcar #'direct-rights (groups subject)))
    (reduce #'union (mapcar #'expand it))))

(defun allow! (subject right)
  "Assign a direct RIGHT to SUBJECT."
  (pushnew right (direct-rights subject))
  t)

(defun allow? (subject right)
  "Is the RIGHT available for the SUBJECT?"
  (true? (intersection (rights subject) (expand right))))

(defun person? (subject)
  (typep subject 'person))

(defun power? (right)
  "If current USER has RIGHT."
  (if (person? user)
      (allow? user right)
      (error 'authentication-missing)))

(defun status? (subject)
  "If current USER is deputed from SUBJECT."
  (if (person? user)
      (depute? user subject)
      (error 'authentication-missing)))
