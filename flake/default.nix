{ inputs, ... }:
{
  imports = [
    ./packages.nix
  ];

  perSystem =
    { pkgs, system, ... }:
    {
      # As opções agora estão dentro do namespace 'nvim'
      nvim = {
        enable = true;
        colorscheme = "default";
        extraConfig = ''
          set clipboard+=unnamedplus
        '';
        extraPackages = with pkgs; [
          ripgrep
          fd
        ];
      };

      # Ative o módulo core
      core.enable = true;
    };
}
