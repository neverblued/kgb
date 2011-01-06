(in-package #:kgb)

(defvar direct-groups (make-hash-table))

(macrolet ((groups (subject)
             `(gethash ,subject direct-groups nil)))

  (defun direct-groups (subject)
    (values (groups subject)))

  (defun (setf direct-groups) (new-groups subject)
    (setf (groups subject) new-groups)))

(defun groups (subject)
  (labels ((rec-groups (subject)
             (let ((groups (direct-groups subject)))
               (when groups
                 (remove-duplicates (reduce #'union (adjoin groups (mapcar #'rec-groups groups))))))))
    (adjoin subject (rec-groups subject))))
