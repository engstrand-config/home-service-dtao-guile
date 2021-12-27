(define-module (dtao-guile configuration blocks)
  #:use-module (srfi srfi-1)
  #:use-module (gnu services configuration)
  #:use-module (dtao-guile utils)
  #:export (
            dtao-block
            dtao-block?
            <dtao-block>
            dtao-block-render
            dtao-block-click
            dtao-block-modules
            dtao-block-signal
            dtao-block-interval))

;; TODO: Unsure how to verify if it is an expression.
(define (block-renderer? proc)
  (or (eq? proc #f))
      (not (eq? proc #t)))

(define (block-click-callback? value)
  (or (eq? value #f)
      (or (symbol? value)
          (not (eq? value #t)))))

(define (maybe-signal? sig)
  (or (eq? sig #f)
      (and (<= sig SIGRTMAX)
           (>= sig RTMIN))))

(define (list-of-modules? lst)
  (every (lambda (modlst)
           (every symbol? modlst))
         lst))

;; TODO: Document argument type for render and click procedures.
(define-configuration
  dtao-block
  (render
    (block-renderer)
    "Block rendering procedure returning a string.")
  (click
    (block-click-callback #f)
    "Block click callback procedure.")
  (modules
    (list-of-modules '())
    "A list of Guile module dependencies needed to run @code{click} or @code{render}.")
  (signal
    (maybe-signal #f)
    "Signal used to trigger an update of a block. Must be between RTMIN and RTMAX, or #f.")
  (interval
    (number 0)
    "Update interval of the block in seconds. An interval <= 0 will result in the block
never updating automatically. A signal can still be used to trigger an update.")
  (no-serialization))
