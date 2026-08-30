;;; init.el --- Maxxed Out Emacs Config -*- lexical-binding: t; -*-

;; =============================================================================
;; 1. PERFORMANCE & BOOTSTRAPPING
;; =============================================================================

(require 'use-package)
(setq use-package-always-ensure nil)

;; Unbind garbage collection during init and maximize IPC read size
(setq gc-cons-threshold (* 500 1024 1024)
      read-process-output-max (* 1024 1024 200)
      fast-but-imprecise-scrolling t
      jit-lock-defer-time 0.01
      scroll-conservatively 101
      idle-update-delay 1.0)

;; Optimize Garbage Collection using GCMH
(use-package gcmh
  :init
  (setq gcmh-idle-delay 5
        gcmh-high-cons-threshold (* 100 1024 1024))
  :config
  (gcmh-mode 1))

;; Fast bidirectional text rendering for programming
(add-hook 'prog-mode-hook
          (lambda ()
            (setq-local bidi-display-reordering nil)
            (setq-local bidi-paragraph-direction 'left-to-right)))

;; Global Offsets & Formatting Defaults
(setq-default tab-width 2
              indent-tabs-mode nil
              standard-indent 2
              c-basic-offset 2
              js-indent-level 2
              typescript-indent-level 2
              css-indent-offset 2
              web-mode-markup-indent-offset 2
              web-mode-css-indent-offset 2
              web-mode-code-indent-offset 2
              python-indent-offset 2
              nix-indent-function 'nix-indent-line
              word-wrap nil
              fill-column 80
              sentence-end-double-space nil
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

;; Directory Isolation
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

(setq native-comp-async-report-warnings-errors 'silent)
(setq warning-suppress-types '((comp)))

(setq select-enable-clipboard t
      select-enable-primary t
      save-interprogram-paste-before-kill t)

(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; =============================================================================
;; 2. VISUAL STYLING, THEMING & DOOM DASHBOARD
;; =============================================================================

(menu-bar-mode -1)
(tool-bar-mode -1)
(tab-bar-mode -1)
(setq tab-bar-show nil)
(setq-default header-line-format nil)
(scroll-bar-mode -1)
(setq tooltip-mode -1)
(set-fringe-mode 10)

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (add-to-list 'custom-theme-load-path (expand-file-name "themes" user-emacs-directory))
  (load-theme 'doom-wilmersdorf t)
  (with-eval-after-load 'org
    (require 'doom-themes-ext-org)
    (doom-themes-org-config)))

(use-package doom-modeline
  :config (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 25)
  (doom-modeline-bar-width 4)
  (doom-modeline-icon t)
  (doom-modeline-major-mode-icon t)
  (doom-modeline-major-mode-color-icon t)
  (doom-modeline-window-number nil)
  (doom-modeline-buffer-file-name-style 'truncate-upto-project)
  (doom-modeline-icon-provider 'nerd-icons))

(use-package beacon
  :config (beacon-mode 1))

(use-package breadcrumb
  :config (breadcrumb-mode 1))

(use-package symbols-outline
  :commands symbols-outline-show)

(use-package origami
  :hook (prog-mode . origami-mode)
  :init
  (defface origami-fold-header-face
    '((t (:box (:line-width 1 :color "#5c6370"))))
    "Face used for origami fold headers."
    :group 'origami))

(use-package minions
  :config (minions-mode 1))

(use-package mixed-pitch
  :hook ((org-mode . mixed-pitch-mode))
  :config
  (dolist (face '(header-line
                  breadcrumb-face
                  breadcrumb-project-face
                  breadcrumb-imenu-face
                  org-block
                  org-block-begin-line
                  org-block-end-line
                  org-code
                  org-document-info-keyword
                  org-meta-line
                  org-modern-block-keyword
                  org-modern-tag
                  org-property-value
                  org-special-keyword
                  org-table
                  org-verbatim))
    (add-to-list 'mixed-pitch-fixed-pitch-faces face)))

(use-package dashboard
  :config
  (setq dashboard-startup-banner 'logo
        dashboard-center-content t
        dashboard-show-shortcuts nil
        dashboard-set-heading-icons t
        dashboard-set-file-icons t
        dashboard-set-navigator t
        dashboard-set-init-info t
        dashboard-banner-logo-title "Welcome to GNU Emacs."
        dashboard-items '((recents  . 5)
                          (projects . 5)
                          (bookmarks . 5)
                          (agenda . 5)))
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
;; 3. EVIL MODAL SYSTEM & DOOM-LIKE SPACE LEADER KEYBINDINGS
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
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (setq evil-collection-mode-list '(dashboard dired ibuffer magit vterm vertico))
  (evil-collection-init))

(use-package general
  :config
  (general-evil-setup t)
  (general-create-definer my-leader-def
    :states '(normal visual motion)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "C-SPC")

  (my-leader-def
    "."   '(consult-line :which-key "search buffer")
    ":"   '(execute-extended-command :which-key "M-x")

    "b"   '(:ignore t :which-key "buffer")
    "b b" '(consult-buffer :which-key "switch buffer")
    "b k" '(kill-buffer :which-key "kill buffer")
    "b d" '(dashboard-refresh-buffer :which-key "open dashboard")

    "f"   '(:ignore t :which-key "file")
    "f f" '(find-file :which-key "find file")
    "f r" '(consult-recent-file :which-key "recent files")

    "p"   '(:ignore t :which-key "project")
    "p p" '(consult-projectile-switch-project :which-key "switch project")
    "p f" '(consult-projectile-find-file :which-key "find project file")
    "p s" '(consult-ripgrep :which-key "search project")

    "c"   '(:ignore t :which-key "code")
    "c a" '(lsp-execute-code-action :which-key "code action")
    "c c" '(evilnc-comment-or-uncomment-lines :which-key "comment or uncomment")
    "c d" '(lsp-find-definition :which-key "jump to definition")
    "c e" '(consult-flycheck :which-key "diagnostics")
    "c f" '(apheleia-format-buffer :which-key "format buffer")
    "c l" '(consult-line :which-key "go to line")
    "c r" '(lsp-rename :which-key "rename")

    "c i" '(:ignore t :which-key "apply casing")
    "c i i" '(string-inflection-all-cycle :which-key "cycle through cases")
    "c i c" '(string-inflection-camelcase :which-key "camelcase")
    "c i k" '(string-inflection-kebab-case :which-key "kebabcase")
    "c i s" '(string-inflection-snake-case :which-key "snakecase")
    "c i s" '(string-inflection-snake-case :which-key "snakecase")

    "g"   '(:ignore t :which-key "git")
    "g g" '(magit-status :which-key "magit status")
    "g b" '(blamer-show-commit-info :which-key "git blame")
    "g t" '(git-timemachine :which-key "git timemachine")

    "o"   '(:ignore t :which-key "open")
    "o e" '(treemacs :which-key "treemacs explorer")

    "o w" '(:ignore t :which-key "cool stuff")
    "o w w" '(eww :which-key "open eww web")
    "o w m" '(emms :which-key "open emms media player")
    "o w n" '(elfeed :which-key "elfeed RSS")

    "o t" '(:ignore t :which-key "terminal")
    "o t v" '(vterm-toggle :which-key "vterm")
    "o t e" '(eat :which-key "eat")

    "d"   '(:ignore t :which-key "directories")
    "d t" '(dired-jump :which-key "open dired in this window")
    "d o" '(dired-jump-other-window :which-key "open dired in other window")
    "d d" '(consult-dir :which-key "consult directory")

    "n"   '(:ignore t :which-key "notes/org")
    "n a" '(org-agenda :which-key "org agenda")
    "n e" '(org-export-dispatch :which-key "org export")
    "n f" '(org-roam-node-find :which-key "find roam node")
    "n i" '(org-roam-node-insert :which-key "insert roam node")
    "n l" '(org-roam-buffer-toggle :which-key "toggle roam buffer")
    "n u" '(org-roam-ui-mode :which-key "org-roam UI")
    "n z" '(writeroom-mode :which-key "toggle zen mode")

    "w"   '(:ignore t :which-key "window")
    "w c" '(delete-window :which-key "close window")
    "w s" '(split-window-below :which-key "split horizontally")
    "w v" '(split-window-right :which-key "split vertically")
    "w e" '(treemacs-select-window :which-key "select treemacs window")
    "w w" '(ace-window :which-key "switch window")

    "y" '(:ignore t :which-key "misc")
    "y d" '(dape :which-key "dape")
    "y e" '(er/expand-region :which-key "select all in function")
    "y p" '(prodigy :which-key "prodigy")
    "y y" '(consult-yank-pop :which-key "paste from clipboard")))

(global-set-key (kbd "C-S-c") 'kill-ring-save)
(global-set-key (kbd "C-S-v") 'yank)

(use-package evil-surround
  :config (global-evil-surround-mode 1))

(use-package evil-nerd-commenter)

(use-package evil-goggles
  :config
  (evil-goggles-mode)
  (evil-goggles-use-diff-faces))

(use-package evil-matchit
  :config (global-evil-matchit-mode 1))

(use-package evil-anzu
  :after evil
  :config (require 'evil-anzu))

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
;; 4. COMPLETION ENGINE, SEARCH & DIAGNOSTICS
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
  :config (marginalia-mode 1))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package nerd-icons-completion
  :after marginalia
  :config
  (nerd-icons-completion-mode)
  :hook (marginalia-mode . nerd-icons-completion-marginalia-setup))

(use-package corfu
  :init
  (setq corfu-auto t
        corfu-auto-delay 0.05
        corfu-auto-prefix 2
        corfu-cycle t
        corfu-preselect 'prompt
        corfu-quit-no-match 'separator
        tab-always-indent 'complete)
  :hook
  ((prog-mode . corfu-mode)
   (text-mode . corfu-mode)
   (corfu-mode . corfu-popupinfo-mode)
   (corfu-mode . corfu-history-mode))
  :config
  (global-corfu-mode 1)
  :bind
  (:map corfu-map
        ("TAB" . corfu-next)
        ([tab] . corfu-next)
        ("S-TAB" . corfu-previous)
        ([backtab] . corfu-previous)
        ("RET" . corfu-insert)))

(use-package cape
  :init
  (defun my/setup-cape-capfs ()
    (add-to-list 'completion-at-point-functions #'cape-dabbrev t)
    (add-to-list 'completion-at-point-functions #'cape-file t)
    (add-to-list 'completion-at-point-functions #'cape-keyword t))
  :hook
  (prog-mode . my/setup-cape-capfs))

(use-package consult
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)
  (advice-add #'register-preview :override #'consult-register-window)
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  :config
  (setq consult-narrow-key "<"))

(use-package consult-dir)

(use-package ace-window
  :custom
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(use-package wgrep
  :custom (wgrep-auto-save-buffer t))

(use-package flycheck
  :config (global-flycheck-mode 1)
  :custom
  (flycheck-display-errors-delay 0.1)
  (flycheck-indication-mode 'right-fringe))

(use-package consult-flycheck)

(use-package smart-jump
  :config (smart-jump-setup-default-registers))

(use-package which-key
  :init (which-key-mode)
  :custom
  (which-key-idle-delay 0.2)
  (which-key-popup-type 'side-window)
  (which-key-side-window-location 'bottom)
  (which-key-side-window-max-height 0.25))

(use-package helpful
  :bind
  ([remap describe-function] . helpful-callable)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key] . helpful-key)
  ([remap describe-symbol] . helpful-symbol))

;; =============================================================================
;; 5. PROJECT TRACKING, WORKSPACES & FILE EXPLORER
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
  :bind (:map projectile-command-map
              ("p" . consult-projectile)
              ("f" . consult-projectile-find-file)
              ("d" . consult-projectile-find-dir)
              ("b" . consult-projectile-switch-to-buffer)))

(use-package ibuffer-projectile
  :hook (ibuffer . (lambda ()
                     (ibuffer-projectile-set-filter-groups)
                     (unless (eq ibuffer-sorting-mode 'alphabetic)
                       (ibuffer-do-sort-by-alphabetic)))))

(use-package projectile-ripgrep)

(use-package treemacs
  :custom
  (treemacs-width 35)
  (treemacs-is-never-other-window t)
  (treemacs-position 'right)
  (treemacs-silent-refresh t)
  (treemacs-silent-filewatch t)
  (treemacs-collapse-dirs 3)
  :config
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-fringe-indicator-mode 'always)
  (add-hook 'treemacs-mode-hook
            (lambda ()
              (text-scale-increase 1)
              (setq header-line-format nil)
              (setq display-line-numbers nil))))

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
  :custom
  (dired-listing-switches "-agho --group-directories-first")
  (dired-dwim-target t)
  (dired-auto-revert-buffer t)
  (dired-recursive-copies 'always)
  (dired-recursive-deletes 'top)
  (delete-by-moving-to-trash t)
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-up-directory
    "l" 'dired-find-file))

(use-package dired-open
  :config
  (setq dired-open-extensions '(("png" . "sxiv")
                                ("jpg" . "sxiv")
                                ("pdf" . "zathura"))))

(use-package peep-dired
  :after dired
  :bind (:map dired-mode-map
              ("P" . peep-dired))
  :config
  (setq peep-dired-cleanup-on-disable t))

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package eyebrowse
  :config
  (eyebrowse-mode t)
  (setq eyebrowse-new-workspace t))

;; =============================================================================
;; 6. HIGH-PERFORMANCE LSP & TREE-SITTER ENGINE
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
  (lsp-idle-delay 0.05)
  (lsp-log-io nil)
  (lsp-headerline-breadcrumb-enable t)
  (lsp-eldoc-render-all nil)
  (lsp-enable-symbol-highlighting t)
  (lsp-warn-no-matched-clients nil)
  (lsp-completion-provider :capf)
  (lsp-enable-snippet t)
  (lsp-file-watch-threshold 3000)
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
  (lsp-ui-doc-delay 0.2)
  (lsp-ui-doc-max-width 80)
  (lsp-ui-doc-max-height 30)
  (lsp-ui-doc-use-childframe t)
  (lsp-ui-sideline-enable t)
  (lsp-ui-sideline-show-diagnostics t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-sideline-show-code-actions t))

(use-package dape
  :custom
  (dape-buffer-window-arrangement 'right)
  (dape-inlay-hints t)
  (dape-cwd-fn 'projectile-project-root))

;; =============================================================================
;; 7. FORMATTING & REFACTORING ECOSYSTEM
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

  (setf (alist-get 'c-mode apheleia-mode-alist) 'clang-format)
  (setf (alist-get 'c-ts-mode apheleia-mode-alist) 'clang-format)
  (setf (alist-get 'c++-mode apheleia-mode-alist) 'clang-format)
  (setf (alist-get 'c++-ts-mode apheleia-mode-alist) 'clang-format)

  (setf (alist-get 'rust-mode apheleia-mode-alist) 'rustfmt)
  (setf (alist-get 'rust-ts-mode apheleia-mode-alist) 'rustfmt)

  (setf (alist-get 'go-mode apheleia-mode-alist) 'gofmt)
  (setf (alist-get 'go-ts-mode apheleia-mode-alist) 'gofmt)

  (setf (alist-get 'sh-mode apheleia-mode-alist) 'shfmt)
  (setf (alist-get 'bash-ts-mode apheleia-mode-alist) 'shfmt)

  (setf (alist-get 'elixir-mode apheleia-mode-alist) 'mix-format)
  (setf (alist-get 'elixir-ts-mode apheleia-mode-alist) 'mix-format)

  (setf (alist-get 'zig-mode apheleia-mode-alist) 'zigfmt)
  (setf (alist-get 'zig-ts-mode apheleia-mode-alist) 'zigfmt)

  (setf (alist-get 'haskell-mode apheleia-mode-alist) 'ormolu))

(use-package format-all
  :commands format-all-buffer)

(use-package smartparens
  :hook (prog-mode . smartparens-mode)
  :config (require 'smartparens-config))

(use-package expand-region)

(use-package ws-butler
  :hook ((prog-mode . ws-butler-mode)
         (text-mode . ws-butler-mode)))

(use-package aggressive-indent
  :hook (emacs-lisp-mode . aggressive-indent-mode))

(use-package super-save
  :config
  (super-save-mode +1)
  (setq super-save-auto-save-when-idle t
        super-save-idle-duration 3))

(use-package string-inflection)

;; =============================================================================
;; 8. TERMINAL & ENVIRONMENT
;; =============================================================================

(use-package vterm
  :commands vterm
  :custom
  (vterm-max-scrollback 100000)
  (vterm-kill-buffer-on-exit t)
  (vterm-timer-delay 0.01)
  :config
  (add-hook 'vterm-mode-hook
            (lambda ()
              (setq display-line-numbers nil)
              (when-let ((proc (get-buffer-process (current-buffer))))
                (set-process-query-on-exit-flag proc nil)))))

(use-package vterm-toggle
  :custom
  (vterm-toggle-fullscreen-p nil)
  :config
  (add-to-list 'display-buffer-alist
               '((lambda (buffer-or-name _)
                   (let ((buffer (get-buffer buffer-or-name)))
                     (with-current-buffer buffer
                       (or (equal major-mode 'vterm-mode)
                           (string-prefix-p vterm-buffer-name (buffer-name buffer))))))
                 (display-buffer-reuse-window display-buffer-at-bottom)
                 (reusable-frames . visible)
                 (window-height . 0.3))))

(use-package eat
  :commands eat
  :custom
  (eat-kill-buffer-on-exit t)
  (eat-buffer-maximum-size 100000)
  :config
  (add-to-list 'display-buffer-alist
               '((lambda (buffer-or-name _)
                   (let ((buffer (get-buffer buffer-or-name)))
                     (with-current-buffer buffer
                       (derived-mode-p 'eat-mode))))
                 (display-buffer-reuse-window display-buffer-at-bottom)
                 (reusable-frames . visible)
                 (window-height . 0.3)))
  (with-eval-after-load 'evil
    (evil-set-initial-state 'eat-mode 'insert))
  (add-hook 'eat-mode-hook
            (lambda ()
              (setq display-line-numbers nil)
              (when-let ((proc (get-buffer-process (current-buffer))))
                (set-process-query-on-exit-flag proc nil)))))

(use-package envrc
  :hook (after-init . envrc-global-mode)
  :config
  (setq envrc-none-state-as-error nil))

(use-package direnv
  :config
  (direnv-mode 1))

(use-package verb
  :hook (org-mode . verb-mode))

(use-package restclient
  :mode ("\\.http\\'" . restclient-mode)
  :hook (restclient-mode . display-line-numbers-mode))

(use-package prodigy)

(use-package yasnippet
  :config (yas-global-mode 1)
  :custom
  (yas-snippet-dirs (list (locate-user-emacs-file "snippets/")))
  :config
  (unless (file-exists-p (car yas-snippet-dirs))
    (make-directory (car yas-snippet-dirs) t)))

(use-package yasnippet-snippets)

(use-package eww
  :defer t
  :custom
  (eww-search-prefix "https://duckduckgo.com/html/?q=")
  (eww-auto-rename-buffer t)
  (shr-use-colors nil)
  (shr-use-fonts t)
  (shr-max-image-proportion 0.6)
  :hook
  (eww-mode . (lambda ()
                (setq display-line-numbers nil)
                (visual-line-mode 1))))

(use-package emms
  :commands (emms emms-play-file emms-play-directory emms-playlist-mode-go)
  :config
  (require 'emms-setup)
  (emms-all)
  (emms-default-players)
  :custom
  (emms-source-file-default-directory "~/Music/")
  (emms-playlist-default-major-mode 'emms-playlist-mode)
  (emms-show-format "NP: %s")
  :hook
  (emms-playlist-mode . (lambda ()
                          (setq display-line-numbers nil))))

(use-package elfeed
  :commands elfeed
  :custom
  (elfeed-db-directory (locate-user-emacs-file "elfeed/"))
  (elfeed-search-filter "@1-month-ago +unread")
  (elfeed-show-entry-switch 'display-buffer)
  :hook
  ((elfeed-search-mode elfeed-show-mode) . (lambda ()
                                             (setq display-line-numbers nil))))

(use-package elfeed-org
  :after (elfeed org)
  :config
  (elfeed-org)
  :custom
  (rmh-elfeed-org-files (list (concat org-directory "/elfeed.org"))))

;; =============================================================================
;; 9. MAJOR PROGRAMMING LANGUAGE MODES
;; =============================================================================

(use-package nix-mode
  :mode "\\.nix\\'"
  :hook (nix-mode . lsp-deferred))

(use-package c-mode
  :ensure nil
  :hook ((c-mode c++-mode c-ts-mode c++-ts-mode) . lsp-deferred))

(use-package rust-mode
  :mode "\\.rs\\'"
  :hook (rust-mode . lsp-deferred))

(use-package go-mode
  :mode "\\.go\\'"
  :hook (go-mode . lsp-deferred))

(use-package elixir-mode
  :mode "\\.exs?\\'"
  :hook (elixir-mode . lsp-deferred))

(use-package zig-mode
  :mode "\\.zig\\'"
  :hook (zig-mode . lsp-deferred))

(use-package kotlin-mode
  :mode "\\.kt\\'"
  :hook (kotlin-mode . lsp-deferred))

(use-package scala-mode
  :mode "\\.scala\\'"
  :hook (scala-mode . lsp-deferred))

(use-package haskell-mode
  :mode "\\.hs\\'"
  :hook (haskell-mode . lsp-deferred))

(use-package python
  :ensure nil
  :mode ("\\.py\\'" . python-mode)
  :hook (python-mode . lsp-deferred))

;; =============================================================================
;; 10. ORG MODE & ORG ROAM
;; =============================================================================

(use-package org
  :init
  (setq org-directory "~/Org")
  :hook ((org-mode . visual-line-mode))
  :custom
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
  (custom-set-faces
   '(org-level-1 ((t (:inherit outline-1 :height 1.35 :weight bold))))
   '(org-level-2 ((t (:inherit outline-2 :height 1.25 :weight bold))))
   '(org-level-3 ((t (:inherit outline-3 :height 1.15 :weight semi-bold))))
   '(org-level-4 ((t (:inherit outline-4 :height 1.1  :weight semi-bold))))
   '(org-level-5 ((t (:inherit outline-5 :height 1.05 :weight medium)))))
  (custom-theme-set-faces
   'user
   '(header-line ((t (:inherit fixed-pitch))))
   '(org-block ((t (:inherit fixed-pitch))))
   '(org-block-begin-line ((t (:inherit fixed-pitch))))
   '(org-block-end-line ((t (:inherit fixed-pitch))))
   '(org-code ((t (:inherit fixed-pitch))))
   '(org-table ((t (:inherit fixed-pitch))))
   '(org-verbatim ((t (:inherit fixed-pitch))))
   '(org-special-keyword ((t (:inherit fixed-pitch))))
   '(org-meta-line ((t (:inherit fixed-pitch))))
   '(org-checkbox ((t (:inherit fixed-pitch))))))


(unless (file-exists-p org-directory)
  (make-directory org-directory t))

(setq org-latex-pdf-process
      '("xelatex -interaction nonstopmode -output-directory %o %f"
        "xelatex -interaction nonstopmode -output-directory %o %f"))

(use-package org-modern
  :hook ((org-mode . org-modern-mode)
         (org-agenda-finalize . org-modern-agenda))
  :custom
  (org-modern-table t)
  (org-modern-variable-pitch t)
  (org-modern-block-name '(" " . " "))
  (org-modern-keyword t)
  (org-modern-timestamp t)
  (org-modern-statistics t)
  (org-modern-progress t)
  (org-modern-priority t)
  (org-modern-star
   '("◉" "○" "✸" "✿" "✤"))
  (org-modern-checkbox
   '((?X . "☑")
     (?- . "❍")
     (?\s . "☐")))
  (org-modern-fold-stars
   '(("▾" . "▸")
     ("▾" . "▸")
     ("▾" . "▸")
     ("▾" . "▸")))
  (org-modern-horizontal-rule (make-string 36 ?─)))

(use-package writeroom-mode
  :custom
  (writeroom-width 80)
  (writeroom-mode-line t)
  (writeroom-maximize-window t)
  (writeroom-fullscreen-effect 'maximized))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)
   (shell . t)
   (lua . t)
   (sql . t)
   (nix . t)))

(use-package org-super-agenda
  :hook (org-agenda-mode . org-super-agenda-mode))

(use-package org-roam
  :custom
  (org-roam-directory (file-truename "~/Org/Roam"))
  (org-roam-completion-everywhere t)
  :config
  (unless (file-exists-p org-roam-directory)
    (make-directory org-roam-directory t))
  (org-roam-db-autosync-mode))

(use-package olivetti
  :hook (org-mode . olivetti-mode)
  :custom
  (olivetti-body-width 80)
  (olivetti-recall-visual-line-mode-entry-state t))

(use-package org-roam-ui
  :after org-roam
  :custom
  (org-roam-ui-sync-theme t)
  (org-roam-ui-follow t)
  (org-roam-ui-update-on-save t))

(use-package pdf-tools
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :hook (pdf-view-mode . (lambda() (display-line-numbers-mode -1)))
  :config
  (pdf-tools-install t))

;; =============================================================================
;; 11. GIT INTEGRATION
;; =============================================================================

(use-package magit
  :commands magit-status
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
  :hook (prog-mode . hl-todo-mode))

(use-package blamer
  :bind (("s-i" . blamer-show-commit-info))
  :custom
  (blamer-idle-time 0.3)
  (blamer-min-offset 70)
  :custom-face
  (blamer-face ((t :foreground "#7a88cf" :height 140 :italic t)))
  :config
  (global-blamer-mode 1))

(use-package git-timemachine
  :commands git-timemachine)

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
;; 12. DAEMON INITIALIZATION & FONTS
;; =============================================================================

(setq initial-buffer-choice (lambda ()
                              (dashboard-refresh-buffer)
                              (get-buffer "*dashboard*")))

(add-hook 'server-after-make-frame-hook
          (lambda ()
            (set-face-attribute 'default nil :family "Iosevka Nerd Font" :height 100 :weight 'normal)
            (set-face-attribute 'fixed-pitch nil :family "Iosevka Nerd Font" :height 100)
            (set-face-attribute 'variable-pitch nil :family "Alegreya" :height 125 :weight 'regular)
            (set-fontset-font t 'symbol (font-spec :family "Symbols Nerd Font Mono") nil 'append)
            (unless (get-buffer-window "*dashboard*")
              (dashboard-open)
              (switch-to-buffer "*dashboard*"))))

(provide 'init)
;;; init.el ends here
