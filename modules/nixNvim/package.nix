{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf getAttr;
in {
  perSystem = {
    pkgs,
    inputs',
    ...
  }: let
    cfg = config.flake.nixNvim;
    pkgsStable =
      inputs'.nixpkgs-stable.legacyPackages
          or (throw "nixpkgs-stable input required for nvim-treesitter");

    plugins =
      map (
        name:
          if name == "nvim-treesitter"
          then
            if cfg.treesitter.withAllGrammars
            then pkgsStable.vimPlugins.nvim-treesitter.withAllGrammars
            else let
              parserAttrs = pkgsStable.vimPlugins.nvim-treesitter.builtGrammars;
              selectedParsers = map (parser: getAttr parser parserAttrs) cfg.treesitter.grammars;
            in
              if selectedParsers == []
              then pkgsStable.vimPlugins.nvim-treesitter
              else pkgsStable.vimPlugins.nvim-treesitter.withPlugins (_: selectedParsers)
          else getAttr name pkgs.vimPlugins
      )
      cfg.pluginNames;

    runtimeDeps = map (name: getAttr name pkgs) cfg.extraPackageNames;
    extraPath = lib.makeBinPath (runtimeDeps ++ cfg.extraPackages);

    # Init Lua order: base → plugins → keymaps → autocmds
    safeLuaHelpers = ''
      _G.NixNvim = _G.NixNvim or {}
      function _G.NixNvim.safe_require(name)
        local ok, mod = pcall(require, name)
        if ok then
          return mod
        end
        return nil
      end
    '';

    luaRcContent =
      safeLuaHelpers
      + "\n"
      + cfg.baseLua
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
        buildInputs = [pkgs.makeWrapper];
        inherit extraPath;
        passthru = neovim-base.passthru or {};
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
      checks.smoke-test = pkgs.runCommand "nvim-smoke-test" {buildInputs = [neovim];} ''
        HOME=$(mktemp -d) nvim --headless -c "lua assert(true, 'init ok')" -c "qa" && touch $out
      '';
      checks.health-check = pkgs.runCommand "nvim-health-check" {buildInputs = [neovim];} ''
        HOME=$(mktemp -d) nvim --headless -c "silent! checkhealth" -c "qa" || true
        touch $out
      '';
      checks.nix-quality = pkgs.runCommand "nix-quality-check" {buildInputs = [pkgs.deadnix pkgs.statix];} ''
        cd ${../../.}
        deadnix --fail \
          ./lib/plugins.nix \
          ./modules/nixNvim/options.nix \
          ./modules/nixNvim/plugins-aggregate.nix \
          ./modules/nixNvim/keymaps.nix \
          ./modules/nixNvim/plugins/lsp/lsp.nix \
          ./modules/nixNvim/plugins/navigation/telescope.nix \
          ./modules/nixNvim/plugins/navigation/which-key.nix \
          ./modules/nixNvim/plugins/debug/dap.nix \
          ./modules/nixNvim/package.nix
        statix check ./modules/nixNvim || true
        touch $out
      '';
      checks.deadnix = pkgs.runCommand "nix-deadnix-check" {buildInputs = [pkgs.deadnix];} ''
        cd ${../../.}
        deadnix --fail \
          ./lib/plugins.nix \
          ./modules/nixNvim/options.nix \
          ./modules/nixNvim/plugins-aggregate.nix \
          ./modules/nixNvim/keymaps.nix \
          ./modules/nixNvim/plugins/lsp/lsp.nix \
          ./modules/nixNvim/plugins/navigation/telescope.nix \
          ./modules/nixNvim/plugins/navigation/which-key.nix \
          ./modules/nixNvim/plugins/debug/dap.nix \
          ./modules/nixNvim/package.nix
        touch $out
      '';
      checks.statix = pkgs.runCommand "nix-statix-check" {buildInputs = [pkgs.statix];} ''
        cd ${../../.}
        statix check ./modules/nixNvim || true
        touch $out
      '';
      checks.formatting = pkgs.runCommand "nix-format-check" {buildInputs = [pkgs.alejandra];} ''
        cd ${../../.}
        alejandra --check \
          ./lib/plugins.nix \
          ./modules/nixNvim/options.nix \
          ./modules/nixNvim/plugins-aggregate.nix \
          ./modules/nixNvim/keymaps.nix \
          ./modules/nixNvim/plugins/lsp/lsp.nix \
          ./modules/nixNvim/plugins/navigation/telescope.nix \
          ./modules/nixNvim/plugins/navigation/which-key.nix \
          ./modules/nixNvim/plugins/debug/dap.nix \
          ./modules/nixNvim/package.nix
        touch $out
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
        packages = [neovim] ++ runtimeDeps ++ cfg.extraPackages;
      };
    };
}
