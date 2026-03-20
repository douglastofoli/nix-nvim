{lib}: let
  inherit
    (lib)
    attrValues
    concatMap
    filter
    isAttrs
    ;

  isPluginConfig = cfg:
    isAttrs cfg
    && (
      cfg ? pluginNames
      || cfg ? extraLua
      || cfg ? keymaps
      || cfg ? extraPackageNames
      || cfg ? extraVim
    );

  flattenPluginTree = attrs:
    if isPluginConfig attrs
    then [attrs]
    else if isAttrs attrs
    then concatMap flattenPluginTree (attrValues attrs)
    else [];

  enabledPlugins = pluginTree: filter (p: p.enable or true) (flattenPluginTree pluginTree);

  collectField = field: plugins: map (p: p.${field} or null) plugins;
in {
  inherit
    isPluginConfig
    flattenPluginTree
    enabledPlugins
    collectField
    ;
}
