(define-module (dtao-guile packages)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module ((guix licenses) #:prefix license:)
  ;; TODO: Remove this dependency for wlroots-0.13.0?
  #:use-module (dwl-guile packages)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages groff)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages pkg-config)
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
           (commit "72c22ea83192086c15b5c3ea1e6bd6c212723fef")))
     (sha256
      (base32 "1p8n4v3f91sg9hnr3yrapmr3hyzmyhcsclg6nnyzwj1za0jrplkk"))))
   (build-system gnu-build-system)
   (native-inputs
    `(("pkg-config" ,pkg-config)))
   (inputs
    `(("guile-3.0" ,guile-3.0)
      ("wlroots-0.14.0" ,wlroots-0.14.0)
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
      modeled after the venerable dzen2")))
