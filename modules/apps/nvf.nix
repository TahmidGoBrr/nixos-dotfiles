{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    beamPackages.elixir
  ];
  programs.nvf = {
    enable = true;

    settings = {
      vim = {
        # =====================================================================
        # Core & General Settings
        # =====================================================================
        viAlias = true;
        vimAlias = true;
        preventJunkFiles = true; # Disable swap, undo, and backup files
        lineNumberMode = "relNumber"; # Relative line numbers
        clipboard.registers = "unnamedplus";

        undoFile.enable = true; # Keeps undo history saved across buffer/neovim restarts
        utility.undotree.enable = true; # Visualizes the undo tree (<leader>u)

        globals = {
          mapleader = " "; # Set Space as global leader key
          maplocalleader = ",";
        };

        opts = {
          tabstop = 2;
          shiftwidth = 2;
          softtabstop = 2;
          expandtab = true;
          smartindent = true;
          wrap = false;
          cursorline = true;
          termguicolors = true;
          scrolloff = 8; # Keep 8 lines above/below cursor
          sidescrolloff = 8;
          updatetime = 250; # Faster completion & diagnostic updates
          timeoutlen = 300; # Speed up which-key popups
          signcolumn = "yes"; # Always show sign column
        };

        # =====================================================================
        # Theme
        # =====================================================================
        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
        };

        # =====================================================================
        # UI & Visual Enhancements
        # =====================================================================
        ui = {
          noice.enable = true; # Modern replacement for cmdline, search, & popups
          fastaction.enable = true; # Fast code-action picker
          illuminate.enable = true;
          colorizer.enable = true;
          breadcrumbs = {
            enable = true;
            navbuddy.enable = true; # Interactive popup to navigate code structure using AST
          };
          smartcolumn = {
            enable = true;
            setupOpts.custom_colorcolumn = {
              nix = "110";
              python = "88";
              javascript = "100";
            };
          };
        };

        visuals = {
          nvim-web-devicons.enable = true;
          nvim-cursorline.enable = true;
          cinnamon-nvim.enable = true; # Smooth scrolling
          fidget-nvim.enable = true; # LSP progress notifications
          highlight-undo.enable = true; # Visual highlight on undo/redo/paste
          indent-blankline.enable = true; # Visual indent guides
          nvim-scrollbar.enable = true; # Scrollbar with diagnostic marks
          rainbow-delimiters.enable = true; # Colored nested brackets
        };

        statusline.lualine = {
          enable = true;
          theme = "auto";
        };

        tabline.nvimBufferline = {
          enable = true;
        };

        dashboard = {
          alpha.enable = true; # Animated startup screen
        };

        # =====================================================================
        # LSP, Diagnostics & Formatting
        # =====================================================================
        lsp = {
          enable = true;
          formatOnSave = true;
          lightbulb.enable = true; # Code-action lightbulb indicator
          lspsaga.enable = true; # Enhanced LSP UI (hover windows, rename)
          trouble.enable = true; # Pretty list window for errors/warnings
          lspSignature.enable = false; # Display signature details as you type
          otter-nvim.enable = true; # LSP completion inside embedded code blocks
          nvim-docs-view.enable = true; # Hover documentation in a split panel
          presets.harper.enable = true; # Grammar checking LSP preset
        };

        # Debugger (DAP)
        debugger = {
          nvim-dap = {
            enable = true;
            ui.enable = true;
          };
        };

        # Auto-completion & Snippets
        autocomplete = {
          blink-cmp = {
            enable = true;
            setupOpts = {
              signature.enabled = true;
            };
          };
        };

        snippets = {
          luasnip.enable = true;
        };

        # Treesitter Syntax Engine
        treesitter = {
          enable = true;
          fold = true;
          context.enable = true; # Sticky header showing current class/function scope
          autotagHtml = true;
          textobjects.enable = true; # Select/navigate function & class blocks
        };

        # =====================================================================
        # Supported Language Modules, LSPs & Formatters
        # =====================================================================
        languages = {
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;

          # Web Development
          astro.enable = true;
          css.enable = true;
          html.enable = true;
          json.enable = true;
          scss.enable = true;
          typescript = {
            enable = true;
            extensions.ts-error-translator.enable = true;
            format.type = ["prettier"];
          };

          # Systems & Low Level
          assembly.enable = true;
          clang.enable = true;
          rust.enable = true;
          zig.enable = true;

          # Scripting & Dynamic Languages
          bash.enable = true;
          lua.enable = true;
          nu.enable = true; # Nushell
          python = {
            enable = true;
            format.type = ["black"];
          };

          # JVM & Enterprise
          java.enable = true;
          kotlin.enable = true;
          scala.enable = true;

          # Functional & Modern Languages
          elixir.enable = true;
          go.enable = true;

          # Config, Markup & Build Systems
          cmake.enable = true;
          glsl.enable = true;
          markdown.enable = true;
          nix = {
            enable = true;
            format.type = ["alejandra"]; # Standard opinionated Nix formatter
          };
          sql.enable = true;
          typst.enable = true;
          yaml.enable = true;

          # Additional Languages
          arduino.enable = true;
          csharp.enable = true;
        };

        # =====================================================================
        # File Navigation, Search & Projects
        # =====================================================================
        filetree = {
          neo-tree = {
            enable = true;
          };
        };

        telescope.enable = true;

        projects = {
          project-nvim.enable = true; # Automatic root directory detection
        };

        # =====================================================================
        # Git Integration
        # =====================================================================
        git = {
          enable = true;
          gitsigns = {
            enable = true;
            codeActions.enable = true; # Quick stage/reset hunks in code-action menu
          };
        };

        # =====================================================================
        # Productivity, Motion & Tools
        # =====================================================================
        utility = {
          preview = {
            markdownPreview.enable = true;
          };
          surround.enable = true; # Add/change/delete quotes and brackets
          motion.flash-nvim.enable = true; # Fast jumper search motion
          outline.aerial-nvim.enable = true; # Outline sidebar for workspace symbols
          diffview-nvim.enable = true; # Visual git diff tool
          grug-far-nvim.enable = true; # Incredibly fast project-wide search & replace UI
        };

        notes = {
          todo-comments.enable = true; # Highlight TODO, FIX, and HACK annotations
        };

        comments = {
          comment-nvim.enable = true;
        };

        terminal = {
          toggleterm = {
            enable = true;
            lazygit.enable = true; # Integrated Lazygit terminal popup
          };
        };

        # =====================================================================
        # Keybindings & Navigation Shortcuts
        # =====================================================================
        binds = {
          whichKey.enable = true;
          cheatsheet.enable = true;
        };

        keymaps = [
          # Window Split Navigation
          {
            key = "<C-h>";
            action = "<C-w>h";
            mode = "n";
            desc = "Focus Left Window";
          }
          {
            key = "<C-j>";
            action = "<C-w>j";
            mode = "n";
            desc = "Focus Down Window";
          }
          {
            key = "<C-k>";
            action = "<C-w>k";
            mode = "n";
            desc = "Focus Up Window";
          }
          {
            key = "<C-l>";
            action = "<C-w>l";
            mode = "n";
            desc = "Focus Right Window";
          }

          # Buffer Navigation
          {
            key = "<Shift-h>";
            action = ":BufferLineCyclePrev<CR>";
            mode = "n";
            desc = "Previous Buffer";
          }
          {
            key = "<Shift-l>";
            action = ":BufferLineCycleNext<CR>";
            mode = "n";
            desc = "Next Buffer";
          }
          {
            key = "<leader>bd";
            action = ":bdelete<CR>";
            mode = "n";
            desc = "Close Current Buffer";
          }

          # File Tree & Git Shortcuts
          {
            key = "<leader>e";
            action = ":Neotree toggle<CR>";
            mode = "n";
            desc = "Toggle Neo-tree";
          }
          {
            key = "<leader>gg";
            action = ":Lazygit<CR>";
            mode = "n";
            desc = "Open Lazygit";
          }

          # Quick Save
          {
            key = "<C-s>";
            action = ":w<CR>";
            mode = ["n" "i" "v"];
            desc = "Save File";
          }
        ];
      };
    };
  };
}
