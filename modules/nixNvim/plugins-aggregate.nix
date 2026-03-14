# Aggregates flake.nixNvimModules.plugins.* (lsp, telescope, treesitter, etc.)
# into flake.nixNvim (pluginNames, extraPackageNames, extraLua, extraVim).
# Packages are resolved in package.nix (perSystem) with pkgs.
{ lib, config, ... }:
let
  inherit (lib)
    concatLists
    concatStringsSep
    attrValues
    filter
    ;
  pluginConfigs = config.flake.nixNvimModules.plugins or { };
  enabledPlugins = filter (p: p.enable or true) (attrValues pluginConfigs);
in
{
  config = {
    flake.nixNvim.pluginNames = concatLists (map (p: p.pluginNames or [ ]) enabledPlugins);
    flake.nixNvim.extraPackageNames = concatLists (map (p: p.extraPackageNames or [ ]) enabledPlugins);
    flake.nixNvim.extraLua = concatStringsSep "\n" (map (p: p.extraLua or "") enabledPlugins);
    flake.nixNvim.extraVim = concatStringsSep "\n" (map (p: p.extraVim or "") enabledPlugins);
  };
}
