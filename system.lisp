(in-package #:kgb)

(defgeneric users (system))
(defgeneric logbook (system))

(defvar system nil)
(defvar user)

(defclass system ()
  ((users :accessor users :initform nil)
   (logbook :accessor logbook :initform nil)
   (direct-groups-table :accessor direct-groups-table :initform (make-hash-table))
   (direct-rights-table :accessor direct-rights-table :initform (make-hash-table))))
