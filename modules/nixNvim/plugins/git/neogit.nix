{ config, ... }:
{
  flake.nixNvimModules.plugins.git.neogit = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [
      "neogit"
      "diffview-nvim"
    ];

    extraLua = ''
      require("diffview").setup({})

      require("neogit").setup({
        integrations = {
          diffview = true,
          telescope = true,
        },
        graph_style = "unicode",
      })
    '';

    keymaps = {
      nnoremap = [
        {
          lhs = "<leader>gg";
          rhsLua = "function() require('neogit').open() end";
          opts = {
            desc = "Neogit status";
          };
        }
        {
          lhs = "<leader>gc";
          rhsLua = "function() require('neogit').open({ 'commit' }) end";
          opts = {
            desc = "Neogit commit";
          };
        }
        {
          lhs = "<leader>gl";
          rhsLua = "function() require('neogit').open({ 'log' }) end";
          opts = {
            desc = "Neogit log";
          };
        }
        {
          lhs = "<leader>gD";
          rhs = "<cmd>DiffviewOpen<cr>";
          opts = {
            desc = "Diffview open";
          };
        }
        {
          lhs = "<leader>gH";
          rhs = "<cmd>DiffviewFileHistory %<cr>";
          opts = {
            desc = "File history";
          };
        }
      ];
    };
  };
}
