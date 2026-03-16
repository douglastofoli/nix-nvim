{ config, ... }:
{
  flake.nixNvimModules.plugins.ui.web-devicons = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [ "nvim-web-devicons" ];

    extraLua = ''
      require("nvim-web-devicons").setup({ default = true })
    '';
  };
}
