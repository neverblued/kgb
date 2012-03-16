;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:kgb)

(defgeneric power-expansions (root))
(defgeneric power-expand? (root branch))

(defun expand-right (root)
  (adjoin root (power-expansions root)))

(defmethod power-expand? :around (root branch)
  (true? (call-next-method)))

(defgeneric create-expansion (root branch))
(defgeneric delete-expansion (root branch))

(defmethod (setf power-expansions) (new-expansions root)
  (let* ((expansions (power-expansions root))
         (fresh (set-difference new-expansions expansions))
         (obsolete (set-difference expansions new-expansions)))
    (iter (for right in obsolete)
          (delete-expansion root right))
    (iter (for right in fresh)
          (create-expansion root right))))
