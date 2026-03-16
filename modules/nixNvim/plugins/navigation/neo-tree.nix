{ config, ... }:
{
  flake.nixNvimModules.plugins.navigation.neo-tree = {
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
    '';
  };
}
