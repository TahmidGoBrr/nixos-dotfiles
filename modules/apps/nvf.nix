{pkgs, ...}: {
  programs.nvf = {
    enable = true;

    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;
        preventJunkFiles = true;
        lineNumberMode = "relNumber";
        clipboard.registers = "unnamedplus";
        undoFile.enable = true;
        utility.undotree.enable = true;
        tabline.nvimBufferline.enable = true;
        dashboard.alpha.enable = true;
        filetree.neo-tree.enable = true;
        telescope.enable = true;
        projects.project-nvim.enable = true;
        notes.todo-comments.enable = true;
        comments.comment-nvim.enable = true;
        opts = {
          tabstop = 2;
          shiftwidth = 2;
          softtabstop = 2;
          expandtab = true;
          smartindent = true;
          wrap = false;
          cursorline = true;
          termguicolors = true;
          scrolloff = 8;
          sidescrolloff = 8;
          updatetime = 250;
          timeoutlen = 300;
          signcolumn = "yes";
        };
        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
        };
        ui = {
          noice.enable = true;
          fastaction.enable = true;
          illuminate.enable = true;
          colorizer.enable = true;
          breadcrumbs = {
            enable = true;
            navbuddy.enable = true;
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
          cinnamon-nvim.enable = true;
          fidget-nvim.enable = true;
          highlight-undo.enable = true;
          indent-blankline.enable = true;
          nvim-scrollbar.enable = true;
          rainbow-delimiters.enable = true;
        };
        statusline.lualine = {
          enable = true;
          theme = "auto";
        };
        lsp = {
          enable = true;
          formatOnSave = true;
          lightbulb.enable = true;
          lspsaga.enable = true;
          trouble.enable = true;
          lspSignature.enable = false;
          otter-nvim.enable = true;
          nvim-docs-view.enable = true;
          presets.harper.enable = true;
        };
        debugger = {
          nvim-dap = {
            enable = true;
            ui.enable = true;
          };
        };
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
        treesitter = {
          enable = true;
          fold = true;
          context.enable = true;
          autotagHtml = true;
          textobjects.enable = true;
        };
        languages = {
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;
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
          assembly.enable = true;
          clang.enable = true;
          rust.enable = true;
          zig.enable = true;
          bash.enable = true;
          lua.enable = true;
          nu.enable = true;
          python = {
            enable = true;
            format.type = ["black"];
          };
          java.enable = true;
          kotlin.enable = true;
          scala.enable = true;
          elixir.enable = true;
          go.enable = true;
          cmake.enable = true;
          glsl.enable = true;
          markdown.enable = true;
          nix = {
            enable = true;
            format.type = ["alejandra"];
          };
          sql.enable = true;
          typst.enable = true;
          yaml.enable = true;
          arduino.enable = true;
          csharp.enable = true;
        };
        git = {
          enable = true;
          gitsigns = {
            enable = true;
            codeActions.enable = true;
          };
        };
        utility = {
          preview.markdownPreview.enable = true;
          surround.enable = true;
          motion.flash-nvim.enable = true;
          outline.aerial-nvim.enable = true;
          diffview-nvim.enable = true;
          grug-far-nvim.enable = true;
        };
        terminal = {
          toggleterm = {
            enable = true;
            lazygit.enable = true;
          };
        };
        binds = {
          whichKey.enable = true;
          cheatsheet.enable = true;
        };
        globals = {
          mapleader = " ";
          maplocalleader = ",";
        };
        keymaps = [
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
