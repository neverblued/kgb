;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:kgb)

(defmethod title ((this right))
  (join "право на " (alias this)))

(defmethod print-object ((this right) stream)
  (format stream "[ ~a ]" (title this)))

;(symbol-macrolet ((rights (domain-rights secure-domain)))
;  (define-factory (right) rights)
;  (define-fetch-keys (alias) rights)
;  (define-singular right rights))

;(symbol-macrolet ((powers (domain-powers secure-domain)))
;  (define-factory (power) powers)
;  (define-fetch-keys (power-subject power-right) powers))

;(symbol-macrolet ((spreads (domain-spreads secure-domain)))
;  (define-factory (spread) spreads)
;  (define-fetch-keys (spread-root spread-branch) spreads))

(defun direct-rights (subject)
  (awhen (powers :power-subject subject)
    (mapcar #'power-right it)))

(defun direct-spreads (right)
  (awhen (spreads :spread-root right)
    (mapcar #'spread-branch it)))

(defun right-spread (right)
  (union (list right)
         (awhen (direct-spreads right)
           (append it (awith (mapcar #'right-spread it)
                        (apply #'append it))))
         :test #'equal))

(defun all-rights (subject)
  "All rights of the SUBJECT."
  (awhen (all-communities subject)
    (awhen (reduce #'union (mapcar #'direct-rights it))
      (reduce #'union (mapcar #'right-spread it)))))

(defun allow? (subject right)
  "Is the RIGHT available for the SUBJECT?"
  (true? (intersection (all-rights subject)
                       (right-spread right))))

(defun power? (right)
  "If current USER has RIGHT."
  (check-user)
  (allow? user right))
