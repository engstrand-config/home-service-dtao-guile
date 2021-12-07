(define-module (dtao-guile home-service)
               #:use-module (guix gexp)
               #:use-module (guix packages)
               #:use-module (srfi srfi-1)
               #:use-module (gnu packages admin)
               #:use-module (gnu home services)
               #:use-module (gnu home services shepherd)
               #:use-module (gnu services configuration)
               #:use-module (dtao-guile utils)
               #:use-module (dtao-guile packages)
               #:use-module (dwl-guile utils)
               #:use-module (dwl-guile home-service)
               #:use-module (dwl-guile configuration)
               #:export (
                         home-dtao-guile-service-type
                         home-dtao-guile-configuration
                         home-dtao-guile-configuration?
                         <home-dtao-guile-configuration>
                         ))

(define-configuration
  home-dtao-guile-configuration
  (package
    (package dtao-guile)
    "The dtao package to use.")
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
    (bar-position "top")
    "The position of the statusbar. Available options are 'top' and 'bottom'.")
  (height
    (maybe-number #f)
    "The height of the bar. Set to #f for automatic height.")
  (font
    (string "JetBrains Mono:style=bold:size=12")
    "The font to use in the statusbar, e.g. 'JetBrains Mono:style=bold:size=12'")
  (no-serialization))

(define (home-dtao-guile-profile-service config)
  (list (home-dtao-guile-configuration-package config)))

;; TODO: Replace this with a configuration file
;; TODO: Add option for aligning title and subwindow
(define (make-bar-constructor user-blocks? config)
  (let ((log-file-base-path (or (getenv "XDG_LOG_HOME")
                                (getenv "HOME"))))
    #~(make-forkexec-constructor
        (list
          #$(file-append (home-dtao-guile-configuration-package config) "/bin/dtao-guile"))
          ; "-bg" #$(home-dtao-guile-configuration-background-color config)
          ; "-fg" #$(home-dtao-guile-configuration-foreground-color config)
          ; "-fn" #$(home-dtao-guile-configuration-font config)
          ; ;; User blocks should be rendered on top of the statusbar with compositor blocks
          ; #$@(if user-blocks?
          ;        (list "-o")
          ;        '())
          ; #$@(if (eq? (home-dtao-guile-configuration-position config) "bottom")
          ;        (list "-b")
          ;        '())
          ; #$@(let ((height (home-dtao-guile-configuration-height config)))
          ;      (if height
          ;          (list (string-append "-h" (number->string height)))
          ;          '())))
        #:log-file #$(string-append log-file-base-path
                                    (if user-blocks?
                                        "/dtao-guile-user.log"
                                        "/dtao-guile-compositor.log")))))

(define (home-dtao-guile-shepherd-service config)
  "Return a list of <shepherd-service> required by dtao-guile."
    (list
      (shepherd-service
        (documentation "Run dtao-guile user blocks.")
        (requirement '(dwl-guile))
        (provision '(dtao-guile-user))
        (auto-start? #f)
        (start (make-bar-constructor #t config))
        (stop #~(make-kill-destructor)))
      (shepherd-service
        (documentation "Run dtao-guile compositor blocks.")
        (requirement '(dwl-guile))
        (provision '(dtao-guile-compositor))
        (auto-start? #f)
        (start (make-bar-constructor #f config))
        (stop #~(make-kill-destructor)))))

(define (home-dtao-guile-dwl-guile-service config)
  (modify-dwl-guile
    (config =>
            (home-dwl-guile-configuration
              (inherit config)
              (startup-commands
                (append
                  (list
                    #~(system* #$(file-append shepherd "/bin/herd")
                               "start"
                               "dtao-guile-compositor")
                    #~(system* #$(file-append shepherd "/bin/herd")
                               "start"
                               "dtao-guile-user"))
                  (home-dwl-guile-configuration-startup-commands config)))))))

(define home-dtao-guile-service-type
  (service-type
    (name 'home-dtao-guile)
    (extensions
      (list
        (service-extension
          home-profile-service-type
          home-dtao-guile-profile-service)
        (service-extension
          home-shepherd-service-type
          home-dtao-guile-shepherd-service)
        (service-extension
          home-dwl-guile-service-type
          home-dtao-guile-dwl-guile-service)))
    ; Each extension will override the previous config
    ; with its own, generally by inheriting the old config
    ; and then adding their own updated values.
    ;
    ; Composing the extensions is done by creating a new procedure
    ; that accepts the service configuration and then recursively
    ; call each extension procedure with the result of the previous extension.
    ; (compose (lambda (extensions)
    ;            (match extensions
    ;                   (() identity)
    ;                   ((procs ...)
    ;                    (lambda (old-config)
    ;                      (fold-right (lambda (p extended-config) (p extended-config))
    ;                                  old-config
    ;                                  extensions))))))
    ; (extend home-dtao-guile-extension)
    (default-value (home-dtao-guile-configuration))
    (description "Configure and install dtao statusbar for dwl-guile.")))
