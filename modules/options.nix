{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.nixNvim = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };

    packageName = mkOption {
      type = types.str;
      default = "nix-nvim";
    };

    pluginNames = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Nomes dos plugins em pkgs.vimPlugins.";
    };

    extraPackageNames = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Nomes de pacotes em pkgs usados como runtime deps.";
    };

    extraLua = mkOption {
      type = types.lines;
      default = "";
    };

    extraVim = mkOption {
      type = types.lines;
      default = "";
    };

    viAlias = mkOption {
      type = types.bool;
      default = true;
    };

    vimAlias = mkOption {
      type = types.bool;
      default = true;
    };

    withNodeJs = mkOption {
      type = types.bool;
      default = true;
    };

    withPython3 = mkOption {
      type = types.bool;
      default = true;
    };

    withRuby = mkOption {
      type = types.bool;
      default = false;
    };
  };
}
