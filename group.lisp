(in-package #:kgb)

(defun direct-groups (subject)
  (values (gethash subject (direct-groups-table system) nil)))

(defun (setf direct-groups) (new-groups subject)
  (setf (gethash subject (direct-groups-table system)) new-groups))

(defun groups (subject)
  (labels ((rec-groups (subject)
             (awhen (direct-groups subject)
               (reduce #'union (adjoin it (mapcar #'rec-groups it))))))
    (adjoin subject (rec-groups subject))))

(defun depute! (subject group)
  (pushnew group (direct-groups subject)))

(defun undepute! (subject group)
  (delete group (direct-groups subject)))

(defun depute-directly? (subject group)
  (true? (find group (direct-groups subject))))

(defun depute-indirectly? (subject group)
  (notevery #'null (mapcar (lambda (subject)
                             (depute? subject group))
                           (direct-groups subject))))

(defun depute? (subject group)
  (or (depute-directly? subject group)
      (depute-indirectly? subject group)))
