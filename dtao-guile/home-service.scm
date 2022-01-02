(define-module (dtao-guile home-service)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-1)
  #:use-module (gnu packages admin)
  #:use-module (gnu home services)
  #:use-module (gnu home services shepherd)
  #:use-module (gnu services configuration)
  #:use-module (dtao-guile utils)
  #:use-module (dtao-guile packages)
  #:use-module (dtao-guile configuration)
  #:use-module (dtao-guile configuration blocks)
  #:use-module (dtao-guile configuration transform)
  #:export (
            home-dtao-guile-service-type
            home-dtao-guile-configuration
            home-dtao-guile-configuration?
            <home-dtao-guile-configuration>
            home-dtao-guile-configuration-package
            home-dtao-guile-configuration-auto-start?
            home-dtao-guile-configuration-config)
  #:re-export (
               dtao-config
               <dtao-config>
               dtao-config?
               dtao-config-left-blocks
               dtao-config-right-blocks
               dtao-config-center-blocks
               dtao-config-modules
               dtao-config-height
               dtao-config-font
               dtao-config-use-dwl-guile-colorscheme?
               dtao-config-background-color
               dtao-config-foreground-color
               dtao-config-border-color
               dtao-config-border-px
               dtao-config-exclusive?
               dtao-config-bottom?
               dtao-config-padding-top
               dtao-config-padding-bottom
               dtao-config-padding-left
               dtao-config-padding-right
               dtao-config-adjust-width?
               dtao-config-layer

               dtao-block
               <dtao-block>
               dtao-block?
               dtao-block-events?
               dtao-block-render
               dtao-block-click
               dtao-block-interval
               dtao-block-signal))

;; Home service configuration for dtao-guile.
(define-configuration
  home-dtao-guile-configuration
  (package
   (package dtao-guile)
   "The dtao package to use.")
  (auto-start?
   (boolean #t)
   "If dtao-guile should auto-start on login.")
  (config
   (dtao-config (dtao-config))
   "Custom dtao-guile configuration. Replaces command line arguments.")
  (no-serialization))

;; Add dtao-guile package to guix home profile.
(define (home-dtao-guile-profile-service config)
  (list (home-dtao-guile-configuration-package config)))

;; Generate configuration file based on config in home.
(define (home-dtao-guile-files-service config)
  (let* ((user-config (home-dtao-guile-configuration-config config))
         (dtao (dtao-config->alist user-config))
         (modules (dtao-config-modules user-config)))
    `(("config/dtao-guile/config.scm"
       ,(with-imported-modules
         modules
         (scheme-file
          "dtao-config.scm"
          ;; Not sure how to conditonally add (use-modules ...)
          (if (> (length modules) 0)
              #~(begin
                  (use-modules #$@modules)
                  (define config `(#$@dtao)))
              #~(define config `(#$@dtao)))))))))

;; Add shepherd serivce for starting dtao-guile.
;; TODO: Remove dependency on dwl-guile?
(define (home-dtao-guile-shepherd-service config)
  "Return a list of <shepherd-service> required by dtao-guile."
  (list
   (shepherd-service
    (documentation "Run dtao-guile.")
    (requirement '(dwl-guile))
    (provision '(dtao-guile))
    (auto-start? (home-dtao-guile-configuration-auto-start? config))
    (respawn? #t)
    (start
     (let ((config-dir (string-append (getenv "HOME") "/.config/dtao-guile")))
       #~(make-forkexec-constructor
          (list
           #$(file-append (home-dtao-guile-configuration-package config) "/bin/dtao-guile")
           "-c" #$(string-append config-dir "/config.scm"))
          #:user (getenv "USER")
          #:log-file #$(string-append (or (getenv "XDG_LOG_HOME") (getenv "HOME"))
                                      "/dtao-guile.log"))))
    (stop #~(make-kill-destructor)))))

(define (home-dtao-guile-extension old-config extend-proc)
  (extend-proc old-config))

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
      home-files-service-type
      home-dtao-guile-files-service)))
   ;; Each extension will override the previous config
   ;; with its own, generally by inheriting the old config
   ;; and then adding their own updated values.
   ;;
   ;; Composing the extensions is done by creating a new procedure
   ;; that accepts the service configuration and then recursively
   ;; call each extension procedure with the result of the previous extension.
   (compose (lambda (extensions)
              (match extensions
                (() identity)
                ((procs ...)
                 (lambda (old-config)
                   (fold-right (lambda (p extended-config) (p extended-config))
                               old-config
                               extensions))))))
   (extend home-dtao-guile-extension)
   (default-value (home-dtao-guile-configuration))
   (description "Configure and install dtao-guile statusbar for dwl-guile.")))
