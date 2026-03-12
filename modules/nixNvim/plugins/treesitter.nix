{ config, ... }:
{
  flake.nixNvimModules.plugins.treesitter = {
    imports = [ config.flake.nixNvimModules.plugin ];

    # Special: nvim-treesitter uses withAllGrammars in package.nix
    pluginNames = [ "nvim-treesitter" ];

    extraLua = ''
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        indent = { enable = true },
      })
    '';
  };
}
