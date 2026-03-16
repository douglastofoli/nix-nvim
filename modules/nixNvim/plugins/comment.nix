{ config, ... }:
{
  flake.nixNvimModules.plugins.kommentary = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [ "kommentary" ];

    extraLua = ''
      require("kommentary.config").use_extended_mappings()
    '';
  };
}
