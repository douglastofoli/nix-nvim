{ config, ... }:
{
  flake.nixNvimModules.plugins.navigation.which-key = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [ "which-key-nvim" ];

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
          rhs = "<cmd>Neotree toggle filesystem left reveal<cr>";
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
          rhs = "<cmd>Neotree focus filesystem left<cr>";
          opts = {
            desc = "Focus file explorer";
          };
        }

        # Git (g = group; gitsigns: n/p hunk nav, h preview, S stage, u undo, b blame, d diff, R reset)
        {
          lhs = "<leader>gs";
          rhs = "<cmd>Neotree float git_status<cr>";
          opts = {
            desc = "Git status";
          };
        }
        {
          lhs = "<leader>ge";
          rhs = "<cmd>Neotree reveal<cr>";
          opts = {
            desc = "Reveal in tree";
          };
        }
        {
          lhs = "<leader>gn";
          rhsLua = "function() require('gitsigns').next_hunk() end";
          opts = {
            desc = "Next hunk";
          };
        }
        {
          lhs = "<leader>gp";
          rhsLua = "function() require('gitsigns').prev_hunk() end";
          opts = {
            desc = "Prev hunk";
          };
        }
        {
          lhs = "<leader>gh";
          rhsLua = "function() require('gitsigns').preview_hunk_inline() end";
          opts = {
            desc = "Preview hunk";
          };
        }
        {
          lhs = "<leader>gS";
          rhsLua = "function() require('gitsigns').stage_hunk() end";
          opts = {
            desc = "Stage hunk";
          };
        }
        {
          lhs = "<leader>gu";
          rhsLua = "function() require('gitsigns').undo_stage_hunk() end";
          opts = {
            desc = "Undo stage hunk";
          };
        }
        {
          lhs = "<leader>gb";
          rhsLua = "function() require('gitsigns').toggle_current_line_blame() end";
          opts = {
            desc = "Blame line";
          };
        }
        {
          lhs = "<leader>gd";
          rhsLua = "function() require('gitsigns').diffthis() end";
          opts = {
            desc = "Diff this file";
          };
        }
        {
          lhs = "<leader>gR";
          rhsLua = "function() require('gitsigns').reset_hunk() end";
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
          rhs = "<cmd>Neotree toggle buffers right<cr>";
          opts = {
            desc = "Buffer sidebar";
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
