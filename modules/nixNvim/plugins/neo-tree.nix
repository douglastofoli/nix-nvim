{ config, ... }:
{
  flake.nixNvimModules.plugins.neo-tree = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [
      "nui-nvim"
      "neo-tree-nvim"
      "nvim-web-devicons"
    ];

    extraLua = ''
      require("neo-tree").setup({
        close_if_last_window = true,
        window = {
          position = "left",
          width = 35,
          mappings = {
            ["<cr>"] = "open",
            ["o"] = "open",
            ["l"] = "open",
            ["h"] = "close_node",
            ["z"] = "close_all_nodes",
            ["Z"] = "expand_all_nodes",
            ["a"] = "add",
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy",
            ["m"] = "move",
            ["q"] = "close_window",
            ["R"] = "refresh",
            ["?"] = "show_help",
          },
        },
        filesystem = {
          follow_current_file = { enabled = true },
          hijack_netrw_behavior = "open_default",
          use_libuv_file_watcher = true,
        },
        buffers = {
          show_unloaded = true,
        },
        git_status = {
          symbols = {
            added = "A",
            modified = "M",
            deleted = "D",
            renamed = "R",
            untracked = "U",
            ignored = "I",
            unstaged = " ",
            staged = " ",
            conflict = "!",
          },
        },
      })

      -- Atalhos globais
      vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle filesystem left reveal<cr>", { desc = "Neo-tree: toggle filesystem" })
      vim.keymap.set("n", "<leader>E", "<cmd>Neotree focus filesystem left<cr>", { desc = "Neo-tree: focus filesystem" })
      vim.keymap.set("n", "<leader>b", "<cmd>Neotree toggle buffers right<cr>", { desc = "Neo-tree: toggle buffers" })
      vim.keymap.set("n", "<leader>s", "<cmd>Neotree float git_status<cr>", { desc = "Neo-tree: git status" })
      vim.keymap.set("n", "<leader>ge", "<cmd>Neotree reveal<cr>", { desc = "Neo-tree: reveal current file" })
    '';
  };
}
