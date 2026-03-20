{ config, ... }:
{
  flake.nixNvimModules.plugins.ui.todo-comments = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [
      "todo-comments-nvim"
    ];

    extraLua = ''
      require("todo-comments").setup({})
    '';

    keymaps = {
      nnoremap = [
        {
          lhs = "<leader>st";
          rhs = "<cmd>TodoTelescope<cr>";
          opts = {
            desc = "Todo comments";
          };
        }
        {
          lhs = "]t";
          rhsLua = "function() require('todo-comments').jump_next() end";
          opts = {
            desc = "Next todo";
          };
        }
        {
          lhs = "[t";
          rhsLua = "function() require('todo-comments').jump_prev() end";
          opts = {
            desc = "Prev todo";
          };
        }
      ];
    };
  };
}
