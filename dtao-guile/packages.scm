(define-module (dtao-guile packages)
               #:use-module (guix gexp)
               #:use-module (guix utils)
               #:use-module (guix packages)
               #:use-module (guix git-download)
               ;; TODO: Remove this dependency for wlroots-0.13.0?
               #:use-module (dwl-guile packages)
               #:use-module (gnu packages wm)
               #:use-module (gnu packages guile)
               #:use-module (gnu packages build-tools))

(define-public
  dtao-guile
  (package
    (name "dtao-guile")
    (version "0.1")
    (home-page "https://github.com/engstrand-config/dtao-guile")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/engstrand-config/dtao-guile.git")
               (commit "f54eed89ebe8f4d31b57fc8aa002ec590cdcd617")))
        (sha256
          (base32 "0s3r4m54azmqk7srax4i79ds9qjjwvryfaag6jsxhhvn5y4mqjf9"))))
    (build-system gnu-build-system)
    (native-inputs
      `(("pkg-config" ,pkg-config)))
    (inputs
      `(("guile-3.0" ,guile-3.0)
        ("wlroots-0.13.0" ,wlroots-0.13.0)
        ("fcft" ,fcft)
        ("pixman" ,pixman)
        ("groff" ,groff)
        ("ronn" ,ronn-ng)))
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
          ;; Rename exectuable to dtao-guile so that we can
          ;; differentiate between regular dtao and dtao-guile.
          (replace
            'install
            (lambda*
              (#:key inputs outputs #:allow-other-keys)
              (let ((bin (string-append (assoc-ref outputs "out") "/bin")))
                (install-file "dtao" bin)
                (rename-file (string-append bin "/dtao")
                             (string-append bin "/dtao-guile"))
                #t))))))
    (license (list license:gpl3+ license:expat license:cc0))
    (synopsis "dtao - dzen for Wayland")
    (description
      "dtao is a stdin-based general-purpose bar for Wayland,
      modeled after the venerable dzen2"))
