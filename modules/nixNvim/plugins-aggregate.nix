# Aggregates flake.nixNvimModules.plugins.<category>.<name> (e.g. plugins.git.gitsigns, plugins.ui.dracula)
# into flake.nixNvim (pluginNames, extraPackageNames, extraLua, extraVim).
# Packages are resolved in package.nix (perSystem) with pkgs.
{ lib, config, ... }:
let
  inherit (lib)
    concatLists
    concatStringsSep
    attrValues
    filter
    concatMap
    isAttrs
    ;
  pluginConfigs = config.flake.nixNvimModules.plugins or { };
  # Flatten tree: plugins may be flat (plugins.gitsigns) or nested (plugins.ui.theme)
  isPlugin = p: isAttrs p && p ? pluginNames;
  flattenPlugins =
    attrs:
    if isPlugin attrs then
      [ attrs ]
    else if isAttrs attrs then
      concatMap flattenPlugins (attrValues attrs)
    else
      [ ];
  enabledPlugins = filter (p: p.enable or true) (flattenPlugins pluginConfigs);
in
{
  config = {
    flake.nixNvim.pluginNames = concatLists (map (p: p.pluginNames or [ ]) enabledPlugins);
    flake.nixNvim.extraPackageNames = concatLists (map (p: p.extraPackageNames or [ ]) enabledPlugins);
    flake.nixNvim.extraLuaPlugins = concatStringsSep "\n" (map (p: p.extraLua or "") enabledPlugins);
    flake.nixNvim.extraVim = concatStringsSep "\n" (map (p: p.extraVim or "") enabledPlugins);
  };
}
