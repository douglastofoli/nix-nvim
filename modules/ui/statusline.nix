{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.nvim.ui.statusline;
in {
  options.nvim.ui = {
    statusline = {
      enable = mkEnableOption {
        description = "Enables LuaLine plugin.";
        type = types.bool;
        default = false;
      };
      theme = mkOption {
        description = "The statusline theme.";
        type = types.enum ["auto" "catppuccin" "dracula"];
        default = "auto";
      };
    };
  };

  config.nvim = mkIf cfg.enable {
    startPlugins = with pkgs.neovimPlugins; [lualine];

    rawConfig = ''
      require('lualine').setup {
        options = {
          icons_enabled = true;
          theme = ${cfg.theme};
        },
        sections = {
          lualine_a = { "mode" }
        }
      }
    '';
  };
}
