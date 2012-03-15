;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:kgb)

(defgeneric expansion-root (expansion))
(defgeneric expansion-branch (expansion))

(defmethod power-expansions :around (root)
  (awhen (call-next-method)
    (mapcar (compost #'expansion-branch #'name-keyword) it)))

(defclass power-expansion ()
  ((root :initarg :root :accessor expansion-root :col-type string)
   (branch :initarg :branch :accessor expansion-branch :col-type string))
  (:metaclass dao-class)
  (:keys root branch))

(defmethod power-expansions (root)
  (select-dao 'power-expansion
              (:= 'root (keyword-name root))))

(defmethod power-expand? (root branch)
  (select-dao 'power-expansion
              (:and (:= 'root (keyword-name root))
                    (:= 'branch (keyword-name branch)))))

(defun power-expansion-dao (root branch)
  (make-instance 'power-expansion
                 :root (keyword-name root)
                 :branch (keyword-name branch)))

(defmethod create-power-expansion (root branch)
  (save-dao (power-expansion-dao root branch)))

(defmethod delete-power-expansion (root branch)
  (delete-dao (power-expansion-dao root branch)))
