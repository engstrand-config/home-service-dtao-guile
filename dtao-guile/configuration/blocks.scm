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
            dtao-block-signal
            dtao-block-events?
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

;; TODO: Document argument type for render and click procedures.
(define-configuration
  dtao-block
  (render
   (block-renderer)
   "Block rendering procedure returning a string.")
  (click
   (block-click-callback #f)
   "Block click callback procedure.")
  (signal
   (maybe-signal #f)
   "Signal used to trigger an update of a block. Must be between RTMIN and RTMAX, or #f.")
  (events?
   (boolean #f)
   "Listen for events from dwl-guile, e.g. updated title, tag, layout, etc.
Forces an instant re-render of the block, regardless of the value of @code{(interval)}.")
  (interval
   (number 0)
   "Update interval of the block in seconds. An interval <= 0 will result in the block
never updating automatically. A signal can still be used to trigger an update.")
  (no-serialization))
