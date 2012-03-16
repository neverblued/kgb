;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(defpackage #:kgb-system
  (:use #:common-lisp #:asdf))

(in-package #:kgb-system)

(defsystem #:kgb
  :description "Security framework"
  :version "0.4"
  :author "Дмитрий Пинский <demetrius@neverblued.info>"
  :depends-on (#:ironclad #:simple-date #:blackjack)
  :serial t
  :components ((:file "package")
               (:file "conditions")
               (:file "person")
               (:file "authenticate")
               (:file "community")
               (:file "right")
               (:file "expand")))
