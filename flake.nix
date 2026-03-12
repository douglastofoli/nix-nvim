# nix-nvim: configurable Neovim derivation via flake.
# - Dendritic pattern: flake.nixNvimModules.base, .plugin, .plugins.<name>
# - NixOS usage: nixpkgs.overlays = [ self.overlays.default ];
# - devShell: nix develop (uses packages.nix-nvim)
{
  description = "nix-nvim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
  };

  outputs =
    inputs@{
      self,
      flake-parts,
      import-tree,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      import-tree ./modules
      // {
        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "x86_64-darwin"
          "aarch64-darwin"
        ];

        perSystem = _: { };

        flake.overlays.default = import ./overlay.nix self;
      }
    );
}
