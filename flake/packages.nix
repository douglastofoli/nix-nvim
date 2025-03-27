{
  lib,
  inputs,
  config,
  ...
}:
{
  imports = [
    ../modules/core.nix
    ../modules/options.nix
  ];

  perSystem =
    { pkgs, system, ... }:
    {
      packages = {
        default =
          let
            nvim-config = import ./lib.nix {
              inherit pkgs lib config;
            };
          in
          pkgs.neovim.override {
            configure = {
              packages.myVimPackage = {
                start = [ ]; # No plugins for now
              };
              customRC = nvim-config.generateConfig;
            };
          };
      };
    };
}
