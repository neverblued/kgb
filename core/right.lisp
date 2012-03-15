;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:kgb)

(defgeneric direct-rights (subject))
(defgeneric expand-right (right))

(defun rights (subject)
  "All rights of the SUBJECT."
  (awhen (reduce #'union (mapcar #'direct-rights (communities subject)))
    (reduce #'union (mapcar #'expand-right it))))

(defun allow! (subject right)
  "Assign a direct RIGHT to SUBJECT."
  (pushnew right (direct-rights subject))
  t)

(defun allow? (subject right)
  "Is the RIGHT available for the SUBJECT?"
  (true? (intersection (rights subject)
                       (expand-right right))))

(defun power? (right)
  "If current USER has RIGHT."
  (check-user)
  (allow? user right))

;; power control

(defgeneric create-power (subject right))
(defgeneric delete-power (subject right))

(defun (setf direct-rights) (new-rights subject)
  (let* ((rights (direct-rights subject))
         (fresh (set-difference new-rights rights))
         (obsolete (set-difference rights new-rights)))
    (iter (for right in obsolete)
          (delete-power subject right))
    (iter (for right in fresh)
          (create-power subject right))))
