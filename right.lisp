(in-package #:kgb)

(defvar direct-rights (make-hash-table))

(defun direct-rights (subject)
  (values (gethash subject direct-rights nil)))

(defun (setf direct-rights) (new-rights subject)
  (setf (gethash subject direct-rights) new-rights))

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
    (remove-duplicates (adjoin source (mapcar #'result (remove source expansions :key #'source :test-not #'equal))))))

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
