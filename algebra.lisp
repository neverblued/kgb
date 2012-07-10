;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:kgb)

; =

(defmethod subject= (x y)
  (compare x y :key #'alias :test #'equal))

(defmethod depute= (x y)
  (and (compare x y :test #'subject= :key #'subject)
       (compare x y :test #'subject= :key #'community)))

; depute

(defgeneric direct-depute (subject community))

(defgeneric indirect-depute (subject community))

(defmethod check-depute (subject community)
  (or (direct-depute subject community)
      (indirect-depute subject community)))

(defgeneric direct-communities (subject))

(defmethod indirect-depute (subject community)
  (iter (for mediator in (direct-communities subject))
        (awhen (check-depute mediator community)
          (leave it))))

; subject

(defgeneric communities (subject))

(defgeneric alias-person (alias))

(defgeneric seal-person (alias))

(defgeneric alias-community (alias))

(defun person? (subject)
  (typep subject 'person))

(defun user? (&optional (subject user))
  (true? (and (person? subject)
              (alias subject))))

(defun guest? (&optional (subject user))
  (true? (and (person? subject)
              (null (alias subject)))))
