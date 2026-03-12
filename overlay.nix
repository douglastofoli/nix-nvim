# Receives self from the flake. Overlay for NixOS:
# nixpkgs.overlays = [ self.overlays.default ];
self: final: prev: {
  nix-nvim = self.packages.${final.system}.nix-nvim;
}
