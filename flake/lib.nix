{ pkgs, lib, config }:
let
  cfg = config.nvim;
  # Função auxiliar para gerar configuração
  generateConfig = ''
    ${config.core.config}
    ${cfg.extraConfig}
    ${lib.optionalString (cfg.colorscheme != "") "colorscheme ${cfg.colorscheme}"}
  '';
in {
  plugins = [];
  generateConfig = generateConfig;
  extraPackages = cfg.extraPackages;
}