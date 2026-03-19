{ config, ... }:
{
  flake.nixNvimModules.plugins.navigation.telescope = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [
      "plenary-nvim"
      "telescope-nvim"
    ];

    extraPackageNames = [
      "fd"
      "ripgrep"
    ];

    extraLua = ''
      require("telescope").setup({})
      require("telescope").load_extension("projects")
    '';
  };
}
