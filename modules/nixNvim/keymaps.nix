# Collects keymaps from flake.nixNvim.keymaps (global) and from each plugin's keymaps,
# generates Lua (which-key groups + vim.keymap.set). Final init order is assembled in package.nix.
{
  lib,
  config,
  ...
}: let
  inherit
    (lib)
    concatMap
    concatStringsSep
    isAttrs
    mapAttrsToList
    ;
  keymapsType = import ../../lib/keymaps-type.nix {inherit lib;};
  pluginsLib = import ../../lib/plugins.nix {inherit lib;};
  sections = keymapsType.sections;

  # Section name -> { mode, noremap }
  sectionMode = {
    nnoremap = {
      mode = "n";
      noremap = true;
    };
    inoremap = {
      mode = "i";
      noremap = true;
    };
    vnoremap = {
      mode = "v";
      noremap = true;
    };
    snoremap = {
      mode = "s";
      noremap = true;
    };
    nmap = {
      mode = "n";
      noremap = false;
    };
    imap = {
      mode = "i";
      noremap = false;
    };
    vmap = {
      mode = "v";
      noremap = false;
    };
    smap = {
      mode = "s";
      noremap = false;
    };
  };

  # Collect normalized keymaps from one config (global or plugin)
  collectKeymapsFromOne = cfg:
    if cfg == null || !(isAttrs cfg)
    then []
    else let
      keymaps = cfg.keymaps or {};
      fromSection = sectionName: let
        entries = keymaps.${sectionName} or [];
        sm =
          sectionMode.${
            sectionName
          } or {
            mode = "n";
            noremap = true;
          };
      in
        map (e: {
          inherit (sm) mode noremap;
          lhs = e.lhs or "";
          rhs = e.rhs or "";
          rhsLua = e.rhsLua or null;
          opts = e.opts or {};
        })
        entries;
    in
      concatMap fromSection sections;

  pluginConfigs = config.flake.nixNvimModules.plugins or {};
  enabledPlugins = pluginsLib.enabledPlugins pluginConfigs;

  # Collect whichKeyGroups from one config (global or plugin)
  collectWhichKeyGroupsFromOne = cfg:
    if cfg == null || !(isAttrs cfg)
    then []
    else (cfg.keymaps or {}).whichKeyGroups or [];

  allWhichKeyGroups =
    (collectWhichKeyGroupsFromOne config.flake.nixNvim)
    ++ (concatMap collectWhichKeyGroupsFromOne enabledPlugins);

  globalKeymaps = collectKeymapsFromOne config.flake.nixNvim;
  pluginKeymaps = concatMap collectKeymapsFromOne enabledPlugins;
  allKeymaps = globalKeymaps ++ pluginKeymaps;

  # Escape a string for use inside double quotes in Lua
  escapeLuaStr = s: builtins.replaceStrings ["\\" "\"" "\n"] ["\\\\" "\\\"" "\\n"] (toString s);

  # Serialize opts to Lua table for vim.keymap.set
  optsToLua = opts: let
    optEntry = k: v:
      if builtins.typeOf v == "bool"
      then "${k} = ${
        if v
        then "true"
        else "false"
      }"
      else if builtins.typeOf v == "string"
      then "${k} = \"${escapeLuaStr v}\""
      else "";
    noremapVal =
      if (opts.noremap or true)
      then "true"
      else "false";
    parts = ["noremap = ${noremapVal}"];
    parts' =
      parts
      ++ (
        if opts ? desc
        then ["desc = \"${escapeLuaStr opts.desc}\""]
        else []
      );
    silentVal =
      if opts.silent
      then "true"
      else "false";
    parts'' =
      parts'
      ++ (
        if opts ? silent
        then ["silent = ${silentVal}"]
        else []
      );
    rest = lib.attrsets.filterAttrs (k: _: k != "desc" && k != "silent" && k != "noremap") opts;
    restLua = mapAttrsToList optEntry rest;
  in
    "{ " + lib.strings.concatStringsSep ", " (parts'' ++ restLua) + " }";

  mkKeymapLua = km: let
    modeStr = "\"" + escapeLuaStr km.mode + "\"";
    lhsStr = "\"" + escapeLuaStr km.lhs + "\"";
    rhsArg =
      if (km.rhsLua or null) != null && km.rhsLua != ""
      then km.rhsLua
      else "\"" + escapeLuaStr km.rhs + "\"";
    optsStr = optsToLua (km.opts // {noremap = km.noremap;});
  in "vim.keymap.set(${modeStr}, ${lhsStr}, ${rhsArg}, ${optsStr})";

  whichKeyGroupsLua =
    if allWhichKeyGroups == []
    then ""
    else let
      groupLines =
        map (
          g: ''{ "${escapeLuaStr (g.prefix or "")}", group = "${escapeLuaStr (g.group or "")}" },''
        )
        allWhichKeyGroups;
    in
      ''
        if package.loaded["which-key"] then
          require("which-key").add({
      ''
      + (concatStringsSep "\n          " groupLines)
      + ''
          })
        end
      '';
  keymapsLua =
    whichKeyGroupsLua
    + (
      if whichKeyGroupsLua != ""
      then "\n"
      else ""
    )
    + (concatStringsSep "\n" (map mkKeymapLua allKeymaps));
in {
  config = {
    flake.nixNvim.extraLuaKeymaps = keymapsLua;
  };
}
