{ config, ... }:
{
  flake.nixNvimModules.plugins.misc.wakatime = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [ "vim-wakatime" ];

    extraPackageNames = [ "wakatime-cli" ];
  };
}
