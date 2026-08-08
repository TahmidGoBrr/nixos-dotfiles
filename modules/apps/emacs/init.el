;;; init.el --- Comprehensive Modern Emacs Config -*- lexical-binding: t; -*-

;; ==========================================
;; 1. Core Performance & Engine Defaults
;; ==========================================
(setq gc-cons-threshold (* 50 1024 1024)
      read-process-output-max (* 3 1024 1024))

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024)
                  gc-cons-percentage 0.1)))

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

;; Native quality of life
(save-place-mode 1)
(winner-mode 1)
(electric-pair-mode 1)
(electric-indent-mode 1)
(recentf-mode 1)

;; ==========================================
;; 2. UI Visuals & Font Settings
;; ==========================================
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(add-to-list 'default-frame-alist '(scroll-bar-mode . nil))
(add-to-list 'default-frame-alist '(tool-bar-lines . 0))
(add-to-list 'default-frame-alist '(menu-bar-lines . 0))

;; Font Configuration (Standard Size)
(set-face-attribute 'default nil :height 120)
(set-face-attribute 'fixed-pitch nil :height 120)

;; Theme: Catppuccin Mocha
(use-package catppuccin-theme
  :config
  (setq catppuccin-flavor 'mocha)
  (load-theme 'catppuccin t))

;; Modeline (Matches the minimal bottom bar in the screenshot)
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 24
        doom-modeline-bar-width 4
        doom-modeline-buffer-file-name-style 'relative-from-project))

(use-package nerd-icons)
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
(use-package rainbow-mode
  :hook (prog-mode . rainbow-mode))
(use-package highlight-indent-guides
  :hook (prog-mode . highlight-indent-guides-mode)
  :config
  (setq highlight-indent-guides-method 'character
        highlight-indent-guides-responsive 'top))

;; Visual Studio Header Breadcrumbs
(use-package breadcrumb
  :init (breadcrumb-mode 1))

;; ==========================================
;; 3. Dashboard (Matched exactly to image_ae2f98.png)
;; ==========================================
(use-package dashboard
  :config
  ;; Use the alternative stylized logo from the GitHub repo showcase
  (setq dashboard-startup-banner 'logo)
  
  ;; Center everything as shown in the screenshot
  (setq dashboard-center-content t)
  
  ;; Exact text from the screenshot
  (setq dashboard-banner-logo-title "Welcome to Emacs!")
  (setq dashboard-set-init-info t)
  
  ;; Only Projects and Recent Files are shown in the screenshot
  (setq dashboard-items '((projects  . 5)
                          (recents   . 5)))
  
  ;; Disable all extra icons and navigator buttons to match the minimal look
  (setq dashboard-set-heading-icons nil)
  (setq dashboard-set-file-icons nil)
  (setq dashboard-navigator-buttons nil)

  ;; Exact footer text with no icon
  (setq dashboard-footer-messages '("Richard Stallman is proud of you"))
  (setq dashboard-footer-icon nil)

  (dashboard-setup-startup-hook))

;; ==========================================
;; 4. Completion, Search & Multi-Cursor
;; ==========================================
(use-package vertico
  :init (vertico-mode 1))

(use-package marginalia
  :init (marginalia-mode 1))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 1)
  (corfu-cycle t)
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode 1))

(use-package savehist
  :init (savehist-mode 1))

(use-package avy
  :bind ("M-s" . avy-goto-char-timer))

(use-package which-key
  :config (which-key-mode 1))

(use-package consult
  :bind (("C-x b" . consult-buffer)
         ("M-y" . consult-yank-pop)
         ("C-f" . consult-line)))

(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))

;; ==========================================
;; 5. LSP, Treesitter & Code Formatting
;; ==========================================
(use-package eglot
  :hook ((python-ts-mode
          rust-ts-mode
          js-ts-mode
          typescript-ts-mode
          nix-mode
          elixir-mode
          c-ts-mode
          go-ts-mode) . eglot-ensure)
  :config
  (setq eglot-autoshutdown t
        eglot-events-buffer-size 0))

(use-package symbols-outline
  :bind ("C-c o" . symbols-outline-show)
  :config
  (symbols-outline-follow-mode 1))

(use-package origami
  :hook (prog-mode . origami-mode)
  :bind ("C-c f" . origami-toggle-node))

(use-package apheleia
  :config
  (setf (alist-get 'nix-mode apheleia-mode-alist) 'alejandra)
  (setf (alist-get 'python-ts-mode apheleia-mode-alist) 'black)
  (setf (alist-get 'js-ts-mode apheleia-mode-alist) 'prettier)
  (setf (alist-get 'typescript-ts-mode apheleia-mode-alist) 'prettier)
  (apheleia-global-mode +1))

(use-package flymake
  :hook (prog-mode . flymake-mode)
  :bind ("C-c n" . flymake-goto-next-error))

;; Language Modes
(use-package nix-mode)
(use-package markdown-mode)
(use-package typst-ts-mode)
(use-package elixir-mode)
(use-package rust-mode)
(use-package zig-mode)

;; Fill Column Indicators
(add-hook 'nix-mode-hook (lambda () (setq display-fill-column-indicator-column 110) (display-fill-column-indicator-mode 1)))
(add-hook 'python-ts-mode-hook (lambda () (setq display-fill-column-indicator-column 88) (display-fill-column-indicator-mode 1)))
(add-hook 'typescript-ts-mode-hook (lambda () (setq display-fill-column-indicator-column 100) (display-fill-column-indicator-mode 1)))

;; ==========================================
;; 6. Visual Studio DAP Debugger Engine
;; ==========================================
(use-package dape
  :bind (("<f5>" . dape)
         ("<f9>" . dape-breakpoint-toggle)
         ("<f10>" . dape-next)
         ("<f11>" . dape-step-in)
         ("S-<f11>" . dape-step-out))
  :config
  (setq dape-buffer-window-arrangement 'right)
  (add-hook 'dape-on-start-hooks 'save-some-buffers))

;; ==========================================
;; 7. File Tree, Terminal & Git Integration
;; ==========================================
(use-package treemacs
  :bind ("<f8>" . treemacs)
  :config
  (setq treemacs-width 30
        treemacs-is-never-other-window t))

(use-package treemacs-nerd-icons
  :config
  (treemacs-load-theme "nerd-icons"))

(use-package magit)

(use-package blamer
  :bind ("C-c b" . blamer-show-commit-info)
  :custom
  (blamer-idle-time 0.5)
  (blamer-min-offset 30)
  :custom-face
  (blamer-face ((t :foreground "#7f849c" :background nil :italic t))))

(use-package diff-hl
  :init (global-diff-hl-mode)
  :hook (magit-post-refresh . diff-hl-magit-post-refresh))

(use-package hl-todo
  :init (global-hl-todo-mode))

(use-package wgrep)
(use-package project
  :bind ("C-c p f" . project-find-file))

(use-package vterm)
(use-package vterm-toggle
  :bind ("C-c t" . vterm-toggle))

(use-package windmove
  :config (windmove-default-keybindings 'shift))

;; ==========================================
;; 8. Core Native Keybindings
;; ==========================================
(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-c g") 'magit-status)
(global-set-key (kbd "C-c e") 'dired-jump)

;; ==========================================
;; 9. Daemon Frame Creation Fixes
;; ==========================================
(setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))

(add-hook 'server-after-make-frame-hook
          (lambda ()
            (with-current-buffer (get-buffer-create "*dashboard*")
              (dashboard-refresh-buffer))
            (switch-to-buffer "*dashboard*")))

(provide 'init)
;;; init.el ends here
