{ config, ... }:
{
  flake.nixNvimModules.plugins.language.treesitter = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    # Special: nvim-treesitter uses withAllGrammars in package.nix
    pluginNames = [ "nvim-treesitter" "nvim-treesitter-context" ];

    extraLua = ''
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        indent = { enable = true },
      })

      require("treesitter-context").setup({
        enable = true,
        throttle = true,
        max_lines = 0,
      })
    '';
  };
}
