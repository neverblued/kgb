(defpackage #:kgb-system
  (:use #:common-lisp #:asdf))

(in-package #:kgb-system)

(defsystem "kgb"
  :description "Authentication layer."
  :version "0.2"
  :author "Demetrius Conde <condemetrius@gmail.com>"
  :depends-on (#:blackjack #:ironclad #:hunchentoot #:postgrace #:simple-date #:iterate)
  :serial t
  :components ((:file "package")
               (:file "conditions")
               (:file "subject")
               (:file "person")
               (:file "authenticate")
               (:file "database")
               (:file "group")
               (:file "right")))
