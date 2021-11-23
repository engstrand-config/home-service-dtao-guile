(define-module (dtao-guile utils)
               #:use-module (srfi srfi-1)
               #:use-module (ice-9 match)
               #:use-module (dtao-guile blocks)
               #:export (
                         list-of-blocks?
                         bar-position?
                         ))

(define bar-position? pos
  (match pos
         ("top" #t)
         ("bottom" #t)
         (_ #f)))

(define list-of-blocks? lst
  (every dtao-guile-block? lst))
