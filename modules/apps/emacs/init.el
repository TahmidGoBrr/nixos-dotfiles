;;; init.el --- The Ultimate Emacs OS Configuration -*- lexical-binding: t; -*-

;; =============================================================================
;; 1. CORE ENGINE PERFORMANCE & OS-LEVEL GLOBAL OPTIONS
;; =============================================================================

(require 'use-package)
(setq use-package-always-ensure nil)

(setq gc-cons-threshold (* 500 1024 1024)
      read-process-output-max (* 1024 1024 200)
      fast-but-imprecise-scrolling t
      jit-lock-defer-time 0.05
      scroll-conservatively 101)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 50 1024 1024)
                  gc-cons-percentage 0.1)))

(add-hook 'prog-mode-hook
          (lambda ()
            (setq-local bidi-display-reordering nil)
            (setq-local bidi-paragraph-direction 'left-to-right)))

(setq-default tab-width 2
              indent-tabs-mode nil
              standard-indent 2)

(setq-default c-basic-offset 2
              js-indent-level 2
              typescript-indent-level 2
              css-indent-offset 2
              web-mode-markup-indent-offset 2
              web-mode-css-indent-offset 2
              web-mode-code-indent-offset 2
              python-indent-offset 2
              nix-indent-function 'nix-indent-line)

(setq-default tab-width 2
              indent-tabs-mode nil
              word-wrap nil
              fill-column 80
              sentence-end-double-space nil
              bidi-display-reordering nil
              cursor-type 'box
              blink-cursor-interval 0.4)

(setq display-line-numbers-type 'relative
      inhibit-startup-screen t
      inhibit-startup-message t
      initial-scratch-message nil
      ring-bell-function 'ignore
      visible-bell nil
      scroll-margin 2
      scroll-preserve-screen-position t
      mouse-wheel-scroll-amount '(1 ((shift) . 1))
      mouse-wheel-progressive-speed nil
      use-dialog-box nil
      use-file-dialog nil
      auto-save-default t
      make-backup-files t
      create-lockfiles nil
      vc-make-backup-files t
      history-length 2000
      history-delete-duplicates t)

(defvar my-backup-dir (locate-user-emacs-file "backups/"))
(defvar my-autosave-dir (locate-user-emacs-file "autosaves/"))
(defvar my-undo-dir (locate-user-emacs-file "undo/"))

(unless (file-exists-p my-backup-dir) (make-directory my-backup-dir t))
(unless (file-exists-p my-autosave-dir) (make-directory my-autosave-dir t))
(unless (file-exists-p my-undo-dir) (make-directory my-undo-dir t))

(setq backup-directory-alist `(("." . ,my-backup-dir))
      auto-save-file-name-transforms `((".*" ,my-autosave-dir t)))

(global-display-line-numbers-mode t)
(global-hl-line-mode t)
(save-place-mode 1)
(winner-mode 1)
(electric-pair-mode 1)
(electric-indent-mode 1)
(recentf-mode 1)
(global-auto-revert-mode 1)
(global-font-lock-mode 1)
(delete-selection-mode 1)
(column-number-mode 1)
(show-paren-mode 1)

(use-package vlf
  :config
  (require 'vlf-setup)
  (custom-set-variables '(vlf-application 'always)))

(setq native-comp-async-report-warnings-errors 'silent)
(setq warning-suppress-types '((comp)))

(setq select-enable-clipboard t
      select-enable-primary t
      save-interprogram-paste-before-kill t)

(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8-mac)
(set-terminal-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; =============================================================================
;; 2. VISUAL OVERHAUL, INLINE COMPLINE THEME, FONTS & UI
;; =============================================================================

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq tooltip-mode -1)
(set-fringe-mode 10)

;; Native Tab Bar Configuration
(tab-bar-mode 1)
(setq tab-bar-show 1
      tab-bar-close-button-show nil
      tab-bar-new-tab-choice "*dashboard*"
      tab-bar-format '(tab-bar-format-tabs tab-bar-format-align-right tab-bar-format-global))

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-one t)
  (require 'doom-themes-ext-org)
  (doom-themes-org-config))
;; Note: You can append your manual hex overrides right after this block
;; using `custom-set-faces` or the doom-themes API as you had it before.

(use-package doom-modeline
  :config (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 25)
  (doom-modeline-bar-width 4)
  (doom-modeline-icon t)
  (doom-modeline-major-mode-icon t)
  (doom-modeline-major-mode-color-icon t)
  (doom-modeline-buffer-file-name-style 'truncate-upto-project)
  (doom-modeline-icon-provider 'nerd-icons))
(custom-set-faces
 '(mode-line ((t (:background "#1e2124" :foreground "#d3d7dc"))))
 '(mode-line-inactive ((t (:background "#16181a" :foreground "#5c6370")))))

(use-package beacon
  :config (beacon-mode 1))

(use-package breadcrumb
  :config (breadcrumb-mode 1))

(use-package symbols-outline
  :bind ("C-c s" . symbols-outline-show))

(use-package origami
  :hook (prog-mode . origami-mode)
  :init
  ;; Pre-define the face to prevent the Emacs 30 daemon crash
  (defface origami-fold-header-face
    '((t (:box (:line-width 1 :color "#5c6370"))))
    "Face used to display fold headers."
    :group 'origami))

(use-package minions
  :config (minions-mode 1))

(use-package mixed-pitch
  :hook ((org-mode . mixed-pitch-mode)
         (markdown-mode . mixed-pitch-mode)))

(use-package minimap
  :bind ("C-c M-m" . minimap-mode)
  :custom
  (minimap-window-location 'right)
  (minimap-update-delay 0.2)
  (minimap-minimum-width 20)
  (minimap-width-fraction 0.08)
  (minimap-hide-scroll-bar t)
  (minimap-hide-fringes t)
  (minimap-enlarge-certain-faces 'always))

(use-package dashboard
  :config
  (setq dashboard-startup-banner 'logo
        dashboard-center-content t
        dashboard-show-shortcuts nil
        dashboard-set-heading-icons t
        dashboard-set-file-icons t
        dashboard-set-navigator t
        dashboard-set-init-info t
        dashboard-banner-logo-title "Welcome to the Emacs Operating System."
        dashboard-items '((recents  . 10)
                          (bookmarks . 5)
                          (projects . 5)
                          (agenda . 5)
                          (registers . 5)))
  (dashboard-setup-startup-hook))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package highlight-indent-guides
  :hook (prog-mode . highlight-indent-guides-mode)
  :custom
  (highlight-indent-guides-method 'character)
  (highlight-indent-guides-character ?\|)
  (highlight-indent-guides-responsive 'top)
  (highlight-indent-guides-delay 0.1))

(use-package indent-bars
  :hook (prog-mode . indent-bars-mode)
  :custom
  (indent-bars-color '(highlight :face-bg t :blend 0.2))
  (indent-bars-pattern ".")
  (indent-bars-width-frac 0.1)
  (indent-bars-pad-frac 0.1)
  (indent-bars-zigzag nil)
  (indent-bars-color-by-depth '(:regexp "outline-\\([0-9]+\\)" :blend 1)))

(use-package page-break-lines
  :hook (after-init . global-page-break-lines-mode))

;; =============================================================================
;; 3. EVIL MODE (THE VIM KERNEL)
;; =============================================================================

(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-want-C-i-jump nil
        evil-want-Y-yank-to-eol t
        evil-respect-visual-line-mode t
        evil-undo-system 'undo-tree
        evil-search-module 'evil-search
        evil-split-window-below t
        evil-vsplit-window-right t
        evil-symbol-word-search t)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal)
  (evil-set-initial-state 'ement-room-mode 'normal)
  (evil-set-initial-state 'elfeed-search-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (setq evil-collection-mode-list '(dashboard dired ibuffer magit vterm corfu vertico prodigy mu4e elfeed ement))
  (evil-collection-init))

(use-package evil-surround
  :config (global-evil-surround-mode 1))

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

(use-package evil-goggles
  :config
  (evil-goggles-mode)
  (evil-goggles-use-diff-faces))

(use-package evil-matchit
  :config (global-evil-matchit-mode 1))

(use-package evil-anzu
  :after evil
  :config
  (require 'evil-anzu))

(use-package evil-snipe
  :config
  (evil-snipe-mode +1)
  (evil-snipe-override-mode +1)
  (setq evil-snipe-scope 'buffer
        evil-snipe-repeat-scope 'whole-line
        evil-snipe-spillover-search t))

(use-package evil-exchange
  :config (evil-exchange-install))

(use-package evil-indent-plus
  :config (evil-indent-plus-default-bindings))

(use-package evil-multiedit
  :config
  (evil-multiedit-default-keybinds)
  (setq evil-multiedit-follow-matches t))

(use-package evil-mc
  :config (global-evil-mc-mode 1))

(use-package undo-tree
  :config
  (global-undo-tree-mode 1)
  :custom
  (undo-tree-history-directory-alist `(("." . ,my-undo-dir)))
  (undo-tree-visualizer-diff t)
  (undo-tree-visualizer-timestamps t)
  (undo-tree-enable-undo-in-region t)
  (undo-tree-auto-save-history t))

;; =============================================================================
;; 4. COMPLETION, SEARCH, NAVIGATION, & LINTING (THE OS SEARCH ENGINE)
;; =============================================================================

(use-package vertico
  :config (vertico-mode 1)
  :custom
  (vertico-scroll-margin 0)
  (vertico-count 20)
  (vertico-resize t)
  (vertico-cycle t))

(use-package vertico-prescient
  :after vertico
  :config
  (vertico-prescient-mode 1)
  (prescient-persist-mode 1))

(use-package marginalia
  :after vertico
  :config (marginalia-mode 1)
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil)))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package corfu
  :config (global-corfu-mode 1)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 2)
  (corfu-quit-no-match 'separator)
  (corfu-quit-at-boundary t)
  (corfu-preview-current 'insert)
  (corfu-preselect-first nil)
  (corfu-on-exact-match nil)
  (corfu-scroll-margin 5)
  :bind
  (:map corfu-map
        ("TAB" . corfu-next)
        ([tab] . corfu-next)
        ("S-TAB" . corfu-previous)
        ([backtab] . corfu-previous)))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block)
  (add-to-list 'completion-at-point-functions #'cape-history)
  (add-to-list 'completion-at-point-functions #'cape-keyword))

(use-package company
  :custom
  (company-idle-delay 0.0)
  (company-minimum-prefix-length 1)
  (company-show-numbers t)
  (company-tooltip-align-annotations t)
  (company-global-modes '(not erc-mode message-mode help-mode gud-mode))
  :hook (prog-mode . company-mode))

(use-package consult
  :bind (("C-c h" . consult-history)
         ("C-x b" . consult-buffer)
         ("M-y" . consult-yank-pop)
         ("M-g i" . consult-imenu)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line))
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)
  (advice-add #'register-preview :override #'consult-register-window)
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  :config
  (setq consult-narrow-key "<"))

(use-package consult-dir
  :bind (("C-x C-d" . consult-dir)
         :map vertico-map
         ("C-x C-d" . consult-dir)))

(use-package embark
  :bind
  (("C-." . embark-act)
   ("C-;" . embark-dwim)
   ("C-h B" . embark-bindings))
  :init
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package avy
  :bind
  (("C-:" . avy-goto-char)
   ("C-'" . avy-goto-char-2))
  :config
  (setq avy-background t
        avy-all-windows t
        avy-timeout-seconds 0.3))

(use-package ace-window
  :bind ("M-o" . ace-window)
  :custom
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(use-package wgrep
  :custom (wgrep-auto-save-buffer t))

(use-package imenu-list
  :bind ("C-c i l" . imenu-list-smart-toggle))

(use-package flycheck
  :config (global-flycheck-mode 1)
  :custom
  (flycheck-display-errors-delay 0.3)
  (flycheck-indication-mode 'right-fringe))

(use-package consult-flycheck
  :bind ("M-g f" . consult-flycheck))

(use-package consult-eglot
  :bind ("M-g e" . consult-eglot))

(use-package smart-jump
  :config (smart-jump-setup-default-registers))

(use-package which-key
  :init (which-key-mode)
  :custom
  (which-key-idle-delay 0.3)
  (which-key-popup-type 'side-window)
  (which-key-side-window-location 'bottom)
  (which-key-side-window-max-height 0.25)
  (which-key-show-early-on-C-h t))

(use-package helpful
  :bind
  ([remap describe-function] . helpful-callable)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key] . helpful-key)
  ([remap describe-symbol] . helpful-symbol))

;; =============================================================================
;; 5. WORKSPACES, PROJECT TRACKING & FILE EXPLORER (THE DESKTOP)
;; =============================================================================

(use-package projectile
  :config
  (projectile-mode +1)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :custom
  (projectile-project-search-path '("~/Projects" "~/work" "~/.config"))
  (projectile-sort-order 'recentf)
  (projectile-completion-system 'default)
  (projectile-enable-caching t)
  (projectile-indexing-method 'alien)
  (projectile-auto-discover nil))

(use-package consult-projectile
  :after (consult projectile)
  :bind
  ("C-c p p" . consult-projectile)
  ("C-c p f" . consult-projectile-find-file)
  ("C-c p d" . consult-projectile-find-dir)
  ("C-c p b" . consult-projectile-switch-to-buffer))

(use-package ibuffer-projectile
  :hook (ibuffer . (lambda ()
                     (ibuffer-projectile-set-filter-groups)
                     (unless (eq ibuffer-sorting-mode 'alphabetic)
                       (ibuffer-do-sort-by-alphabetic)))))

(use-package projectile-ripgrep)

(use-package treemacs
  :bind ("<f8>" . treemacs)
  :custom
  (treemacs-width 35)
  (treemacs-is-never-other-window t)
  (treemacs-position 'left)
  (treemacs-silent-refresh t)
  (treemacs-silent-filewatch t)
  (treemacs-collapse-dirs 3)
  (treemacs-missing-project-action 'remove)
  (treemacs-sorting 'alphabetic-asc)
  (treemacs-follow-after-init t)
  :config
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-fringe-indicator-mode 'always)
  (add-hook 'treemacs-mode-hook
            (lambda () (text-scale-increase 1))))

(use-package treemacs-evil :after (treemacs evil))
(use-package treemacs-projectile :after (treemacs projectile))
(use-package treemacs-magit :after (treemacs magit))
(use-package treemacs-nerd-icons
  :after (treemacs nerd-icons)
  :config
  (treemacs-load-theme "nerd-icons"))

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom
  (dired-listing-switches "-agho --group-directories-first")
  (dired-dwim-target t)
  (dired-hide-details-hide-symlink-targets nil)
  (dired-auto-revert-buffer t)
  (dired-recursive-copies 'always)
  (dired-recursive-deletes 'top)
  (delete-by-moving-to-trash t)
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-up-directory
    "l" 'dired-find-file))

(use-package dired-sidebar
  :bind (("C-x C-n" . dired-sidebar-toggle-sidebar))
  :custom
  (dired-sidebar-theme 'nerd-icons)
  (dired-sidebar-use-term-integration t)
  (dired-sidebar-use-custom-font t))

(use-package dired-open
  :config
  (setq dired-open-extensions '(("png" . "sxiv")
                                ("jpg" . "sxiv")
                                ("mkv" . "mpv")
                                ("mp4" . "mpv")
                                ("pdf" . "zathura"))))

(use-package bufler
  :bind (("C-x C-b" . bufler))
  :custom
  (bufler-filter-buffer-name-regexps '("\\*Compile-Log\\*" "\\*Backtrace\\*")))

(use-package eyebrowse
  :config
  (eyebrowse-mode t)
  (setq eyebrowse-new-workspace t))

(use-package window-numbering
  :config (window-numbering-mode t))

(use-package switch-window
  :bind ("C-x o" . switch-window))

(use-package persp-mode
  :custom
  (persp-keymap-prefix (kbd "C-c w"))
  (persp-nil-name "default")
  (persp-set-last-persp-for-new-frames t)
  (persp-keep-windows-selected t)
  (persp-auto-resume-time -1)
  :config
  (persp-mode 1))

;; =============================================================================
;; 6. DEVELOPMENT: LSP & TREESITTER (THE COMPILERS)
;; =============================================================================

(use-package treesit-auto
  :custom
  (treesit-auto-install nil)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

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
  (lsp-completion-provider :capf)
  (lsp-enable-snippet t)
  (lsp-file-watch-threshold 1500)
  (lsp-restart 'auto-restart)
  (lsp-keep-workspace-alive nil)
  (lsp-modeline-code-actions-enable t)
  (lsp-modeline-diagnostics-enable t)
  (lsp-modeline-workspace-status-enable t)
  (lsp-signature-auto-activate nil)
  (lsp-diagnostics-provider :flycheck)
  (lsp-enable-indentation nil)
  (lsp-enable-on-type-formatting nil)
  :hook ((prog-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration)))

(use-package lsp-ui
  :commands lsp-ui-mode
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-doc-delay 0.5)
  (lsp-ui-doc-max-width 80)
  (lsp-ui-doc-max-height 30)
  (lsp-ui-doc-include-signature t)
  (lsp-ui-doc-use-childframe t)
  (lsp-ui-sideline-enable t)
  (lsp-ui-sideline-show-diagnostics t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-sideline-show-code-actions t)
  (lsp-ui-imenu-enable t)
  (lsp-ui-imenu-colors `(,(face-foreground 'font-lock-keyword-face)
                         ,(face-foreground 'font-lock-string-face)
                         ,(face-foreground 'font-lock-constant-face)
                         ,(face-foreground 'font-lock-variable-name-face))))

(use-package dape
  :bind ("<f5>" . dape)
  :custom
  (dape-buffer-window-arrangement 'right)
  (dape-info-hide-mode-line nil)
  (dape-inlay-hints t)
  (dape-cwd-fn 'projectile-project-root))

;; =============================================================================
;; 7. FORMATTING & REFACTORING TOOLS
;; =============================================================================

(use-package apheleia
  :config
  (setq apheleia-log-only-errors t)
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

(use-package format-all
  :commands format-all-buffer)

(use-package smartparens
  :hook (prog-mode . smartparens-mode)
  :config
  (require 'smartparens-config))

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package iedit
  :bind ("C-;" . iedit-mode))

(use-package ws-butler
  :hook ((prog-mode . ws-butler-mode)
         (text-mode . ws-butler-mode)))

(use-package aggressive-indent
  :hook (emacs-lisp-mode . aggressive-indent-mode))

(use-package crux
  :bind (("C-c o" . crux-open-with)
         ("C-a" . crux-move-beginning-of-line)
         ("C-c d" . crux-duplicate-current-line-or-region)
         ("C-c M-d" . crux-duplicate-and-comment-current-line-or-region)))

(use-package super-save
  :config
  (super-save-mode +1)
  (setq super-save-auto-save-when-idle t
        super-save-idle-duration 5))

(use-package string-inflection
  :bind (("C-c i i" . string-inflection-all-cycle)
         ("C-c i c" . string-inflection-camelcase)
         ("C-c i k" . string-inflection-kebab-case)
         ("C-c i s" . string-inflection-snake-case)))

;; =============================================================================
;; 8. TERMINAL, CONTAINERS, & DEV TOOLS (THE OS SUBSYSTEMS)
;; =============================================================================

(use-package vterm
  :commands vterm
  :custom
  (vterm-max-scrollback 100000)
  (vterm-kill-buffer-on-exit t)
  (vterm-always-compile-module t)
  (vterm-timer-delay 0.01))

(use-package vterm-toggle
  :bind (("C-c t" . vterm-toggle)
         ("C-c T" . vterm-toggle-cd))
  :custom
  (vterm-toggle-fullscreen-p nil)
  (add-to-list 'display-buffer-alist
               '((lambda (buffer-or-name _)
                   (let ((buffer (get-buffer buffer-or-name)))
                     (with-current-buffer buffer
                       (or (equal major-mode 'vterm-mode)
                           (string-prefix-p vterm-buffer-name (buffer-name buffer))))))
                 (display-buffer-reuse-window display-buffer-at-bottom)
                 (reusable-frames . visible)
                 (window-height . 0.3))))

(use-package envrc
  :config (envrc-global-mode))

(use-package direnv
  :config
  (direnv-mode))

(use-package popper
  :bind (("C-`"   . popper-toggle)
         ("M-`"   . popper-cycle)
         ("C-M-`" . popper-toggle-type))
  :custom
  (popper-reference-buffers
   '("\\*Messages\\*"
     "Output\\*$"
     "\\*Async Shell Command\\*"
     help-mode
     compilation-mode))
  :config
  (popper-mode +1)
  (popper-echo-mode +1))

(use-package docker
  :bind ("C-c d" . docker)
  :custom
  (docker-command "docker")
  (docker-container-columns
   '((:name "Id" :width 15 :template "{{ json .ID }}" :sort nil :format nil)
     (:name "Names" :width 30 :template "{{ json .Names }}" :sort nil :format nil)
     (:name "Image" :width 20 :template "{{ json .Image }}" :sort nil :format nil)
     (:name "Status" :width 20 :template "{{ json .Status }}" :sort nil :format nil))))

(use-package kubernetes
  :commands (kubernetes-overview)
  :custom
  (kubernetes-poll-frequency 10))

(use-package verb
  :hook (org-mode . verb-mode))

(use-package restclient
  :mode ("\\.http\\'" . restclient-mode)
  :hook (restclient-mode . display-line-numbers-mode))

(use-package prodigy
  :bind ("C-c y" . prodigy)
  :config
  (prodigy-define-service
   :name "Example Daemon"
   :command "npm"
   :args '("run" "dev")
   :cwd "~"
   :tags '(node daemon)
   :kill-signal 'sigkill))

(use-package devdocs
  :bind ("C-h D" . devdocs-lookup))

(use-package zeal-at-point
  :bind ("C-h z" . zeal-at-point))

(use-package yasnippet
  :config (yas-global-mode 1)
  :custom
  (yas-snippet-dirs (list (locate-user-emacs-file "snippets/")))
  :config
  (unless (file-exists-p (car yas-snippet-dirs))
    (make-directory (car yas-snippet-dirs) t)))

(use-package yasnippet-snippets)

(use-package nhexl-mode
  :commands nhexl-mode)

(use-package crdt
  :commands (crdt-share-buffer crdt-connect)
  :custom
  (crdt-default-name (user-login-name)))

(use-package ejc-sql
  :commands ejc-sql-mode
  :custom
  (ejc-result-table-impl 'orgtbl-mode))

(use-package edbi
  :commands edbi:open-db-viewer)

;; =============================================================================
;; 9. MAJOR LANGUAGE MODES (EDITING ENVIRONMENTS)
;; =============================================================================

(use-package lua-mode
  :mode "\\.lua\\'"
  :custom
  (lua-indent-level 2)
  (lua-indent-string-contents nil))

(use-package nix-mode
  :mode "\\.nix\\'"
  :custom
  (nix-indent-function 'nix-indent-line))

(use-package yaml-mode
  :mode "\\.ya?ml\\'")

(use-package k8s-mode
  :hook (k8s-mode . yas-minor-mode))

(use-package markdown-mode
  :mode "\\.md\\'"
  :custom
  (markdown-command "multimarkdown")
  (markdown-header-scaling t)
  (markdown-enable-math t))

(use-package rust-mode
  :mode "\\.rs\\'"
  :custom
  (rust-format-on-save nil))

(use-package go-mode
  :mode "\\.go\\'"
  :custom
  (gofmt-command "goimports")
  (go-fontify-function-calls t))

(use-package typescript-mode
  :mode "\\.ts\\'"
  :custom
  (typescript-indent-level 2))

(use-package emmet-mode
  :hook ((html-mode . emmet-mode)
         (css-mode . emmet-mode)))

(use-package elixir-mode
  :mode "\\.exs?\\'")

(use-package terraform-mode
  :mode "\\.tf\\'")

(use-package dockerfile-mode
  :mode "Dockerfile\\'")

(use-package just-mode
  :mode "\\Justfile\\'")

;; =============================================================================
;; 10. ORG MODE & ROAM (THE OS DESKTOP & KNOWLEDGE GRAPH)
;; =============================================================================

(use-package org
  :hook (org-mode . variable-pitch-mode)
  :custom
  (org-directory "~/Org")
  (org-default-notes-file (concat org-directory "/notes.org"))
  (org-agenda-files (list org-directory))
  (org-log-done 'time)
  (org-log-into-drawer t)
  (org-todo-keywords
   '((sequence "TODO(t)" "NEXT(n)" "IN-PROGRESS(i)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
  (org-startup-indented t)
  (org-startup-with-inline-images t)
  (org-hide-emphasis-markers t)
  (org-pretty-entities t)
  (org-src-fontify-natively t)
  (org-src-tab-acts-natively t)
  (org-src-window-setup 'current-window)
  (org-confirm-babel-evaluate nil)
  :config
  (unless (file-exists-p org-directory)
    (make-directory org-directory t))

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (shell . t)
     (lua . t)
     (sql . t)))
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•")))))))

(use-package org-super-agenda
  :hook (org-agenda-mode . org-super-agenda-mode))

(use-package org-roam
  :custom
  (org-roam-directory (file-truename "~/Org/Roam"))
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
   '(("d" "default" plain "%?"
      :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                         "#+title: ${title}\n#+date: %U\n")
      :unnarrowed t)))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  (org-roam-db-autosync-mode))

(use-package org-roam-ui
  :after org-roam
  :custom
  (org-roam-ui-sync-theme t)
  (org-roam-ui-follow t)
  (org-roam-ui-update-on-save t)
  (org-roam-ui-open-on-start t))

(use-package calfw
  :commands cfw:open-calendar-buffer)

(use-package calfw-org)

(use-package pdf-tools
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :config
  (pdf-tools-install t))

;; =============================================================================
;; 11. EMACS OS APPLICATIONS (NEW: MAIL, CHAT, MEDIA, RSS)
;; =============================================================================

;; Email Client
(use-package mu4e
  :ensure nil
  :bind ("C-c m m" . mu4e)
  :custom
  (mu4e-update-interval (* 10 60))
  (mu4e-get-mail-command "mbsync -a")
  (mu4e-attachment-dir  "~/Downloads")
  (mu4e-view-show-images t)
  (mu4e-view-show-addresses t)
  :config
  (setq sendmail-program "msmtp"
        message-send-mail-function 'message-send-mail-with-sendmail
        message-sendmail-f-is-evil t))

(use-package mu4e-alert
  :after mu4e
  :config
  (mu4e-alert-set-default-style 'libnotify)
  (mu4e-alert-enable-notifications)
  (mu4e-alert-enable-mode-line-display))

;; Matrix Client
(use-package ement
  :bind ("C-c m c" . ement-connect)
  :custom
  (ement-save-sessions t)
  (ement-room-send-message-filter 'ement-room-send-org-filter))

;; Music Player
(use-package emms
  :bind (("C-c m p" . emms)
         ("C-c m n" . emms-next)
         ("C-c m b" . emms-previous))
  :config
  (require 'emms-setup)
  (emms-all)
  (emms-default-players)
  (setq emms-source-file-default-directory "~/Music/"))

;; RSS Reader
(use-package elfeed
  :bind ("C-c m r" . elfeed)
  :custom
  (elfeed-search-filter "@1-week-ago +unread")
  :config
  (setq elfeed-feeds
        '(("https://news.ycombinator.com/rss" tech hackernews)
          ("https://planet.emacslife.com/atom.xml" emacs tech))))

(use-package password-store
  :commands (password-store-copy password-store-insert))

(use-package transmission
  :commands transmission)

(use-package erc-hl-nicks
  :after erc
  :config
  (add-to-list 'erc-modules 'hl-nicks))

;; =============================================================================
;; 12. GIT INTEGRATION (THE OS VERSION CONTROL)
;; =============================================================================

(use-package magit
  :bind ("C-c g g" . magit-status)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  (magit-save-repository-buffers 'dontask)
  (magit-refs-show-commit-count 'all)
  (magit-log-margin '(t age-abbreviated magit-log-margin-width t 18)))

(use-package forge
  :after magit
  :custom
  (forge-add-default-bindings t))

(use-package diff-hl
  :hook ((magit-pre-refresh . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :config
  (global-diff-hl-mode)
  (diff-hl-flydiff-mode))

(use-package hl-todo
  :hook (prog-mode . hl-todo-mode)
  :custom
  (hl-todo-keyword-faces
   '(("TODO"   . "#cc9393")
     ("FIXME"  . "#cc9393")
     ("DEBUG"  . "#dca3a3")
     ("GOTCHA" . "#dca3a3")
     ("STUB"   . "#7cb8bb"))))

(use-package blamer
  :bind (("s-i" . blamer-show-commit-info))
  :custom
  (blamer-idle-time 0.3)
  (blamer-min-offset 70)
  :custom-face
  (blamer-face ((t :foreground "#7a88cf"
                   :background nil
                   :height 140
                   :italic t)))
  :config
  (global-blamer-mode 1))

(use-package git-timemachine
  :bind ("C-c g t" . git-timemachine))

(use-package git-gutter
  :config (global-git-gutter-mode +1))

(use-package git-gutter-fringe
  :config
  (define-fringe-bitmap 'git-gutter-fr:added [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:modified [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:deleted [128 192 224 240] nil nil 'bottom))

(use-package magit-todos
  :after magit
  :config (magit-todos-mode 1))

(use-package diffview
  :commands (diffview-current diffview-region diffview-message))

;; =============================================================================
;; 13. KEYBINDINGS, MACROS & DAEMON STARTUP
;; =============================================================================

(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-c e") 'treemacs)
(global-set-key (kbd "C-c t") 'vterm)
(global-set-key (kbd "C-c d") (lambda () (interactive) (switch-to-buffer "*dashboard*")))
(global-set-key (kbd "C-S-c") 'kill-ring-save)
(global-set-key (kbd "C-S-v") 'yank)

(global-set-key (kbd "C-x k") 'kill-current-buffer)
(global-set-key (kbd "C-x C-k") 'kill-buffer)
(global-set-key (kbd "C-c r") 'revert-buffer)
(global-set-key (kbd "C-c w c") 'delete-window)
(global-set-key (kbd "C-c w o") 'delete-other-windows)
(global-set-key (kbd "C-c w s") 'split-window-below)
(global-set-key (kbd "C-c w v") 'split-window-right)

;; Explicitly clear any existing binding for C-c m
(global-unset-key (kbd "C-c m"))

;; Create a dedicated prefix map for your applications
(define-prefix-command 'my-apps-map)
(global-set-key (kbd "C-c m") 'my-apps-map)

;; Assign your apps to the new prefix
(define-key my-apps-map (kbd "m") 'mu4e)               ; C-c m m
(define-key my-apps-map (kbd "e") 'mu4e-compose-new)   ; C-c m e
(define-key my-apps-map (kbd "p") 'emms)               ; C-c m p
(define-key my-apps-map (kbd "c") 'ement-connect)      ; C-c m c
(define-key my-apps-map (kbd "r") 'elfeed)             ; C-c m r

;; Ensure Dashboard is aggressively enforced on start
(setq initial-buffer-choice (lambda ()
                              (dashboard-refresh-buffer)
                              (get-buffer "*dashboard*")))

(add-hook 'server-after-make-frame-hook
          (lambda ()
            (set-face-attribute 'default nil :family "Iosevka Nerd Font" :height 100 :weight 'normal)
            (set-face-attribute 'fixed-pitch nil :family "Iosevka Nerd Font" :height 100)
            (set-face-attribute 'variable-pitch nil :family "Iosevka Nerd Font" :height 110 :weight 'regular)
            (set-fontset-font t 'symbol (font-spec :family "Symbols Nerd Font Mono") nil 'append)
            (custom-set-faces
             '(mode-line ((t (:background "#1e2124" :foreground "#d3d7dc"))))
             '(mode-line-inactive ((t (:background "#16181a" :foreground "#5c6370")))))
            (unless (get-buffer-window "*dashboard*")
              (dashboard-refresh-buffer)
              (switch-to-buffer "*dashboard*"))))

(provide 'init)
;;; init.el ends here
