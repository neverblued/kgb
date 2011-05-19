(in-package #:kgb)

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

(defun power? (right)
  "If current USER has RIGHT."
  (if (typep user 'person)
      (allow? user right)
      (error 'user-not-found)))

(defun status? (subject)
  "If current USER is deputed from SUBJECT."
  (if (typep user 'person)
      (depute? user subject)
      (error 'user-not-found)))
