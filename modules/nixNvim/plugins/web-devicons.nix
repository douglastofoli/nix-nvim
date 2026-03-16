{ config, ... }:
{
  flake.nixNvimModules.plugins.web-devicons = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [ "nvim-web-devicons" ];

    extraLua = ''
      require("nvim-web-devicons").setup({ default = true })
    '';
  };
}
