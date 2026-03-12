{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  # Dendritic pattern: flake.nixNvimModules.base, .plugin, .plugins.<name>
  options.flake.nixNvimModules = mkOption {
    type = types.attrsOf types.anything;
    default = { };
    description = "nixNvim modules (base, plugin, plugins.lsp, etc.).";
  };

  options.flake.nixNvim = mkOption {
    type = types.submodule {
      options = {
        enable = mkOption {
          type = types.bool;
          default = true;
        };

        packageName = mkOption {
          type = types.str;
          default = "nix-nvim";
        };

        plugins = mkOption {
          type = types.listOf types.package;
          default = [ ];
          description = "Plugin packages (can be filled by package.nix from pluginNames).";
        };

        pluginNames = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Vim plugin names (e.g. nvim-lspconfig) resolved via pkgs.vimPlugins.";
        };

        extraPackages = mkOption {
          type = types.listOf types.package;
          default = [ ];
          description = "Extra packages on PATH (can be filled by package.nix from extraPackageNames).";
        };

        extraPackageNames = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Extra package names (e.g. lua-language-server) resolved via pkgs.";
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
    };

    default = { };
  };
}
