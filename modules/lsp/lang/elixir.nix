{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf types;
  cfg = config.nvim.lsp;
  elixir = cfg.lang.elixir;

  erlang = pkgs.beam.interpreters.erlang_26.overrideAttrs (old: {
    configureFlags = ["--disable-jit"] ++ old.configureFlags;
  });
  beam = pkgs.beam.packagesWith erlang;
in {
  options.nvim.lsp.lang = {
    elixir = {
      enable = mkEnableOption {
        description = "Enables Elixir support plugins";
        type = types.bool;
        default = false;
      };
    };
  };

  config.nvim = mkIf (cfg.enable && elixir.enable) {
    startPlugins = with pkgs.neovimPlugins; [elixir-tools nvim-elixir];

    rawConfig = ''
      require('lspconfig').elixirls.setup({
        cmd = {"${beam.elixir-ls}/bin/elixir-ls"},
      })
    '';
  };
}
