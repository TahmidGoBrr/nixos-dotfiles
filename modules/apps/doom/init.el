;;; init.el -*- lexical-binding: t; -*-
(doom! :input
       :completion
       (corfu +orderless)   ; Fast autocomplete (blink-cmp equivalent)
       (vertico +icons)     ; Fuzzy searching & action menus

       :ui
       dashboard       ; Dashboard on launch
       modeline        ; Modeline
       doom-entangles
       hl-todo              ; Highlight TODO, FIXME, etc.
       indent-guides        ; Indent guides
       ophints              ; Visual operation hints
       (popup +defaults)    
       tabs                 ; Centaur-tabs buffer bar
       (treemacs +lsp)      ; File tree explorer
       (vc-gutter +diff-hl) ; Diff signs in fringe
       vi-tilde-fringe
       workspaces

       :editor
       (evil +everywhere)   ; Full Vim integration
       file-templates
       fold
       (format +onsave)     ; Async format on save
       multiple-cursors
       snippets             ; Yasnippet engine
       word-wrap

       :emacs
       (dired +icons)
       (undo +tree)         ; Undo-tree navigation
       vc

       :term
       vterm

       :tools
       (debugger +lsp)      ; DAP debugger
       direnv               ; Envrc integration
       docker
       editorconfig
       (eval +overlay)
       lookup
       magit                ; Git client
       make

       :lang
       ;; Full Tree-sitter and LSP configuration
       (cc +lsp +treesitter)
       (elixir +lsp +treesitter)
       (go +lsp +treesitter)
       (javascript +lsp +treesitter)
       (json +lsp +treesitter)
       (lua +lsp +treesitter)
       (markdown +treesitter)
       (nix +lsp +treesitter)
       (python +lsp +treesitter +pyright)
       (rust +lsp +treesitter)
       (sh +lsp +treesitter)
       (typescript +lsp +treesitter)
       (web +lsp +treesitter)
       (yaml +lsp +treesitter)

       :config
       (default +bindings +smartparens))
