;;; init.el --- The Ultimate IDE Zenith Config -*- lexical-binding: t; -*-

;; ==========================================
;; 1. Core Engine Performance & File Handling
;; ==========================================
(setq gc-cons-threshold most-positive-fixnum
      read-process-output-max (* 1024 1024 200))

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 1024 1024 500)
                  gc-cons-percentage 0.9)))

(setq-default tab-width 2 indent-tabs-mode nil word-wrap nil)
(setq display-line-numbers-type 'relative inhibit-startup-screen t inhibit-startup-message t)

(global-display-line-numbers-mode t)
(global-hl-line-mode t)
(save-place-mode 1)
(winner-mode 1)
(electric-pair-mode 1)
(electric-indent-mode 1)
(recentf-mode 1)
(global-auto-revert-mode 1)

;; Load large files (GB+) without freezing using VLF
(require 'vlf-setup)
(custom-set-variables '(vlf-application 'always))

;; ==========================================
;; 2. Visual Overhaul, Minimap & UI
;; ==========================================
(menu-bar-mode -1) (tool-bar-mode -1) (scroll-bar-mode -1)
(set-face-attribute 'default nil :height 120)

(use-package catppuccin-theme :config (load-theme 'catppuccin t))
(use-package doom-modeline :init (doom-modeline-mode 1))
(use-package centaur-tabs :demand :config (centaur-tabs-mode t))

;; The classic IDE Minimap (toggle with C-c m)
(use-package minimap
  :bind ("C-c m" . minimap-mode)
  :config
  (setq minimap-window-location 'right
        minimap-update-delay 0.2
        minimap-minimum-width 20))

(use-package dashboard
  :config
  (setq dashboard-startup-banner 'logo
        dashboard-center-content t
        dashboard-banner-logo-title "Welcome to GNU Emacs."
        dashboard-items '((projects . 5) (recents . 5) (bookmarks . 5)))
  (dashboard-setup-startup-hook))

;; ==========================================
;; 3. Advanced Developer Tools & Containers
;; ==========================================

;; Environment variables auto-loader
(use-package envrc
  :init (envrc-global-mode))

;; Docker & Kubernetes Managers
(use-package docker
  :bind ("C-c d" . docker))
(use-package kubernetes
  :commands (kubernetes-overview))

;; Postman Alternative (API Testing via HTTP files)
(use-package restclient
  :mode ("\\.http\\'" . restclient-mode))

;; Local Microservice/Script Manager
(use-package prodigy
  :bind ("C-c y" . prodigy)
  :config
  ;; Example: Add a background service to your IDE
  (prodigy-define-service
    :name "Local Dev Server"
    :command "npm"
    :args '("run" "dev")
    :cwd "~/projects/my-app"
    :tags '(node frontend)
    :kill-signal 'sigkill))

;; Offline API Documentation Lookup
(use-package devdocs
  :bind ("C-h D" . devdocs-lookup))

;; Snippet Engine
(use-package yasnippet
  :init (yas-global-mode 1))
(use-package yasnippet-snippets)

;; Hex Editor for Binaries
(use-package nhexl-mode
  :commands nhexl-mode)

;; Real-time Collaborative Editing (VS Live Share alternative)
(use-package crdt
  :commands (crdt-share-buffer crdt-connect))

;; ==========================================
;; 4. Evil Mode, Completion & LSP Core
;; ==========================================
(use-package evil :init (setq evil-want-integration t evil-undo-system 'undo-tree) :config (evil-mode 1))
(use-package evil-collection :after evil :config (evil-collection-init))
(use-package undo-tree :init (global-undo-tree-mode))

(use-package vertico :init (vertico-mode 1))
(use-package marginalia :init (marginalia-mode 1))
(use-package corfu :init (global-corfu-mode) :custom (corfu-auto t))
(use-package projectile :init (projectile-mode +1))
(use-package treemacs :bind ("<f8>" . treemacs))

(use-package eglot :hook ((prog-mode . eglot-ensure)))
(use-package apheleia :config (apheleia-global-mode +1))
(use-package dape :bind ("<f5>" . dape))
(use-package magit)
(use-package vterm)

;; AI Integration
(use-package gptel
  :bind ("C-c a" . gptel)
  :config (setq gptel-model "llama3"
                gptel-backend (gptel-make-ollama "Ollama" :host "localhost:11434" :stream t)))

;; ==========================================
;; 5. Keybindings & Daemon Startup
;; ==========================================
(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-c g") 'magit-status)
(global-set-key (kbd "C-c e") 'treemacs)

(setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))

(add-hook 'server-after-make-frame-hook
          (lambda ()
            (with-current-buffer (get-buffer-create "*dashboard*")
              (dashboard-refresh-buffer))
            (switch-to-buffer "*dashboard*")))

(provide 'init)
;;; init.el ends here
