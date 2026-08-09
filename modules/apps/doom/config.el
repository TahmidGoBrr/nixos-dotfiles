;;; config.el -*- lexical-binding: t; -*-

;; ==========================================
;; 1. Visuals & Theme
;; ==========================================
(use-package! catppuccin-theme
  :init
  (setq catppuccin-flavor 'mocha)
  (setq doom-theme 'catppuccin)
  :config
  (load-theme 'catppuccin t))

(setq display-line-numbers-type 'relative)
(setq-default tab-width 2)

;; ==========================================
;; 2. Font Configuration (Iosevka Everywhere)
;; ==========================================
(setq doom-font (font-spec :family "Iosevka" :size 14 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "Iosevka" :size 14)
      doom-serif-font (font-spec :family "Iosevka" :size 14)
      doom-big-font (font-spec :family "Iosevka" :size 20))

;; Treemacs Font Overrides
(custom-set-faces!
  '(treemacs-root-face :family "Iosevka" :height 1.3 :weight bold)
  '(treemacs-directory-face :family "Iosevka" :height 1.2)
  '(treemacs-file-face :family "Iosevka" :height 1.2))

;; ==========================================
;; 3. Modifier Keys & Window Manager Compatibility
;; ==========================================
(setq pgtk-alt-as-meta t        ; Map physical Alt to Meta
      x-alt-keysym 'meta
      x-super-keysym nil)       ; Release Super/Mod4 key to Hyprland

;; ==========================================
;; 4. Engine Performance & Scrolling Fixes
;; ==========================================
(setq fast-but-imprecise-scrolling t
      jit-lock-defer-time 0.05
      bidi-paragraph-direction 'left-to-right)
(pixel-scroll-precision-mode 1)

;; ==========================================
;; 5. Formatters
;; ==========================================
(after! apheleia
  (setf (alist-get 'alejandra apheleia-formatters) '("alejandra" "-"))
  (setf (alist-get 'nix-mode apheleia-mode-alist) 'alejandra))

;; ==========================================
;; 6. Keybindings
;; ==========================================
(map!
 ;; File & Core
 "C-s"     #'save-buffer
 "C-c e"   #'+treemacs/toggle
 "<f8>"    #'+treemacs/toggle
 
 ;; Development Tools
 "<f5>"    #'dape
 "C-c g"   #'magit-status
 "C-c t"   #'vterm-toggle
 
 ;; Alt-based Navigation (Avy)
 "M-s"     #'avy-goto-char-timer
 "M-j"     #'avy-goto-line
 
 ;; Alt-based Diagnostics (Flymake/LSP)
 "M-n"     #'flymake-goto-next-error
 "M-p"     #'flymake-goto-prev-error)
