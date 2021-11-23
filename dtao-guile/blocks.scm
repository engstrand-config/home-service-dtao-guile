(define-module (dtao-guile blocks)
               #:use-module (gnu services configuration)
               #:export (
                         dtao-guile-block
                         dtao-guile-block?
                         <dtao-guile-block>
                         dtao-guile-block-render
                         ))

(define-configuration
  dtao-guile-block
  (render
    (block-render-func #f)
    "Block rendering function."))
