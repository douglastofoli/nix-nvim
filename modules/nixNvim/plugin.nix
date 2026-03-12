# Option template for each plugin under flake.nixNvimModules.plugins.<name>.
# Import with: imports = [ config.flake.nixNvimModules.plugin ];
# Uses pluginNames/extraPackageNames (strings) so the flake does not depend on pkgs.
{ lib, ... }:
{
  flake.nixNvimModules.plugin = {
    options = {
      pluginNames = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };
      extraPackageNames = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };
      extraLua = lib.mkOption {
        type = lib.types.lines;
        default = "";
      };
      extraVim = lib.mkOption {
        type = lib.types.lines;
        default = "";
      };
    };
  };
}
