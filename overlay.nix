{ config, ... }:

final: prev: {
  nix-nvim = config.perSystem.${final.system}.packages.nix-nvim;
}
