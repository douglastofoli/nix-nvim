{ config, ... }:
{
  flake.nixNvimModules.plugins.navigation.oil = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [
      "oil-nvim"
    ];

    extraLua = ''
      require("oil").setup({
        skip_confirm_for_simple_edits = true,
        view_options = {
          show_hidden = true,
        },
      })
    '';
  };
}

