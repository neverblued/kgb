;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(defpackage #:kgb
  (:use #:cl #:simple-date #:iterate #:alexandria #:postmodern
        #:blackjack #:postgrace)
  (:export
                                        ; conditions
   #:achtung #:authentication-impossible
                                        ; person
   #:person #:create-person #:delete-person #:default-name
   #:id-person #:alias-person #:seal-person #:count-person
   #:user?
                                        ; authenticate
   #:user #:login #:authenticate #:with-authentication
   #:authentication-possible?
   #:introduce-guest
                                        ; community
   #:communities #:enroll #:disown
                                        ; depute
   #:depute?

   ))
