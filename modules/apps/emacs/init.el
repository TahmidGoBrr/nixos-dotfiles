;;; init.el --- The Ultimate Emacs OS Configuration -*- lexical-binding: t; -*-

;; =============================================================================
;; 1. CORE ENGINE PERFORMANCE & OS-LEVEL GLOBAL OPTIONS
;; =============================================================================

;; Force use-package to NOT download packages (Nix handles this declaratively)
(require 'use-package)
(setq use-package-always-ensure nil)

;; Optimize Garbage Collection for Startup
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
              word-wrap nil
              fill-column 80
              sentence-end-double-space nil
              bidi-display-reordering nil
              cursor-type 'box
              blink-cursor-interval 0.4)

(setq display-line-numbers-type 'relative
      inhibit-startup-screen t
      inhibit-startup-message t
      initial-scratch-message ";; Welcome to Emacs OS.\n\n"
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

;; Directories (Dynamically routed to prevent XDG vs home directory conflicts)
(defvar my-backup-dir (locate-user-emacs-file "backups/"))
(defvar my-autosave-dir (locate-user-emacs-file "autosaves/"))
(defvar my-undo-dir (locate-user-emacs-file "undo/"))

(unless (file-exists-p my-backup-dir) (make-directory my-backup-dir t))
(unless (file-exists-p my-autosave-dir) (make-directory my-autosave-dir t))
(unless (file-exists-p my-undo-dir) (make-directory my-undo-dir t))

(setq backup-directory-alist `(("." . ,my-backup-dir))
      auto-save-file-name-transforms `((".*" ,my-autosave-dir t)))

;; Global Modes
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

;; Load VLF safely
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

;; Set core font to Iosevka Nerd Font for perfect Wayland/Hyprland rendering
(set-face-attribute 'default nil :family "Iosevka Nerd Font" :height 120 :weight 'normal)
(set-face-attribute 'fixed-pitch nil :family "Iosevka Nerd Font" :height 120)
(set-face-attribute 'variable-pitch nil :family "Iosevka Nerd Font" :height 130 :weight 'regular)
(set-fontset-font t 'symbol (font-spec :family "Symbols Nerd Font Mono") nil 'append)

;; Safely apply the Compline Neutral Dark Theme globally
(let ((bg0     "#16181a")  
      (bg1     "#1e2124")  
      (bg2     "#282c30")  
      (fg0     "#ffffff")  
      (fg1     "#d3d7dc")  
      (muted   "#5c6370")  
      (border  "#282c30")  
      (accent  "#8f99a3")) 
  (custom-set-faces
   `(default ((t (:background ,bg0 :foreground ,fg1))))
   `(fringe ((t (:background ,bg0))))
   `(line-number ((t (:background ,bg0 :foreground ,muted))))
   `(line-number-current-line ((t (:background ,bg1 :foreground ,fg0 :weight bold))))
   `(mode-line ((t (:background ,bg1 :foreground ,fg1 :box (:line-width 1 :color ,border)))))
   `(mode-line-inactive ((t (:background ,bg0 :foreground ,muted :box (:line-width 1 :color ,border)))))
   `(vertical-border ((t (:foreground ,border))))
   `(window-divider ((t (:foreground ,border))))
   `(cursor ((t (:background ,fg0 :foreground ,bg0))))
   `(region ((t (:background ,bg2 :foreground ,fg0))))
   `(highlight ((t (:background ,bg2))))
   `(hl-line ((t (:background ,bg1))))
   `(minibuffer-prompt ((t (:foreground ,fg0 :weight bold))))
   `(font-lock-comment-face ((t (:foreground ,muted :italic t))))
   `(font-lock-doc-face ((t (:foreground ,muted))))
   `(font-lock-string-face ((t (:foreground ,fg1))))
   `(font-lock-keyword-face ((t (:foreground ,fg0 :weight bold))))
   `(font-lock-function-name-face ((t (:foreground ,fg0))))
   `(font-lock-variable-name-face ((t (:foreground ,fg1))))
   `(font-lock-type-face ((t (:foreground ,accent))))
   `(font-lock-constant-face ((t (:foreground ,accent))))))

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 32)
  (doom-modeline-bar-width 4)
  (doom-modeline-buffer-file-name-style 'truncate-upto-project)
  (doom-modeline-buffer-state-icon t)
  (doom-modeline-buffer-modification-icon t)
  (doom-modeline-minor-modes nil)
  (doom-modeline-enable-word-count t)
  (doom-modeline-buffer-encoding t)
  (doom-modeline-indent-info nil)
  (doom-modeline-checker-simple-format t)
  (doom-modeline-vcs-max-length 12)
  (doom-modeline-env-version t))

(use-package centaur-tabs
  :demand t
  :config
  (centaur-tabs-mode t)
  (setq centaur-tabs-style "bar"
        centaur-tabs-height 32
        centaur-tabs-set-icons t
        centaur-tabs-gray-out-icons 'buffer
        centaur-tabs-set-bar 'left
        centaur-tabs-set-modified-marker t
        centaur-tabs-modified-marker "•"
        centaur-tabs-cycle-scope 'tabs)
  (centaur-tabs-headline-match)
  (defun my-hide-internal-tabs (buffer)
    (let ((name (string-trim (format "%s" buffer))))
      (or (string-prefix-p "*" name)
          (string-prefix-p "magit" name))))
  (setq centaur-tabs-hide-tab-function 'my-hide-internal-tabs)
  :bind
  ("C-<prior>" . centaur-tabs-backward)
  ("C-<next>" . centaur-tabs-forward)
  ("C-c t s" . centaur-tabs-counsel-switch-group))

(use-package minimap
  :bind ("C-c m" . minimap-mode)
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

(use-package spacious-padding
  :hook (after-init . spacious-padding-mode)
  :custom
  (spacious-padding-widths
   '( :internal-border-width 15
      :header-line-width 4
      :mode-line-width 6
      :tab-width 4
      :right-divider-width 1
      :scroll-bar-width 8)))

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
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (setq evil-collection-mode-list '(dashboard dired ibuffer magit vterm corfu vertico prodigy))
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
  :init
  (global-undo-tree-mode 1)
  :custom
  (undo-tree-history-directory-alist `(("." . ,my-undo-dir)))
  (undo-tree-visualizer-diff t)
  (undo-tree-visualizer-timestamps t)
  (undo-tree-enable-undo-in-region t)
  (undo-tree-auto-save-history t))

;; =============================================================================
;; 4. COMPLETION, SEARCH, NAVIGATION (THE OS SEARCH ENGINE)
;; =============================================================================

(use-package vertico
  :init (vertico-mode 1)
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
  :init (marginalia-mode 1)
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil)))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package corfu
  :init (global-corfu-mode 1)
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
         ("C-c m" . consult-mode-command)
         ("C-c k" . consult-kmacro)
         ("C-x M-:" . consult-complex-command)
         ("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x 5 b" . consult-buffer-other-frame)
         ("C-x r b" . consult-bookmark)
         ("C-x p b" . consult-project-buffer)
         ("M-y" . consult-yank-pop)
         ("<help> a" . consult-apropos)
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flycheck)
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-g o" . consult-outline)
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ("M-s d" . consult-find)
         ("M-s D" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s m" . consult-multi-occur)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ("M-s e" . consult-isearch-history))
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)
  (advice-add #'register-preview :override #'consult-register-window)
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  :config
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   :preview-key '(:debounce 0.4 any))
  (setq consult-narrow-key "<"))

(use-package consult-dir
  :bind (("C-x C-d" . consult-dir)
         :map vertico-map
         ("C-x C-d" . consult-dir)
         ("C-x C-j" . consult-dir-jump-file)))

(use-package embark
  :bind
  (("C-." . embark-act)
   ("C-;" . embark-dwim)
   ("C-h B" . embark-bindings))
  :init
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package avy
  :bind
  (("C-:" . avy-goto-char)
   ("C-'" . avy-goto-char-2)
   ("M-g f" . avy-goto-line)
   ("M-g w" . avy-goto-word-1)
   ("M-g e" . avy-goto-word-0))
  :config
  (setq avy-background t
        avy-all-windows t
        avy-timeout-seconds 0.3))

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
  :init
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
  ("C-c p b" . consult-projectile-switch-to-buffer)
  ("C-c p r" . consult-projectile-recentf))

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
  (lsp-completion-provider :none)
  (lsp-enable-snippet t)
  (lsp-file-watch-threshold 1500)
  (lsp-restart 'auto-restart)
  (lsp-keep-workspace-alive nil)
  (lsp-modeline-code-actions-enable t)
  (lsp-modeline-diagnostics-enable t)
  (lsp-modeline-workspace-status-enable t)
  (lsp-signature-auto-activate nil)
  (lsp-diagnostics-provider :flymake)
  :hook ((prog-mode . (lambda ()
                        (unless (derived-mode-p 'emacs-lisp-mode 'lisp-data-mode)
                          (lsp-deferred))))
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
  :init (envrc-global-mode))

(use-package direnv
  :config
  (direnv-mode))

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
  :init (yas-global-mode 1)
  :custom
  (yas-snippet-dirs '("~/.emacs.d/snippets")))

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
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (sh . t)
     (lua . t)
     (sql . t)))
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•")))))))

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

;; =============================================================================
;; 11. GIT INTEGRATION (THE OS VERSION CONTROL)
;; =============================================================================

(use-package magit
  :bind ("C-c g" . magit-status)
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
;; 12. KEYBINDINGS, MACROS & DAEMON STARTUP
;; =============================================================================

(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-c g") 'magit-status)
(global-set-key (kbd "C-c e") 'treemacs)
(global-set-key (kbd "C-c t") 'vterm)
(global-set-key (kbd "C-c d") 'dashboard-open)
(global-set-key (kbd "C-S-c") 'kill-ring-save)
(global-set-key (kbd "C-S-v") 'yank)

(global-set-key (kbd "C-x k") 'kill-current-buffer)
(global-set-key (kbd "C-x C-k") 'kill-buffer)
(global-set-key (kbd "C-c r") 'revert-buffer)
(global-set-key (kbd "C-c w c") 'delete-window)
(global-set-key (kbd "C-c w o") 'delete-other-windows)
(global-set-key (kbd "C-c w s") 'split-window-below)
(global-set-key (kbd "C-c w v") 'split-window-right)

(setq initial-buffer-choice (lambda ()
                              (dashboard-refresh-buffer)
                              (get-buffer "*dashboard*")))

(add-hook 'server-after-make-frame-hook
          (lambda ()
            (dashboard-refresh-buffer)
            (switch-to-buffer "*dashboard*")))

(provide 'init)
;;; init.el ends here
