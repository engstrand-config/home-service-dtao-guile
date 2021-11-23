(define-module (dtao-guile home-service)
               #:use-module (guix gexp)
               #:use-module (srfi srfi-1)
               #:use-module (gnu home services)
               #:use-module (gnu home services shepherd)
               #:use-module (gnu services configuration)
               #:use-module (dtao-guile packages)
               #:export (
                         home-dtao-guile-service-type
                         home-dtao-guile-configuration
                         home-dtao-guile-configuration?
                         <home-dtao-guile-configuration>
                         ))

(define-configuration
  home-dtao-guile-configuration
  (package dtao-guile)
  (blocks
    (list-of-blocks '())
    "A list of blocks that should be rendered in the statusbar.")
  (background-color
    (string "111111AA")
    "Background color of the bar in RRGGBBAA format.")
  (foreground-color
    (string "FFFFFF")
    "Foreground color of the bar in RRGGBBAA format.")
  (position
    (bar-position "top")))
