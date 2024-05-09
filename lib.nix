{
  pkgs,
  inputs,
}: let
  inherit (pkgs.lib) evalModules;
in {
  withPlugins = cond: plugins:
    if cond
    then plugins
    else [];
  writeIf = cond: msg:
    if cond
    then msg
    else "";
  boolStr = cond:
    if cond
    then "true"
    else "false";
  withAttrSet = cond: attrSet:
    if cond
    then attrSet
    else {};

  mkNeovim = {config}: let
    nvim = opts.config.nvim;
    opts = evalModules {
      modules = [
        {imports = [./modules];}
        config
      ];
      specialArgs = {inherit pkgs;};
    };
  in
    pkgs.wrapNeovim nvim.package {
      withNodeJs = true;
      withPython3 = true;
      configure = {
        customRC = nvim.configRC;
        packages.myVimPackage = {
          start = nvim.startPlugins;
          opt = nvim.optPlugins;
        };
      };
    };

  buildPluginOverlay = super: self: let
    inherit (pkgs.lib.lists) last;
    inherit (pkgs.lib.strings) splitString;
    inherit (pkgs.lib.attrsets) attrByPath;
    inherit (builtins) attrNames getAttr listToAttrs filter;
    inherit (self.vimUtils) buildVimPlugin;
    isPlugin = name: name != "nixpkgs" && name != "flake-utils";
    plugins = filter isPlugin (attrNames inputs);
    buildPlugin = name:
      buildVimPlugin {
        pname = name;
        version = last (splitString "/" (attrByPath [name "url"] "HEAD" inputs));
        src = getAttr name inputs;
      };
  in {
    neovimPlugins = listToAttrs (map
      (name: {
        inherit name;
        value = buildPlugin name;
      })
      plugins);
  };
}
