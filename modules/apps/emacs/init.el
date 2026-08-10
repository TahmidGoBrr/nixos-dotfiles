;;; init.el --- The Ultimate IDE Zenith Config -*- lexical-binding: t; -*-

;; ==========================================
;; 1. Core Engine Performance, Modifiers & File Handling
;; ==========================================
(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024 200)
      fast-but-imprecise-scrolling t
      jit-lock-defer-time 0.05
      scroll-conservatively 101)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 1024 1024 500)
                  gc-cons-percentage 0.9)))

;; Fixes freezing/lag on fast scrolling in Elisp and programming modes
(add-hook 'prog-mode-hook
          (lambda ()
            (setq-local bidi-display-reordering nil)
            (setq-local bidi-paragraph-direction 'left-to-right)))

;; Map Alt key to Meta explicitly
(setq x-alt-keysym 'meta)
(setq x-meta-keysym nil)

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

;; Global Syntax Highlighting / Font-Lock
(global-font-lock-mode 1)

;; Load large files (GB+) without freezing using VLF
(require 'vlf-setup)
(custom-set-variables '(vlf-application 'always))

;; Suppress native compilation warnings
(setq native-comp-async-report-warnings-errors 'silent)
(setq warning-suppress-types '((comp)))

;; CLipboard configuration
(setq select-enable-clipboard t
      select-enable-primary t)

;; ==========================================
;; 2. Visual Overhaul, Theme, Fonts & UI
;; ==========================================
(menu-bar-mode -1) (tool-bar-mode -1) (scroll-bar-mode -1)

;; Default Font Configuration
(set-face-attribute 'default nil
                    :family "Iosevka Nerd Font"
                    :height 120
                    :weight 'normal)

;; Symbol/Icon Font Fallback
(set-fontset-font t 'symbol (font-spec :family "Symbols Nerd Font Mono") nil 'append)

;; Revert Theme to Catppuccin Mocha
(use-package catppuccin-theme
  :config
  (setq catppuccin-flavor 'mocha)
  (load-theme 'catppuccin t))

(use-package doom-modeline :init (doom-modeline-mode 1))

;; Filter out internal buffers (*Messages*, *Warnings*, *Treemacs*, etc.) from tabs
(use-package centaur-tabs
  :demand
  :config
  (centaur-tabs-mode t)
  (setq centaur-tabs-style "bar"
        centaur-tabs-height 32
        centaur-tabs-set-icons t)
  (defun my-hide-internal-tabs (buffer)
    (let ((name (string-trim (format "%s" buffer))))
      (or (string-prefix-p "*" name)
          (string-prefix-p "magit" name))))
  (setq centaur-tabs-hide-tab-function 'my-hide-internal-tabs))

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
;; 4. Evil Mode, Completion, LSP, Icons & Tree-sitter
;; ==========================================
(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil ; Fixes evil-collection warning
        evil-undo-system 'undo-tree)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package undo-tree :init (global-undo-tree-mode))

(use-package vertico :init (vertico-mode 1))
(use-package marginalia :init (marginalia-mode 1))
(use-package corfu :init (global-corfu-mode) :custom (corfu-auto t))
(use-package company
  :custom
  (company-idle-delay 0.0)
  (company-minimum-prefix-length 1)
  :hook (prog-mode . company-mode))
(use-package projectile :init (projectile-mode +1))

;; Treemacs & Nerd Icons Theme (Font Scaling Included)
(use-package treemacs
  :bind ("<f8>" . treemacs)
  :config
  (setq treemacs-width 35)
  (add-hook 'treemacs-mode-hook
            (lambda ()
              (text-scale-increase 1))))

(use-package treemacs-nerd-icons
  :after (treemacs nerd-icons)
  :config
  (treemacs-load-theme "nerd-icons"))

;; Tree-sitter Automatic Grammars & Highlighting
(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;; Safe, Direct Tree-sitter Language Remapping (Prevents Freezes)
(setq major-mode-remap-alist
      '((bash-mode       . bash-ts-mode)
        (c-mode          . c-ts-mode)
        (c++-mode        . c++-ts-mode)
        (csharp-mode     . csharp-ts-mode)
        (css-mode        . css-ts-mode)
        (dockerfile-mode . dockerfile-ts-mode)
        (elixir-mode     . elixir-ts-mode)
        (go-mode         . go-ts-mode)
        (html-mode       . html-ts-mode)
        (java-mode       . java-ts-mode)
        (js-mode         . js-ts-mode)
        (json-mode       . json-ts-mode)
        (lua-mode        . lua-ts-mode)
        (python-mode     . python-ts-mode)
        (ruby-mode       . ruby-ts-mode)
        (rust-mode       . rust-ts-mode)
        (sh-mode         . bash-ts-mode)
        (typescript-mode . typescript-ts-mode)
        (yaml-mode       . yaml-ts-mode)))

;; Direct File Extension Associations
(add-to-list 'auto-mode-alist '("\\.lua\\'" . lua-ts-mode))
(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-ts-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.json\\'" . json-ts-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\|\\.yml\\'" . yaml-ts-mode))
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-ts-mode))
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-ts-mode))
(add-to-list 'auto-mode-alist '("\\.ex\\|\\.exs\\'" . elixir-ts-mode))
(add-to-list 'auto-mode-alist '("\\.typ\\'" . typst-ts-mode))

;; Async Format-On-Save (NVF Parity via Apheleia)
(use-package apheleia
  :config
  (apheleia-global-mode +1)
  (setf (alist-get 'alejandra apheleia-formatters) '("alejandra" "-"))
  (setf (alist-get 'nix-mode apheleia-mode-alist) 'alejandra)
  (setf (alist-get 'nix-ts-mode apheleia-mode-alist) 'alejandra)
  (setf (alist-get 'python-mode apheleia-mode-alist) 'black)
  (setf (alist-get 'python-ts-mode apheleia-mode-alist) 'black)
  (setf (alist-get 'typescript-mode apheleia-mode-alist) 'prettier-typescript)
  (setf (alist-get 'typescript-ts-mode apheleia-mode-alist) 'prettier-typescript)
  (setf (alist-get 'tsx-ts-mode apheleia-mode-alist) 'prettier-typescript)
  (setf (alist-get 'js-mode apheleia-mode-alist) 'prettier-javascript)
  (setf (alist-get 'js-ts-mode apheleia-mode-alist) 'prettier-javascript)
  (setf (alist-get 'json-mode apheleia-mode-alist) 'prettier-json)
  (setf (alist-get 'json-ts-mode apheleia-mode-alist) 'prettier-json)
  (setf (alist-get 'css-mode apheleia-mode-alist) 'prettier-css)
  (setf (alist-get 'css-ts-mode apheleia-mode-alist) 'prettier-css)
  (setf (alist-get 'html-mode apheleia-mode-alist) 'prettier-html)
  (setf (alist-get 'html-ts-mode apheleia-mode-alist) 'prettier-html)
  (setf (alist-get 'yaml-mode apheleia-mode-alist) 'prettier-yaml)
  (setf (alist-get 'yaml-ts-mode apheleia-mode-alist) 'prettier-yaml)
  (setf (alist-get 'bash-ts-mode apheleia-mode-alist) 'shfmt)
  (setf (alist-get 'sh-mode apheleia-mode-alist) 'shfmt))

;; Full LSP-Mode Engine & LSP UI (Excludes Elisp to prevent warnings)
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :custom
  (lsp-idle-delay 0.1)
  (lsp-headerline-breadcrumb-enable t)
  (lsp-eldoc-render-all nil)
  (lsp-enable-symbol-highlighting t)
  (lsp-warn-no-matched-clients nil)
  :hook ((prog-mode . (lambda ()
                        (unless (derived-mode-p 'emacs-lisp-mode 'lisp-data-mode)
                          (lsp-deferred))))
         (lsp-mode . lsp-enable-which-key-integration)))

(use-package lsp-ui
  :commands lsp-ui-mode
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-sideline-enable t)
  (lsp-ui-sideline-show-diagnostics t)
  (lsp-ui-sideline-show-hover t))

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
(global-set-key (kbd "C-c t") 'vterm)
(global-set-key (kbd "C-c d") 'dashboard-open)
(global-set-key (kbd "C-S c") 'kill-ring-save)
(global-set-key (kbd "C-S v") 'yank)

(setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))

(add-hook 'server-after-make-frame-hook
          (lambda ()
            (with-current-buffer (get-buffer-create "*dashboard*")
              (dashboard-refresh-buffer))
            (switch-to-buffer "*dashboard*")))
(provide 'init)
;;; init.el ends here
 