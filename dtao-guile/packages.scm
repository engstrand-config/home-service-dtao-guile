(define-module (dtao-guile packages)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages groff)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages build-tools))

(define-public dtao-guile
  (package
   (name "dtao-guile")
   (version "0.1")
   (home-page "https://github.com/engstrand-config/dtao-guile")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/engstrand-config/dtao-guile.git")
           (commit "ccd0e9dac2c5255611c09c1670be9467496925f7")))
     (sha256
      (base32 "1qrq2cf8zvaxyzgcwymgc7wi0mjms55j1jg9zqhxdph0x61afj8p"))))
   (build-system gnu-build-system)
   (native-inputs (list pkg-config))
   (inputs (list guile-3.0
                 wlroots
                 fcft
                 pixman
                 groff
                 ronn-ng))
   (arguments
    `(#:tests? #f
      #:make-flags
      (list
       (string-append "CC=" ,(cc-for-target))
       (string-append "PREFIX=" (assoc-ref %outputs "out")))
      #:phases
      (modify-phases
       %standard-phases
       (delete 'configure)
       (replace 'install
                (lambda* (#:key inputs outputs #:allow-other-keys)
                  (let ((bin (string-append (assoc-ref outputs "out") "/bin")))
                    (install-file "dtao" bin)
                    (rename-file (string-append bin "/dtao")
                                 (string-append bin "/dtao-guile"))
                    #t))))))
   (license (list license:gpl3+ license:expat license:cc0))
   (synopsis "General-purpose bar for Wayland configurable in GNU Guile")
   (description
    "dtao-guile is a GNU Guile based general-purpose bar for Wayland,
    modeled after the venerable dzen2.")))
