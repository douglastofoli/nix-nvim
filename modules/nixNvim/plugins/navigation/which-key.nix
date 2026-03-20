{config, ...}: {
  flake.nixNvimModules.plugins.navigation.which-key = {
    imports = [config.flake.nixNvimModules.plugin];

    enable = true;

    pluginNames = ["which-key-nvim"];

    keymaps = {
      whichKeyGroups = [
        {
          prefix = "<leader>b";
          group = "buffers";
        }
        {
          prefix = "<leader>c";
          group = "code";
        }
        {
          prefix = "<leader>d";
          group = "debug";
        }
        {
          prefix = "<leader>f";
          group = "files";
        }
        {
          prefix = "<leader>g";
          group = "git";
        }
        {
          prefix = "<leader>p";
          group = "projects";
        }
        {
          prefix = "<leader>s";
          group = "search";
        }
        {
          prefix = "<leader>t";
          group = "toggles";
        }
        {
          prefix = "<leader>w";
          group = "windows";
        }
      ];

      nnoremap = [
        # Files
        {
          lhs = "<leader>ff";
          rhs = "<cmd>Telescope find_files<cr>";
          opts = {
            desc = "Find file";
          };
        }
        {
          lhs = "<leader>fr";
          rhs = "<cmd>Telescope oldfiles<cr>";
          opts = {
            desc = "Recent files";
          };
        }
        {
          lhs = "<leader>fe";
          rhsLua = "function() local oil = NixNvim.safe_require('oil'); if oil then oil.open() end end";
          opts = {
            desc = "File explorer";
          };
        }
        {
          lhs = "<leader>fw";
          rhs = "<cmd>w<cr>";
          opts = {
            desc = "Save buffer";
          };
        }
        {
          lhs = "<leader>fE";
          rhsLua = "function() local oil = NixNvim.safe_require('oil'); if oil then oil.toggle_float() end end";
          opts = {
            desc = "Focus file explorer";
          };
        }

        # Git (g = group; gitsigns: n/p hunk nav, h preview, S stage, u undo, b blame, d diff, R reset)
        {
          lhs = "<leader>gs";
          rhsLua = "function() local oil = NixNvim.safe_require('oil'); if oil then oil.toggle_float() end end";
          opts = {
            desc = "File explorer (float)";
          };
        }
        {
          lhs = "<leader>ge";
          rhsLua = "function() local oil = NixNvim.safe_require('oil'); if oil then oil.open() end end";
          opts = {
            desc = "Reveal in oil";
          };
        }
        {
          lhs = "<leader>gn";
          rhsLua = "function() local gs = NixNvim.safe_require('gitsigns'); if gs then gs.next_hunk() end end";
          opts = {
            desc = "Next hunk";
          };
        }
        {
          lhs = "<leader>gp";
          rhsLua = "function() local gs = NixNvim.safe_require('gitsigns'); if gs then gs.prev_hunk() end end";
          opts = {
            desc = "Prev hunk";
          };
        }
        {
          lhs = "<leader>gh";
          rhsLua = "function() local gs = NixNvim.safe_require('gitsigns'); if gs then gs.preview_hunk_inline() end end";
          opts = {
            desc = "Preview hunk";
          };
        }
        {
          lhs = "<leader>gS";
          rhsLua = "function() local gs = NixNvim.safe_require('gitsigns'); if gs then gs.stage_hunk() end end";
          opts = {
            desc = "Stage hunk";
          };
        }
        {
          lhs = "<leader>gu";
          rhsLua = "function() local gs = NixNvim.safe_require('gitsigns'); if gs then gs.undo_stage_hunk() end end";
          opts = {
            desc = "Undo stage hunk";
          };
        }
        {
          lhs = "<leader>gb";
          rhsLua = "function() local gs = NixNvim.safe_require('gitsigns'); if gs then gs.toggle_current_line_blame() end end";
          opts = {
            desc = "Blame line";
          };
        }
        {
          lhs = "<leader>gd";
          rhsLua = "function() local gs = NixNvim.safe_require('gitsigns'); if gs then gs.diffthis() end end";
          opts = {
            desc = "Diff this file";
          };
        }
        {
          lhs = "<leader>gR";
          rhsLua = "function() local gs = NixNvim.safe_require('gitsigns'); if gs then gs.reset_hunk() end end";
          opts = {
            desc = "Reset hunk";
          };
        }

        # Search
        {
          lhs = "<leader>sf";
          rhs = "<cmd>Telescope find_files<cr>";
          opts = {
            desc = "Find files";
          };
        }
        {
          lhs = "<leader>sg";
          rhs = "<cmd>Telescope live_grep<cr>";
          opts = {
            desc = "Live grep";
          };
        }
        {
          lhs = "<leader>sb";
          rhs = "<cmd>Telescope buffers<cr>";
          opts = {
            desc = "Buffers";
          };
        }
        {
          lhs = "<leader>sh";
          rhs = "<cmd>Telescope help_tags<cr>";
          opts = {
            desc = "Help tags";
          };
        }
        {
          lhs = "<leader>sr";
          rhs = "<cmd>Telescope resume<cr>";
          opts = {
            desc = "Resume last";
          };
        }

        # Buffers
        {
          lhs = "<leader>bl";
          rhs = "<cmd>Telescope buffers<cr>";
          opts = {
            desc = "List buffers";
          };
        }
        {
          lhs = "<leader>bn";
          rhs = "<cmd>bnext<cr>";
          opts = {
            desc = "Next buffer";
          };
        }
        {
          lhs = "<leader>bp";
          rhs = "<cmd>bprevious<cr>";
          opts = {
            desc = "Previous buffer";
          };
        }
        {
          lhs = "<leader>bd";
          rhs = "<cmd>bdelete<cr>";
          opts = {
            desc = "Delete buffer";
          };
        }
        {
          lhs = "<leader>bb";
          rhs = "<cmd>Telescope buffers<cr>";
          opts = {
            desc = "Buffers";
          };
        }

        # Windows
        {
          lhs = "<leader>wv";
          rhs = "<cmd>vsplit<cr>";
          opts = {
            desc = "Split vertical";
          };
        }
        {
          lhs = "<leader>ws";
          rhs = "<cmd>split<cr>";
          opts = {
            desc = "Split horizontal";
          };
        }
        {
          lhs = "<leader>wh";
          rhs = "<c-w>h";
          opts = {
            desc = "Go left";
          };
        }
        {
          lhs = "<leader>wl";
          rhs = "<c-w>l";
          opts = {
            desc = "Go right";
          };
        }
        {
          lhs = "<leader>wj";
          rhs = "<c-w>j";
          opts = {
            desc = "Go down";
          };
        }
        {
          lhs = "<leader>wk";
          rhs = "<c-w>k";
          opts = {
            desc = "Go up";
          };
        }
        {
          lhs = "<leader>wc";
          rhs = "<cmd>close<cr>";
          opts = {
            desc = "Close window";
          };
        }
        {
          lhs = "<leader>wo";
          rhs = "<cmd>only<cr>";
          opts = {
            desc = "Only this window";
          };
        }

        # Projects
        {
          lhs = "<leader>pf";
          rhs = "<cmd>Telescope find_files cwd=vim.fn.getcwd()<cr>";
          opts = {
            desc = "Find in cwd";
          };
        }
        {
          lhs = "<leader>pr";
          rhs = "<cmd>Telescope oldfiles<cr>";
          opts = {
            desc = "Recent files";
          };
        }

        # Code / LSP
        {
          lhs = "<leader>cr";
          rhsLua = "vim.lsp.buf.rename";
          opts = {
            desc = "Rename";
          };
        }
        {
          lhs = "<leader>ca";
          rhsLua = "vim.lsp.buf.code_action";
          opts = {
            desc = "Code action";
          };
        }
        {
          lhs = "<leader>cd";
          rhsLua = "vim.lsp.buf.definition";
          opts = {
            desc = "Go to definition";
          };
        }
        {
          lhs = "<leader>cD";
          rhsLua = "vim.lsp.buf.declaration";
          opts = {
            desc = "Go to declaration";
          };
        }
        {
          lhs = "<leader>ci";
          rhsLua = "vim.lsp.buf.implementation";
          opts = {
            desc = "Go to implementation";
          };
        }
        {
          lhs = "<leader>cR";
          rhsLua = "vim.lsp.buf.references";
          opts = {
            desc = "References";
          };
        }
        {
          lhs = "<leader>ce";
          rhsLua = "vim.diagnostic.open_float";
          opts = {
            desc = "Diagnostic float";
          };
        }
        {
          lhs = "<leader>cp";
          rhsLua = "vim.diagnostic.goto_prev";
          opts = {
            desc = "Prev diagnostic";
          };
        }
        {
          lhs = "<leader>cn";
          rhsLua = "vim.diagnostic.goto_next";
          opts = {
            desc = "Next diagnostic";
          };
        }
      ];
    };

    extraLua = ''
      require("which-key").setup({
        delay = 200,
        triggers = { "<leader>" },
        icons = { group = "", separator = " " },
        win = { border = "rounded", padding = { 1, 2 } },
      })
    '';
  };
}
