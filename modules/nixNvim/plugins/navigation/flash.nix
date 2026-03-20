{ config, ... }:
{
  flake.nixNvimModules.plugins.navigation.flash = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [ "flash-nvim" ];

    extraLua = ''
      require("flash").setup({
        modes = {
          search = { enabled = false },
          char = { enabled = true },
        },
      })
    '';

    keymaps = {
      nnoremap = [
        {
          lhs = "s";
          rhsLua = "function() require('flash').jump() end";
          opts = {
            desc = "Flash jump";
          };
        }
        {
          lhs = "S";
          rhsLua = "function() require('flash').treesitter() end";
          opts = {
            desc = "Flash treesitter";
          };
        }
      ];
    };
  };
}
