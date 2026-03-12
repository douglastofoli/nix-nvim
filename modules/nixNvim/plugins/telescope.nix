{ config, ... }:
{
  flake.nixNvimModules.plugins.telescope = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [
      "plenary-nvim"
      "telescope-nvim"
    ];

    extraLua = ''
      require("telescope").setup({})
    '';
  };
}
