{ lib, ... }:
{
  options.nvim = {
    # Opção para habilitar/desabilitar toda a configuração
    enable = lib.mkEnableOption "Enable neovim configuration";

    # Opção para pacotes extras que podem ser necessários
    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Extra packages to install alongside neovim";
    };

    # Opção para configurações extras em formato string
    extraConfig = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Extra configuration to be appended to the main config";
    };

    # Opção para definir o tema padrão
    colorscheme = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Default colorscheme to use";
    };
  };
}