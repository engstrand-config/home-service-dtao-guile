(define-module (dtao-guile utils)
  #:use-module (srfi srfi-1)
  #:use-module (ice-9 match)
  #:use-module (dtao-guile configuration blocks)
  #:export (
            conditional-list
            list-of-blocks?
            list-of-modules?
            maybe-number?
            maybe-string?
            remove-question-mark))

(define (conditional-list lst)
  (filter (lambda (x) (not (unspecified? x))) lst))

(define (list-of-blocks? lst)
  (every dtao-block? lst))

(define (maybe-number? x)
  (or (number? x) (eq? x #f)))

(define (maybe-string? x)
  (or (string? x) (eq? x #f)))

;; Removes the '?' from the end of a string.
;; This is used when transforming a config into an alist.
(define (remove-question-mark str)
  (string-trim-right str #\?))

(define (list-of-modules? lst)
  (every (lambda (modlst)
           (every symbol? modlst))
         lst))
