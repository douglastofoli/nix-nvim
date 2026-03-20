{ config, lib, ... }:
let
  inherit (lib) mkIf getAttr;
in
{
  perSystem =
    {
      pkgs,
      system,
      inputs',
      ...
    }:
    let
      cfg = config.flake.nixNvim;
      pkgsStable =
        inputs'.nixpkgs-stable.legacyPackages
          or (throw "nixpkgs-stable input required for nvim-treesitter");

      plugins = map (
        name:
        if name == "nvim-treesitter" then
          pkgsStable.vimPlugins.nvim-treesitter.withAllGrammars
        else
          getAttr name pkgs.vimPlugins
      ) cfg.pluginNames;

      runtimeDeps = map (name: getAttr name pkgs) cfg.extraPackageNames;
      extraPath = lib.makeBinPath (runtimeDeps ++ cfg.extraPackages);

      # Init Lua order: base → plugins → keymaps → autocmds
      luaRcContent =
        cfg.baseLua
        + "\n"
        + (cfg.extraLuaPlugins or "")
        + "\n"
        + (cfg.extraLuaKeymaps or "")
        + "\n"
        + (cfg.extraLuaAutocmds or "");

      neovim-base = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
        plugins = plugins ++ cfg.plugins;

        luaRcContent = luaRcContent;
        neovimRcContent = cfg.extraVim;

        viAlias = cfg.viAlias;
        vimAlias = cfg.vimAlias;

        withNodeJs = cfg.withNodeJs;
        withPython3 = cfg.withPython3;
        withRuby = cfg.withRuby;
      };

      neovim =
        pkgs.runCommand cfg.packageName
          {
            buildInputs = [ pkgs.makeWrapper ];
            inherit extraPath;
            passthru = neovim-base.passthru or { };
          }
          ''
            mkdir -p $out
            for x in ${neovim-base}/*; do
              ln -s "$x" "$out/$(basename "$x")"
            done
            rm -rf $out/bin
            mkdir -p $out/bin
            for f in ${neovim-base}/bin/*; do
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
      checks.smoke-test = pkgs.runCommand "nvim-smoke-test" { buildInputs = [ neovim ]; } ''
        HOME=$(mktemp -d) nvim --headless -c "lua assert(true, 'init ok')" -c "qa" && touch $out
      '';

      packages.${cfg.packageName} = neovim;
      packages.default = neovim;

      apps.default = {
        type = "app";
        program = "${neovim}/bin/nvim";
      };

      apps.${cfg.packageName} = {
        type = "app";
        program = "${neovim}/bin/nvim";
      };

      devShells.default = pkgs.mkShell {
        packages = [ neovim ] ++ runtimeDeps ++ cfg.extraPackages;
      };
    };
}
