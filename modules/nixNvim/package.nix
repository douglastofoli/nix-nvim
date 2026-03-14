{ config, lib, ... }:
let
  inherit (lib) mkIf getAttr;
in
{
  perSystem =
    { pkgs, system, inputs', ... }:
    let
      cfg = config.flake.nixNvim;
      pkgsStable = inputs'.nixpkgs-stable.legacyPackages or (throw "nixpkgs-stable input required for nvim-treesitter");
      
      plugins = map (
        name:
        if name == "nvim-treesitter" then
          pkgsStable.vimPlugins.nvim-treesitter.withAllGrammars
        else
          getAttr name pkgs.vimPlugins
      ) cfg.pluginNames;

      runtimeDeps = map (name: getAttr name pkgs) cfg.extraPackageNames;
      extraPath = lib.makeBinPath (runtimeDeps ++ cfg.extraPackages);

      nix-nvim-base = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
        plugins = plugins ++ cfg.plugins;

        luaRcContent = cfg.baseLua + "\n" + cfg.extraLua;
        neovimRcContent = cfg.extraVim;

        viAlias = cfg.viAlias;
        vimAlias = cfg.vimAlias;

        withNodeJs = cfg.withNodeJs;
        withPython3 = cfg.withPython3;
        withRuby = cfg.withRuby;
      };

      nix-nvim =
        pkgs.runCommand "nix-nvim-${cfg.packageName}"
          {
            buildInputs = [ pkgs.makeWrapper ];
            inherit extraPath;
            passthru = nix-nvim-base.passthru or { };
          }
          ''
            mkdir -p $out
            for x in ${nix-nvim-base}/*; do
              ln -s "$x" "$out/$(basename "$x")"
            done
            rm -rf $out/bin
            mkdir -p $out/bin
            for f in ${nix-nvim-base}/bin/*; do
              name=$(basename "$f")
              if [ "$name" = "nvim" ]; then
                makeWrapper "$f" "$out/bin/nvim" --suffix PATH : "$extraPath"
              else
                ln -s "$f" "$out/bin/$name"
              fi
            done
          '';
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

      devShells.default = pkgs.mkShell {
        packages = [ nix-nvim ] ++ runtimeDeps ++ cfg.extraPackages;
      };
    };
}
