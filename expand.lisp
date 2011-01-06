(in-package #:kgb)

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
