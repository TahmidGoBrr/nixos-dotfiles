;;; init.el --- Pure Native GNU Emacs Config -*- lexical-binding: t; -*-

;; ==========================================
;; 1. Core Options & UI Defaults
;; ==========================================
(setq-default
 tab-width 2
 indent-tabs-mode nil            ; expandtab = true
 word-wrap nil)                  ; wrap = false

(setq display-line-numbers-type 'relative) ; lineNumberMode = "relNumber"
(global-display-line-numbers-mode t)
(global-hl-line-mode t)                    ; cursorline = true
(setq scroll-margin 8)                     ; scrolloff = 8
(setq select-enable-clipboard t)           ; clipboard.registers = "unnamedplus"

;; Backup & Auto-Save directories
(setq backup-directory-alist `(("." . ,(concat user-emacs-directory "backups"))))
(setq auto-save-file-name-transforms `((".*" ,(concat user-emacs-directory "auto-save/") t)))

;; Theme: Catppuccin Mocha
(use-package catppuccin-theme
  :ensure t
  :config
  (setq catppuccin-flavor 'mocha)
  (load-theme 'catppuccin t))

;; UI Visuals
(use-package doom-modeline      ; Lualine equivalent
  :ensure t
  :init (doom-modeline-mode 1))

(use-package nerd-icons         ; nvim-web-devicons
  :ensure t)

(use-package rainbow-delimiters ; rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package rainbow-mode       ; colorizer.enable
  :ensure t
  :hook (prog-mode . rainbow-mode))

(use-package highlight-indent-guides ; indent-blankline
  :ensure t
  :hook (prog-mode . highlight-indent-guides-mode)
  :config (setq highlight-indent-guides-method 'character))

;; ==========================================
;; 2. Native Keybindings & Helper Tools
;; ==========================================
;; Shows available keybindings as you type chords (e.g. C-x ...)
(use-package which-key
  :ensure t
  :config (which-key-mode 1))

;; Window Navigation using Shift + Arrow keys (Native Emacs way)
(use-package windmove
  :config
  (windmove-default-keybindings 'shift)) ; S-left, S-right, S-up, S-down

;; Keybinding shortcuts without Evil
(global-set-key (kbd "C-s") 'save-buffer)              ; Save
(global-set-key (kbd "C-x C-b") 'ibuffer)              ; Better buffer list
(global-set-key (kbd "C-c g") 'magit-status)           ; Magit (Git)
(global-set-key (kbd "C-c e") 'dired-jump)             ; Jump to Dired (File Tree)

;; ==========================================
;; 3. Completion & Fuzzy Finding
;; ==========================================
(use-package vertico            ; Telescope equivalent for Emacs
  :ensure t
  :init (vertico-mode 1))

(use-package orderless          ; Fuzzy search matching engine
  :ensure t
  :custom (completion-styles '(orderless basic)))

(use-package corfu              ; Auto-completion popup (blink-cmp equivalent)
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  :init
  (global-corfu-mode))

(use-package avy                ; Fast cursor jumps (flash-nvim / motion)
  :ensure t
  :bind ("M-s" . avy-goto-char-timer))

;; ==========================================
;; 4. LSP, Treesitter & Formatters
;; ==========================================
(use-package eglot              ; Built-in Emacs LSP Client
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
  (add-hook 'before-save-hook
            (lambda ()
              (when (bound-and-true-p eglot--managed-mode)
                (eglot-format-buffer)))))

(use-package apheleia           ; Prettier, Black, Alejandra formatters
  :ensure t
  :config
  (setf (alist-get 'nix-mode apheleia-mode-alist) 'alejandra)
  (setf (alist-get 'python-ts-mode apheleia-mode-alist) 'black)
  (apheleia-global-mode +1))

;; smartcolumn equivalents (Fill Column Indicators)
(add-hook 'nix-mode-hook (lambda () (setq display-fill-column-indicator-column 110) (display-fill-column-indicator-mode 1)))
(add-hook 'python-ts-mode-hook (lambda () (setq display-fill-column-indicator-column 88) (display-fill-column-indicator-mode 1)))
(add-hook 'typescript-ts-mode-hook (lambda () (setq display-fill-column-indicator-column 100) (display-fill-column-indicator-mode 1)))

;; Language Modes
(use-package nix-mode :ensure t)
(use-package markdown-mode :ensure t)
(use-package typst-ts-mode :ensure t :recipe (:type git :repo "meowking/typst-ts-mode"))
(use-package elixir-mode :ensure t)
(use-package rust-mode :ensure t)
(use-package zig-mode :ensure t)

;; ==========================================
;; 5. Git & Search Tools
;; ==========================================
(use-package magit              ; Pure Emacs Git UI (Superior to Lazygit)
  :ensure t)

(use-package diff-hl            ; Gitsigns gutter indicators
  :ensure t
  :init (global-diff-hl-mode))

(use-package hl-todo            ; todo-comments.nvim
  :ensure t
  :init (global-hl-todo-mode))

(use-package wgrep              ; Search and replace across projects
  :ensure t)
