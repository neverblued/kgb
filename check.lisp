(in-package #:kgb)

(defun power? (right)
  (if (typep *user* 'user)
      (allow? *user* right)
      (error 'human-not-found)))

(defun status? (subject)
  (if (typep *user* 'user)
      (depute? *user* subject)
      (error 'human-not-found)))
