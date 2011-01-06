(in-package #:kgb)

(defun power? (right)
  (if (typep *user* 'user)
      (allow? *user* right)
      (signal (make-condition 'human-not-found))))

(defun status? (subject)
  (if (typep *user* 'user)
      (depute? *user* subject)
      (signal (make-condition 'human-not-found))))
