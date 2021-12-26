(define-module (dtao-guile configuration blocks)
               #:use-module (gnu services configuration)
               #:export (
                         dtao-block
                         dtao-block?
                         <dtao-block>
                         dtao-block-render))

;; Number of arguments required by the block renderer procedure.
(define %block-renderer-arguments 2)

(define (block-renderer? proc)
  (or (eq? proc #f)
      (and (procedure? proc)
           (eq? (car (procedure-minimum-arity proc))
                %block-renderer-arguments))))

(define-configuration
  dtao-block
  (render
    (block-renderer #f)
    "Block rendering procedure.")
  (no-serialization))
