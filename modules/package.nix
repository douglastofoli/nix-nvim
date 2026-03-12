{ config, lib, ... }:
let
  inherit (lib) mkIf getAttr;
in
{
  perSystem = { pkgs, ... }:
    let
      cfg = config.nixNvim;

      plugins =
        builtins.map
          (name:
            if name == "nvim-treesitter" then
              pkgs.vimPlugins.nvim-treesitter.withAllGrammars
            else
              getAttr name pkgs.vimPlugins)
          cfg.pluginNames;

      runtimeDeps = builtins.map (name: getAttr name pkgs) cfg.extraPackageNames;

      nix-nvim = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
        inherit plugins runtimeDeps;

        luaRcContent = cfg.extraLua;
        neovimRcContent = cfg.extraVim;

        viAlias = cfg.viAlias;
        vimAlias = cfg.vimAlias;

        withNodeJs = cfg.withNodeJs;
        withPython3 = cfg.withPython3;
        withRuby = cfg.withRuby;
      };
    in
    mkIf cfg.enable {
      packages.${cfg.packageName} = nix-nvim;
      packages.default = nix-nvim;

      apps.default = {
        type = "app";
        program = "${nix-nvim}/bin/nvim";
      };

      apps.${cfg.packageName} = {
        type = "app";
        program = "${nix-nvim}/bin/nvim";
      };
    };
}
