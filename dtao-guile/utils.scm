(define-module (dtao-guile utils)
               #:use-module (srfi srfi-1)
               #:use-module (ice-9 match)
               #:use-module (dtao-guile blocks)
               #:export (
                         conditional-list
                         list-of-blocks?
                         bar-position?
                         maybe-number?
                         ))

(define (conditional-list lst)
  (filter (lambda (x) (not (unspecified? x))) lst))

(define (bar-position? pos)
  (match pos
         ("top" #t)
         ("bottom" #t)
         (_ #f)))

(define (list-of-blocks? lst)
  (every dtao-guile-block? lst))

(define (maybe-number? x)
  (or (number? x) (eq? x #f)))
