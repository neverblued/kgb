(in-package #:kgb)

(defun allow! (subject right)
  (pushnew right (direct-rights subject))
  t)

(defun rights (subject)
  (let ((r (remove-duplicates (reduce #'union
                                      (mapcar #'direct-rights (groups subject))))))
    (when r (apply #'expand r))))

(defun allow? (subject right)
  (true? (intersection (rights subject) (expand right))))
