# Aggregates flake.nixNvimModules.plugins.<category>.<name> (e.g. plugins.git.gitsigns, plugins.ui.dracula)
# into flake.nixNvim (pluginNames, extraPackageNames, extraLua, extraVim).
# Packages are resolved in package.nix (perSystem) with pkgs.
{
  lib,
  config,
  ...
}: let
  inherit
    (lib)
    concatLists
    concatStringsSep
    ;
  pluginsLib = import ../../lib/plugins.nix {inherit lib;};
  pluginConfigs = config.flake.nixNvimModules.plugins or {};
  enabledPlugins = pluginsLib.enabledPlugins pluginConfigs;
in {
  config = {
    flake.nixNvim.pluginNames = concatLists (map (p: p.pluginNames or []) enabledPlugins);
    flake.nixNvim.extraPackageNames = concatLists (map (p: p.extraPackageNames or []) enabledPlugins);
    flake.nixNvim.extraLuaPlugins = concatStringsSep "\n" (map (p: p.extraLua or "") enabledPlugins);
    flake.nixNvim.extraVim = concatStringsSep "\n" (map (p: p.extraVim or "") enabledPlugins);
  };
}
