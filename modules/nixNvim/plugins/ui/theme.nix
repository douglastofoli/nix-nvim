{ config, ... }:
{
  flake.nixNvimModules.plugins.ui.dracula = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [ "dracula-nvim" ];

    extraLua = ''
      local dracula = require("dracula")

      dracula.setup({
        transparent_bg = true,
        italic_comments = true,
      })

      vim.cmd.colorscheme("dracula")
    '';
  };
}
