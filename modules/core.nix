{ config, lib, ... }:
{
  options.core = {
    enable = lib.mkEnableOption "Enable core configuration";

    config = lib.mkOption {
      type = lib.types.str;
      default = ''
        set number
        set relativenumber
        set expandtab
        set tabstop=2
        set shiftwidth=2
      '';
      description = "Core configuration for Neovim";
    };
  };

  config = lib.mkIf config.core.enable {
    # Add any additional configuration logic here if needed
  };
}
