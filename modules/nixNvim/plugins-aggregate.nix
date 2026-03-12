# Aggregates flake.nixNvimModules.plugins.* (lsp, telescope, treesitter, etc.)
# into flake.nixNvim (pluginNames, extraPackageNames, extraLua, extraVim).
# Packages are resolved in package.nix (perSystem) with pkgs.
{ lib, config, ... }:
let
  inherit (lib) concatLists concatStringsSep attrValues;
  pluginConfigs = config.flake.nixNvimModules.plugins or { };
in
{
  config = {
    flake.nixNvim.pluginNames = concatLists (map (p: p.pluginNames or [ ]) (attrValues pluginConfigs));
    flake.nixNvim.extraPackageNames = concatLists (map (p: p.extraPackageNames or [ ]) (attrValues pluginConfigs));
    flake.nixNvim.extraLua = concatStringsSep "\n" (map (p: p.extraLua or "") (attrValues pluginConfigs));
    flake.nixNvim.extraVim = concatStringsSep "\n" (map (p: p.extraVim or "") (attrValues pluginConfigs));
  };
}
