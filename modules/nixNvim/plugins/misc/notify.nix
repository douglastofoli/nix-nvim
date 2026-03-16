{ config, ... }:
{
  flake.nixNvimModules.plugins.misc.notify = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [ "nvim-notify" ];

    extraLua = ''
      require("notify").setup({
        background_colour = "#000000",
      })

      vim.notify = require("notify")
    '';
  };
}
