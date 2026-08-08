;;; init.el --- Comprehensive Modern Emacs Configuration -*- lexical-binding: t; -*-

;; ==========================================
;; 1. Core Engine Performance & GC Tuning
;; ==========================================
;; Increase GC threshold during startup for instant boots
(setq gc-cons-threshold (* 50 1024 1024)
      read-process-output-max (* 3 1024 1024))

;; Restore GC threshold after init
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024))))

;; ==========================================
;; 2. UI Visuals, Fonts & Ergonomics
;; ==========================================
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Ensure frame-creation parameters stay clean
(add-to-list 'default-frame-alist '(scroll-bar-mode . nil))
(add-to-list 'default-frame-alist '(tool-bar-lines . 0))
(add-to-list 'default-frame-alist '(menu-bar-lines . 0))

(setq-default
 tab-width 2
 indent-tabs-mode nil
 word-wrap nil)

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode t)
(global-hl-line-mode t)
(setq scroll-margin 8
      select-enable-clipboard t
      inhibit-startup-screen t
      inhibit-startup-message t)

;; Backup & Auto-Save directories
(setq backup-directory-alist `(("." . ,(concat user-emacs-directory "backups"))))
(setq auto-save-file-name-transforms `((".*" ,(concat user-emacs-directory "auto-save/") t)))

;; Theme: Catppuccin Mocha
(use-package catppuccin-theme
  :ensure t
  :config
  (setq catppuccin-flavor 'mocha)
  (load-theme 'catppuccin t))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 28
        doom-modeline-bar-width 4
        doom-modeline-buffer-file-name-style 'relative-from-project))

(use-package nerd-icons
  :ensure t)

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package rainbow-mode
  :ensure t
  :hook (prog-mode . rainbow-mode))

(use-package highlight-indent-guides
  :ensure t
  :hook (prog-mode . highlight-indent-guides-mode)
  :config
  (setq highlight-indent-guides-method 'character
        highlight-indent-guides-responsive 'top))

;; ==========================================
;; 3. Dashboard Configuration
;; ==========================================
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)

  ;; Custom ASCII banner passing
  (setq dashboard-startup-banner
        '(1 "         . - ~ - ."
            "       /   /\\ /\\   \\"
            "      /   /  V  \\   \\"
            "     |   /   |   \\   |"
            "     |  (   / \\   )  |"
            "      \\  \\ (   ) /  /"
            "       \\  \\_\\_/_/  /"
            "         ` - ~ - '"))

  (setq dashboard-banner-logo-title "G N U   E M A C S"
        dashboard-footer-messages '("Ready to conquer nvf.")
        dashboard-center-content t
        dashboard-show-shortcuts t
        dashboard-set-heading-icons t
        dashboard-set-file-icons t
        dashboard-items '((recents   . 5)
                          (projects  . 5)
                          (bookmarks . 3)))

  (setq dashboard-navigator-buttons
        `((( "󰈔" "Find File" "  [C-x C-f]" (lambda (&rest _) (call-interactively 'find-file)))
           ( "󰋜" "Dotfiles"  "  [C-c e]  " (lambda (&rest _) (dired "~/.dotfiles")))
           ( "󰊢" "Magit"     "  [C-c g]  " (lambda (&rest _) (magit-status)))
           ( "󰈔" "Open Init" "  [C-c i]  " (lambda (&rest _) (find-file "~/.config/emacs/init.el")))))))

;; ==========================================
;; 4. Completion, Fuzzy Finding & Motion
;; ==========================================
;; Vertical completion interface (Telescope / Snacks.nvim equivalent)
(use-package vertico
  :ensure t
  :init (vertico-mode 1))

;; Rich annotations in completion buffer (file dates, permissions, descriptions)
(use-package marginalia
  :ensure t
  :init (marginalia-mode 1))

;; Fuzzy matching algorithm
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

;; In-buffer auto-completion popup (blink-cmp / nvim-cmp equivalent)
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 1)
  (corfu-cycle t)
  :init
  (global-corfu-mode))

;; Fast jump motions (flash.nvim / leap.nvim equivalent)
(use-package avy
  :ensure t
  :bind ("M-s" . avy-goto-char-timer))

;; Keybinding hints popup (which-key)
(use-package which-key
  :ensure t
  :config (which-key-mode 1))

;; ==========================================
;; 5. LSP, Treesitter & Code Formatting
;; ==========================================
;; Built-in lightweight LSP client
(use-package eglot
  :hook
  ((python-ts-mode
    rust-ts-mode
    js-ts-mode
    typescript-ts-mode
    nix-mode
    elixir-ts-mode
    c-ts-mode
    go-ts-mode) . eglot-ensure)
  :config
  (setq eglot-autoshutdown t
        eglot-events-buffer-size 0))

;; Universal asynchronous code formatter (Prettier, Alejandra, Black, etc.)
(use-package apheleia
  :ensure t
  :config
  (setf (alist-get 'nix-mode apheleia-mode-alist) 'alejandra)
  (setf (alist-get 'python-ts-mode apheleia-mode-alist) 'black)
  (apheleia-global-mode +1))

;; Modern inline LSP diagnostics/flymake visual tweaks
(use-package flymake
  :hook (prog-mode . flymake-mode))

;; Language modes
(use-package nix-mode :ensure t)
(use-package markdown-mode :ensure t)
(use-package typst-ts-mode :ensure t)
(use-package elixir-mode :ensure t)
(use-package rust-mode :ensure t)
(use-package zig-mode :ensure t)

;; Fill Column Indicators
(add-hook 'nix-mode-hook (lambda () (setq display-fill-column-indicator-column 110) (display-fill-column-indicator-mode 1)))
(add-hook 'python-ts-mode-hook (lambda () (setq display-fill-column-indicator-column 88) (display-fill-column-indicator-mode 1)))
(add-hook 'typescript-ts-mode-hook (lambda () (setq display-fill-column-indicator-column 100) (display-fill-column-indicator-mode 1)))

;; ==========================================
;; 6. Navigation, Git & Utility Bloat
;; ==========================================
;; The undisputed king of Git interfaces (far superior to Lazygit)
(use-package magit
  :ensure t)

;; In-buffer Git diff indicators (gitsigns.nvim equivalent)
(use-package diff-hl
  :ensure t
  :init
  (global-diff-hl-mode)
  :hook (magit-post-refresh . diff-hl-magit-post-refresh))

;; Highlighting todo comments
(use-package hl-todo
  :ensure t
  :init (global-hl-todo-mode))

;; Editable search-and-replace across entire project
(use-package wgrep
  :ensure t)

;; Project management
(use-package project
  :bind ("C-c p f" . project-find-file))

;; Native terminal toggle inside Emacs (toggleterm equivalent)
(use-package vterm
  :ensure t
  :bind ("C-c t" . vterm-toggle)
  :config
  (setq vterm-max-scrollback 10000))

;; Window Navigation via Shift + Arrow keys
(use-package windmove
  :config
  (windmove-default-keybindings 'shift))

;; Basic Global Shortcuts
(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-c g") 'magit-status)
(global-set-key (kbd "C-c e") 'dired-jump)

;; ==========================================
;; 7. Client/Daemon Frame Creation Fixes
;; ==========================================
(setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))

(add-hook 'server-after-make-frame-hook
          (lambda ()
            (switch-to-buffer "*dashboard*")
            (dashboard-refresh-buffer)))
