;; compline-theme.el --- Be at peace with the darkness -*- lexical-binding: t; no-byte-compile: t; -*-
;;; Commentary:
;;; Code:
(require 'doom-themes)
(defgroup doom-compline-theme nil
  "Options for the `doom-compline' theme."
  :group 'doom-themes)

(defcustom doom-compline-brighter-modeline nil
  "If non-nil, more vivid colors will be used to style the mode-line."
  :group 'doom-compline-theme
  :type 'boolean)

(defcustom doom-compline-brighter-comments nil
  "If non-nil, comments will be highlighted in more vivid colors."
  :group 'doom-compline-theme
  :type 'boolean)

(defcustom doom-compline-comment-bg doom-compline-brighter-comments
  "If non-nil, comments will have a subtle, darker background. Enhancing their
legibility."
  :group 'doom-compline-theme
  :type 'boolean)

(defcustom doom-compline-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line. Can be an integer to
determine the exact padding."
  :group 'doom-compline-theme
  :type '(choice integer boolean))

(def-doom-theme compline
    "The compline colorscheme"

  ((bg         '("#1a1d21" nil       nil            ))
   (bg-alt     '("#22262b" nil       nil            ))
   (base0      '("#0f1114" "black"   "black"        ))
   (base1      '("#171a1e" "#1e1e1e" "brightblack"  ))
   (base2      '("#1f2228" "#2e2e2e" "brightblack"  ))
   (base3      '("#282c34" "#2F3237" "brightblack"  ))
   (base4      '("#3d424a" "#4f5b66" "brightblack"  ))
   (base5      '("#515761" "#65737E" "brightblack"  ))
   (base6      '("#676d77" "#6b6b6b" "brightblack"  ))
   (base7      '("#8b919a" "#979797" "brightblack"  ))
   (base8      '("#e0dcd4" "#dfdfdf" "white"        ))
   (fg         '("#f0efeb" "#c0c5ce" "brightwhite"  ))
   (fg-alt     '("#ccc4b4" "#a0a0a0" "white"        ))

   (grey       base4)
   (red        '("#CDACAC" "#D69A9F" "red"          ))
   (orange     '("#ccc4b4" "#D08770" "brightred"    ))
   (green      '("#b8c4b8" "#A3BE8C" "green"        ))
   (blue       '("#b4bcc4" "#8FA1B3" "brightblue"   ))
   (yellow     '("#d4ccb4" "#ECBE7B" "yellow"       ))
   (violet     base7)
   (teal       '("#b4c4bc" "#44b9b1" "brightgreen"  ))
   (dark-blue  '("#9ca4ac" "#2257A0" "blue"         ))
   (magenta    base7)
   (cyan       '("#b4c0c8" "#46D9FF" "brightcyan"   ))
   (dark-cyan  '("#98a4ac" "#5699AF" "cyan"         ))

   (highlight      yellow)
   (vertical-bar   (doom-darken bg 0.25))
   (selection      base4)
   (builtin        cyan)
   (comments       base4)
   (doc-comments   base4)
   (constants      base7)
   (functions      cyan)
   (keywords       base8)
   (methods        dark-cyan)
   (operators      base6)
   (type           blue)
   (strings        green)
   (variables      base8)
   (numbers        red)
   (region         selection)
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    orange)
   (vc-added       green)
   (vc-deleted     red)

   (hidden     `(,(car bg-alt) "black" "black"))
   (-modeline-bright doom-compline-brighter-modeline)
   (-modeline-pad
    (when doom-compline-padded-modeline
      (if (integerp doom-compline-padded-modeline) doom-compline-padded-modeline 4)))

   (modeline-fg     'unspecified)
   (modeline-fg-alt (doom-blend violet base4 (if -modeline-bright 0.5 0.2)))
   (modeline-bg
    (if -modeline-bright
        (doom-darken base3 0.1)
      base1))
   (modeline-bg-l
    (if -modeline-bright
        (doom-darken base3 0.05)
      base1))
   (modeline-bg-inactive   `(,(doom-darken (car bg-alt) 0.05) ,@(cdr base1)))
   (modeline-bg-inactive-l (doom-darken bg 0.1)))

  (((font-lock-comment-face &override)
    :background (if doom-compline-comment-bg (doom-lighten bg 0.05)))
   ((line-number &override) :foreground base4)
   ((line-number-current-line &override) :foreground fg)
   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))
   (mode-line-emphasis :foreground (if -modeline-bright base8 highlight))

   (css-proprietary-property :foreground orange)
   (css-property             :foreground fg)
   (css-selector             :foreground red)

   (doom-modeline-bar :background (if -modeline-bright modeline-bg highlight))
   (elscreen-tab-other-screen-face :background "#353a42" :foreground "#1e2022")

   (markdown-markup-face :foreground base5)
   (markdown-header-face :inherit 'bold :foreground red)
   ((markdown-code-face &override) :background (doom-darken bg 0.1))

   ((outline-1 &override) :foreground fg :weight 'ultra-bold)
   ((outline-2 &override) :foreground (doom-blend fg blue 0.35))
   ((outline-3 &override) :foreground (doom-blend fg blue 0.7))
   ((outline-4 &override) :foreground blue)
   ((outline-5 &override) :foreground (doom-blend magenta blue 0.2))
   ((outline-6 &override) :foreground (doom-blend magenta blue 0.4))
   ((outline-7 &override) :foreground (doom-blend magenta blue 0.6))
   ((outline-8 &override) :foreground fg)

   (org-block            :background (doom-darken bg-alt 0.04))
   (org-block-begin-line :foreground base4 :slant 'italic :background (doom-darken bg 0.04))
   (org-ellipsis         :underline nil :background bg    :foreground red)
   ((org-quote &override) :background base1)
   (org-hide :foreground bg)

   (solaire-mode-line-face
    :inherit 'mode-line
    :background modeline-bg-l
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-l)))
   (solaire-mode-line-inactive-face
    :inherit 'mode-line-inactive
    :background modeline-bg-inactive-l
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive-l))))

  )

;;; compline-theme.el ends here
