{ config, ... }:
{
  flake.nixNvimModules.plugins.autopairs = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [ "nvim-autopairs" ];

    extraLua = ''
      require("nvim-autopairs").setup({
        check_ts = true,
        enable_check_bracket_line = false,
        enable_moveright = true,
        enable_afterquote = true,
        map_cr = true,
        map_bs = true,
        map_c_h = false,
        map_c_w = false,
      })
    '';
  };
}
