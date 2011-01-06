(in-package #:kgb)

(defun depute! (subject group)
  (pushnew group (direct-groups subject)))

(defun depute-directly? (subject group)
  (true? (find group (direct-groups subject))))

(defun depute-indirectly? (subject group)
  (notevery #'null (mapcar (lambda (subject)
                             (depute? subject group))
                           (direct-groups subject))))

(defun depute? (subject group)
  (or (depute-directly? subject group)
      (depute-indirectly? subject group)))
