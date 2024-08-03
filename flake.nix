{
  description = "Nix Neovim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # Plugins
    copilot = {
      url = "github:github/copilot.vim";
      flake = false;
    };

    elixir-tools = {
      url = "github:elixir-tools/elixir-tools.nvim";
      flake = false;
    };

    gitsigns-nvim = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };

    lualine = {
      url = "github:nvim-lualine/lualine.nvim";
      flake = false;
    };

    material-icons = {
      url = "github:DaikyXendo/nvim-material-icon";
      flake = false;
    };

    nvim-elixir = {
      url = "github:elixir-editors/vim-elixir";
      flake = false;
    };

    nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };

    plenary-nvim = {
      url = "github:nvim-lua/plenary.nvim/v0.1.4";
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
          default = nvim;
          nvim = mkApp {
            drv = packages.default;
            exePath = "/bin/nvim";
          };
        };

        overlays.default = _super: _self: {
          inherit (lib) mkNeovim;
          inherit (pkgs) neovimPlugins;
          nvim = packages.default;
        };

        packages = rec {
          default = nvim;
          nvim = lib.mkNeovim {inherit config;};
        };

        devShells.default = pkgs.mkShell {
          packages = [packages.default];
        };
      }
    );
}
