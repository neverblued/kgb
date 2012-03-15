;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:kgb)

(defun id-person (id)
  (get-dao 'person id))

(defun alias-person (alias)
  (car (query-dao 'person (:select '* :from 'person :where (:= 'alias alias)))))

(defun seal-person (seal)
  (car (query-dao 'person (:select '* :from 'person :where (:= 'seal seal)))))

(defun count-person ()
  (query (:select (:count 'id) :from 'person) :single))

(defun create-person (&rest args)
  (apply #'make-dao 'person args))

(defun delete-person (person)
  (delete-dao person))

(defun next-person-id ()
  (+ 1 (max-id 'person)))

(defmethod insert-dao :before ((person person))
  (setf (id person)
        (next-person-id)))
