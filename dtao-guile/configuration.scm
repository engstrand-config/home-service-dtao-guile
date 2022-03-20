(define-module (dtao-guile configuration)
	       #:use-module (gnu services configuration)
	       #:use-module (dtao-guile utils)
	       #:use-module (dtao-guile configuration blocks)
	       #:export (
			 dtao-config
			 <dtao-config>
			 dtao-config?
			 dtao-config-blocks
			 dtao-config-left-blocks
			 dtao-config-center-blocks
			 dtao-config-right-blocks
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
			 dtao-config-layer))

(define-configuration
  dtao-config
  (blocks
   (list-of-blocks '())
   "A list of blocks that should be rendered in the statusbar.
Will be automatically placed in the correct left, right, or center block list
based on the 'position' field. Primarily used by service extensions.")
  (left-blocks
   (list-of-blocks '())
   "A list of blocks that should be rendered in the left side of the statusbar.")
  (center-blocks
   (list-of-blocks '())
   "A list of blocks that should be rendered in the center of the statusbar.")
  (right-blocks
   (list-of-blocks '())
   "A list of blocks that should be rendered in the right side of the statusbar.")
  (modules
   (list-of-modules '())
   "A list of Guile module dependencies needed to run the blocks. Available to all blocks.")
  (height
   (maybe-number #f)
   "The height of the bar. Set to #f for automatic height.")
  (font
   (string "monospace:style=bold:size=12")
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
  (padding-top
   (number 2)
   "Padding on the top of the bar. Blocks may be drawn in this area")
  (padding-bottom
   (number 2)
   "Padding on the bottom of the bar. Blocks may be drawn in this area.")
  (padding-left
   (number 8)
   "Padding on the left side of the bar. Nothing will be drawn in this area.")
  (padding-right
   (number 8)
   "Padding on the right side of the bar. Nothing will be drawn in this area.")
  ;; TODO: Does this option even work anymore?
  (adjust-width?
   (boolean #f)
   "Adjusts the total width of the bar to the width of its contents.")
  (delimiter
   (maybe-string #f)
   "Single character delimiter between each block, both in title and sub-window.")
  (block-spacing
   (maybe-number #f)
   "Additional spacing on each side of the delimiter between each block (in pixels).")
  (layer
   (symbol 'LAYER-BOTTOM)
   "Layer to render the bar in. Available values are: @code{LAYER-TOP},
@code{LAYER-BOTTOM}, @code{LAYER-OVERLAY}, and @code{LAYER-BACKGROUND}.")
  (no-serialization))
