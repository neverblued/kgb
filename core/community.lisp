;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:kgb)

(defgeneric depute? (subject community))

(defun status? (subject)
  "If current USER is deputed from SUBJECT."
  (check-user)
  (depute? user subject))

(defgeneric depute-directly? (subject community))
(defgeneric depute-indirectly? (subject community))

(defmethod depute? (subject community)
  (or (depute-directly? subject community)
      (depute-indirectly? subject community)))

(defmethod depute-directly? (subject (community (eql :user)))
  (user? subject))

;; direct communities

(defgeneric direct-communities (subject))

(defmethod depute-directly? (subject community)
  (true? (find community (direct-communities subject))))

(defmethod depute-indirectly? (subject community)
  (iter (for subject in (direct-communities subject))
        (when (depute? subject community)
          (leave t))))

(defun enrol (subject community)
  (pushnew community (direct-communities subject)))

(defun disown (subject community)
  (delete community (direct-communities subject)))

(defgeneric create-depute (subject community))
(defgeneric delete-depute (subject community))

(defun (setf direct-communities) (new-communities subject)
  (let* ((communities (direct-communities subject))
         (fresh (set-difference new-communities communities))
         (obsolete (set-difference communities new-communities)))
    (iter (for community in obsolete)
          (delete-depute subject community))
    (iter (for community in fresh)
          (create-depute subject community))))

;; general communities

(defun communities (subject)
  (labels ((rec-communities (subject)
             (awhen (direct-communities subject)
               (reduce #'union (adjoin it (mapcar #'rec-communities it))))))
    (adjoin subject
            (awith (rec-communities subject)
              (if (user? subject)
                  (union it (list :user))
                  it)))))
