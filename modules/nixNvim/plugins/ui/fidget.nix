{ config, ... }:
{
  flake.nixNvimModules.plugins.ui.fidget = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [ "fidget-nvim" ];

    extraLua = ''
      require("fidget").setup({
        notification = {
          window = {
            winblend = 0,
          },
        },
      })
    '';
  };
}
