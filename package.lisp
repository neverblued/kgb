;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(defpackage #:kgb
  (:use #:cl #:iterate #:alexandria
        #:blackjack)
  (:export
                                        ; condition
   #:achtung
   #:authentication-impossible
   #:alias-duplication
   #:authentication-missing
   #:login-failure
   #:unknown-login-alias
   #:wrong-login-password
   #:access-denied
                                        ; model
   #:subject #:subject=
   #:person #:default-name
   #:community
   #:depute #:depute=
   #:begin-depute #:end-depute #:check-depute
                                        ; seal
   #:seal-secret #:make-seal #:check-seal #:reset-seal
                                        ; algebra
   #:communities
   #:alias-person #:seal-person #:alias-community
   #:person? #:user? #:guest?
   #:direct-depute #:indirect-depute
   #:direct-communities
                                        ; right
   ;#:right #:rights #:direct-rights #:all-rights #:allow?
   ;#:create-right #:delete-right
                                        ; power
   ;#:power #:powers #:create-power #:delete-power #:power?
                                        ; spread
   ;#:spread #:spreads #:create-spread #:delete-spread
                                        ; authenticate
   #:status?
   #:user #:user?
   #:login #:check-user
   #:authenticate #:authentication-possible? #:with-authentication
   #:request-user
   #:introduce-guest #:make-guest #:guest?
   #:guest-class #:guest-alias #:guest-password
   #:alias+password #:request-credentials
   #:with-security
                                        ; query

                                        ; log
   #:log-authentication))