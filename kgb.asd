;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(defpackage #:kgb-system
  (:use #:common-lisp #:asdf))

(in-package #:kgb-system)

(defsystem #:kgb
  :description "Security framework"
  :version "0.7"
  :author "Дмитрий Пинский <demetrius@neverblued.info>"
  :depends-on (#:blackjack)
  :serial t
  :components ((:file "package")
               ;(:file "tools")
               (:file "condition")
               (:file "model")
               (:file "seal")
               ;(:file "right")
               (:file "authenticate")
               (:file "algebra")
               (:file "format")))
