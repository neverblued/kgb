(defpackage #:kgb-system
  (:use
     #:common-lisp
     #:asdf
     )
  )

(in-package #:kgb-system)

(defsystem "kgb"
  :description "Authentication layer."
  :version "0.1"
  :author "Demetrius Conde <condemetrius@gmail.com>"
  :licence "Public Domain"
  :depends-on (#:dc-bin #:ironclad)
  :serial t
  :components ((:file "package")
               (:file "kgb")))
