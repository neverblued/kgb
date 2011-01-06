(in-package #:kgb)

(defvar direct-rights (make-hash-table))

(macrolet ((rights (subject)
             `(gethash ,subject direct-rights nil)))

  (defun direct-rights (subject)
    (values (rights subject)))

  (defun (setf direct-rights) (new-rights subject)
    (setf (rights subject) new-rights)))
