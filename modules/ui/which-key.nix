{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf types;
  cfg = config.nvim.ui.whichkey;
in {
  options.nvim.ui = {
    whichkey = {
      enable = mkEnableOption {
        description = "Enable WhichKey plugin.";
        type = types.bool;
        default = true;
      };
    };
  };

  config.nvim = mkIf cfg.enable {
    startPlugins = with pkgs.neovimPlugins; [which-key];

    rawConfig = ''
      require('which-key').setup()
    '';
  };
}
