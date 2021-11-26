(define-module (dtao-guile blocks)
               #:use-module (gnu services configuration)
               #:export (
                         dtao-guile-block
                         dtao-guile-block?
                         <dtao-guile-block>
                         dtao-guile-block-render
                         ))

;; Number of arguments required by the block renderer procedure.
(define %block-renderer-arguments 2)

(define (block-renderer? proc)
  (or (eq? x #f)
      (and (procedure? proc)
           (eq? (car (procedure-minimum-arity proc))
                %block-renderer-arguments))))

(define-configuration
  dtao-guile-block
  (render
    (block-renderer #f)
    "Block rendering procedure.")
  (no-serialization))
