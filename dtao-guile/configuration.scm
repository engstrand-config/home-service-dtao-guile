(define-module (dtao-guile configuration)
               #:use-module (gnu services configuration)
               #:use-module (dtao-guile utils)
               #:use-module (dtao-guile configuration blocks)
               #:export (
                         dtao-config
                         <dtao-config>
                         dtao-config?
                         dtao-config-title-blocks
                         dtao-config-sub-blocks
                         dtao-config-height
                         dtao-config-font
                         dtao-config-use-dwl-guile-colorscheme?
                         dtao-config-background-color
                         dtao-config-foreground-color
                         dtao-config-border-color
                         dtao-config-border-px
                         dtao-config-exclusive?
                         dtao-config-bottom?
                         dtao-config-adjust-width?
                         dtao-config-layer
                         dtao-config-title-align
                         dtao-config-sub-align))

(define-configuration
  dtao-config
  (title-blocks
    (list-of-blocks '())
    "A list of blocks that should be rendered in the title window.")
  (sub-blocks
    (list-of-blocks '())
    "A list of blocks that should be rendered in the sub-window.")
  (height
    (maybe-number #f)
    "The height of the bar. Set to #f for automatic height.")
  (font
    (string "JetBrains Mono:style=bold:size=12")
    "The font to use in the statusbar, e.g. 'JetBrains Mono:style=bold:size=12'")
  (use-dwl-guile-colorscheme?
    (boolean #f)
    "Use the same colorscheme as dwl-guile. Uses the root, border, and text color.
It will dynamically receive updated colors via the dscm wayland protocol.")
  (background-color
    (string "111111AA")
    "Background color of the bar in RRGGBBAA format.")
  (border-color
    (string "333333FF")
    "Background color of the bar in RRGGBBAA format.")
  (foreground-color
    (string "FFFFFFFF")
    "Foreground color of the bar in RRGGBBAA format.")
  (border-px
    (maybe-number #f)
    "The bar border width in pixels. Set to #f or 0 to disable borders.")
  (exclusive?
    (boolean #t)
    "If enabled, the bar will request its own exclusive zone.")
  (bottom?
    (boolean #f)
    "Render the bar at the bottom of the screen.")
  (adjust-width?
    (boolean #f)
    "Adjusts the total width of the bar to the width of its contents.")
  (title-align
    (symbol 'ALIGN-LEFT)
    "Title window alignment. Available values are @code{ALIGN-LEFT},
@code{ALIGN-RIGHT}, and @code{ALIGN-CENTER}.")
  (sub-align
    (symbol 'ALIGN-RIGHT)
    "Sub-window alignment. Available values are @code{ALIGN-LEFT},
@code{ALIGN-RIGHT}, and @code{ALIGN-CENTER}.")
  (layer
    (symbol 'LAYER-TOP)
    "Layer to render the bar in. Available values are: @code{LAYER-TOP},
@code{LAYER-BOTTOM}, @code{LAYER-OVERLAY}, and @code{LAYER-BACKGROUND}.")
  (no-serialization))
