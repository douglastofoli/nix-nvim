{ config, ... }:
{
  flake.nixNvimModules.plugins.navigation.which-key = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [ "which-key-nvim" ];

    extraLua = ''
      require("which-key").setup({
        delay = 200,
        triggers = { "<leader>" },
        icons = { group = "", separator = " " },
        win = { border = "rounded", padding = { 1, 2 } },
      })

      -- Group labels (new which-key spec)
      require("which-key").add({
        { "<leader>b", group = "buffers" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "files" },
        { "<leader>g", group = "git" },
        { "<leader>p", group = "projects" },
        { "<leader>s", group = "search" },
        { "<leader>t", group = "toggles" },
        { "<leader>w", group = "windows" },
      })

      -- Files
      vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find file" })
      vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
      vim.keymap.set("n", "<leader>fe", "<cmd>Neotree toggle filesystem left reveal<cr>", { desc = "File explorer" })
      vim.keymap.set("n", "<leader>fE", "<cmd>Neotree focus filesystem left<cr>", { desc = "Focus file explorer" })
      vim.keymap.set("n", "<leader>fw", "<cmd>w<cr>", { desc = "Save buffer" })

      -- Git (g = group; gitsigns: n/p hunk nav, h preview, S stage, u undo, b blame, d diff, R reset)
      vim.keymap.set("n", "<leader>gs", "<cmd>Neotree float git_status<cr>", { desc = "Git status" })
      vim.keymap.set("n", "<leader>ge", "<cmd>Neotree reveal<cr>", { desc = "Reveal in tree" })
      vim.keymap.set("n", "<leader>gn", function() require("gitsigns").next_hunk() end, { desc = "Next hunk" })
      vim.keymap.set("n", "<leader>gp", function() require("gitsigns").prev_hunk() end, { desc = "Prev hunk" })
      vim.keymap.set("n", "<leader>gh", function() require("gitsigns").preview_hunk_inline() end, { desc = "Preview hunk" })
      vim.keymap.set("n", "<leader>gS", function() require("gitsigns").stage_hunk() end, { desc = "Stage hunk" })
      vim.keymap.set("n", "<leader>gu", function() require("gitsigns").undo_stage_hunk() end, { desc = "Undo stage hunk" })
      vim.keymap.set("n", "<leader>gb", function() require("gitsigns").toggle_current_line_blame() end, { desc = "Blame line" })
      vim.keymap.set("n", "<leader>gd", function() require("gitsigns").diffthis() end, { desc = "Diff this file" })
      vim.keymap.set("n", "<leader>gR", function() require("gitsigns").reset_hunk() end, { desc = "Reset hunk" })

      -- Search
      vim.keymap.set("n", "<leader>sf", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
      vim.keymap.set("n", "<leader>sg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
      vim.keymap.set("n", "<leader>sb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
      vim.keymap.set("n", "<leader>sh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
      vim.keymap.set("n", "<leader>sr", "<cmd>Telescope resume<cr>", { desc = "Resume last" })

      -- Buffers
      vim.keymap.set("n", "<leader>bl", "<cmd>Telescope buffers<cr>", { desc = "List buffers" })
      vim.keymap.set("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })
      vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
      vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
      vim.keymap.set("n", "<leader>bb", "<cmd>Neotree toggle buffers right<cr>", { desc = "Buffer sidebar" })

      -- Windows
      vim.keymap.set("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Split vertical" })
      vim.keymap.set("n", "<leader>ws", "<cmd>split<cr>", { desc = "Split horizontal" })
      vim.keymap.set("n", "<leader>wh", "<c-w>h", { desc = "Go left" })
      vim.keymap.set("n", "<leader>wl", "<c-w>l", { desc = "Go right" })
      vim.keymap.set("n", "<leader>wj", "<c-w>j", { desc = "Go down" })
      vim.keymap.set("n", "<leader>wk", "<c-w>k", { desc = "Go up" })
      vim.keymap.set("n", "<leader>wc", "<cmd>close<cr>", { desc = "Close window" })
      vim.keymap.set("n", "<leader>wo", "<cmd>only<cr>", { desc = "Only this window" })

      -- Code / LSP
      vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
      vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "Go to definition" })
      vim.keymap.set("n", "<leader>cD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
      vim.keymap.set("n", "<leader>ci", vim.lsp.buf.implementation, { desc = "Go to implementation" })
      vim.keymap.set("n", "<leader>cR", vim.lsp.buf.references, { desc = "References" })
      vim.keymap.set("n", "<leader>ce", vim.diagnostic.open_float, { desc = "Diagnostic float" })
      vim.keymap.set("n", "<leader>cp", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
      vim.keymap.set("n", "<leader>cn", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

      -- Toggles
      vim.keymap.set("n", "<leader>tn", function()
        vim.opt.number = not vim.opt.number:get()
      end, { desc = "Toggle line numbers" })
      vim.keymap.set("n", "<leader>tr", function()
        vim.opt.relativenumber = not vim.opt.relativenumber:get()
      end, { desc = "Toggle relative numbers" })
      vim.keymap.set("n", "<leader>td", function()
        if vim.diagnostic.is_disabled(0) then
          vim.diagnostic.enable(0)
        else
          vim.diagnostic.disable(0)
        end
      end, { desc = "Toggle diagnostics" })

      -- Projects
      vim.keymap.set("n", "<leader>pf", "<cmd>Telescope find_files cwd=vim.fn.getcwd()<cr>", { desc = "Find in cwd" })
      vim.keymap.set("n", "<leader>pr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })

      -- Quit (no group, single key)
      vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
    '';
  };
}
