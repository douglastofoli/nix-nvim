{
  description = "Nix Neovim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # Plugins

    # Completion
    cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };

    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };

    cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };

    cmp-luasnip = {
      url = "github:saadparwaiz1/cmp_luasnip";
      flake = false;
    };

    friendly-snippets = {
      url = "github:rafamadriz/friendly-snippets";
      flake = false;
    };

    luasnip = {
      url = "github:L3MON4D3/LuaSnip";
      flake = false;
    };

    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };

    # Editor
    autopairs = {
      url = "github:windwp/nvim-autopairs";
      flake = false;
    };

    comment = {
      url = "github:numToStr/Comment.nvim";
      flake = false;
    };

    indent-blankline = {
      url = "github:lukas-reineke/indent-blankline.nvim";
      flake = false;
    };

    illuminate = {
      url = "github:RRethy/vim-illuminate";
      flake = false;
    };

    project = {
      url = "github:ahmedkhalf/project.nvim";
      flake = false;
    };

    toggleterm = {
      url = "github:akinsho/toggleterm.nvim";
      flake = false;
    };

    # LSP
    nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };

    none-ls = {
      url = "github:nvimtools/none-ls.nvim";
      flake = false;
    };

    # Lang
    elixir-tools = {
      url = "github:elixir-tools/elixir-tools.nvim";
      flake = false;
    };

    # Tools
    dap = {
      url = "github:mfussenegger/nvim-dap";
      flake = false;
    };

    dap-ui = {
      url = "github:rcarriga/nvim-dap-ui";
      flake = false;
    };

    gitsigns = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };

    plenary = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };

    # UI
    alpha-nvim = {
      url = "github:goolord/alpha-nvim";
      flake = false;
    };

    lualine = {
      url = "github:nvim-lualine/lualine.nvim";
      flake = false;
    };

    navic = {
      url = "github:SmiteshP/nvim-navic";
      flake = false;
    };

    nvim-tree = {
      url = "github:kyazdani42/nvim-tree.lua";
      flake = false;
    };

    telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };

    telescope-fzf = {
      url = "github:nvim-telescope/telescope-fzf-native.nvim";
      flake = false;
    };

    tokyonight = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };

    web-devicons = {
      url = "github:nvim-tree/nvim-web-devicons";
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

        packages = rec {
          default = nvim;
          nvim = lib.mkNeovim {inherit config;};
        };

        overlays.default = _super: _self: {
          inherit (lib) mkNeovim;
          inherit (pkgs) neovimPlugins;
          nvim = packages.default;
        };

        devShells.default = pkgs.mkShell {
          packages = [packages.default];
        };
      }
    );
}
