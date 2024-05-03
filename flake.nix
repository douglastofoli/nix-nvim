{
  description = "Nix Neovim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    lualine = {
      url = "github:nvim-lualine/lualine.nvim";
      flake = false;
    };

    which-key = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs: let
    inherit (flake-utils.lib) eachDefaultSystem mkApp;
  in
    eachDefaultSystem (
      system: let
        lib = import ./lib.nix {inherit pkgs inputs;};
        inherit (import ./overlays.nix {inherit lib;}) overlays;
        pkgs = import nixpkgs {
          inherit system overlays;
          config.allowUnfree = true;
        };

        config = import ./config.nix {inherit pkgs;};
      in rec {
        apps = rec {
          nvim = mkApp {
            drv = packages.default;
            exePath = "/bin/nvim";
          };
          default = nvim;
        };

        overlays.default = _super: _self: {
          inherit (lib) mkNeovim;
          inherit (pkgs) neovimPlugins;
          nvim = packages.default;
        };

        packages = rec {
          nvim = lib.mkNeovim {inherit config;};
          default = nvim;
        };

        devShells.default = pkgs.mkShell {
          packages = [packages.nvim];
        };
      }
    );
}
