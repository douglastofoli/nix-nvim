{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types boolStr;
  cfg = config.nvim;
  mkMappingOption = it:
    mkOption ({
        default = {};
        type = types.attrsOf (types.nullOr types.str);
      }
      // it);
in {
  options.nvim = {
    startPlugins = mkOption {
      description = "Plugins that are runned on neovim start.";
      type = types.listOf types.package;
      default = [];
    };

    optPlugins = mkOption {
      description = "Plugin that are runned on-demand.";
      type = types.listOf types.package;
      default = [];
    };

    rawConfig = mkOption {
      description = "Raw Lua config, if necessary.";
      type = types.lines;
      default = "";
    };

    configRC = mkOption {
      description = "Raw vimscript config, used internally.";
      type = types.lines;
      default = "";
      internal = true;
    };
  };

  config.nvim = let
    inherit (lib) mapAttrsFlatten;
  in {
    configRC =
      ''
        filetype plugin indent on
        syntax on
      ''
      + "lua << EOF\n"
      + ''
        ${cfg.rawConfig}
      ''
      + "\nEOF";
  };
}
