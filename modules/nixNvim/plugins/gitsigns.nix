{ config, ... }:
{
  flake.nixNvimModules.plugins.gitsigns = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [ "gitsigns-nvim" ];

    extraLua = ''
      require("gitsigns").setup({
        signcolumn = true,
        numhl = false,
        linehl = false,
        current_line_blame = true,
      })
    '';
  };
}
