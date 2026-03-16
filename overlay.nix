# Receives self from the flake. Overlay for NixOS:
# nixpkgs.overlays = [ self.overlays.default ];
self: final: prev: {
  neovim = self.packages.${final.system}.neovim;
}
