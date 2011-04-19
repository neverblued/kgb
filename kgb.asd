(defpackage #:kgb-system
  (:use #:common-lisp #:asdf))

(in-package #:kgb-system)

(defsystem "kgb"
  :description "Authentication layer."
  :version "0.2"
  :author "Demetrius Conde <condemetrius@gmail.com>"
  :depends-on (#:blackjack #:ironclad #:hunchentoot)
  :serial t
  :components ((:file "package")
               (:file "conditions")
               (:file "system")
               (:file "user")
               (:file "authenticate")
               (:file "group")
               (:file "right")))
