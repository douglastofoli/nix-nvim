{ config, ... }:
{
  flake.nixNvimModules.plugins.indent-blankline = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [ "indent-blankline-nvim" ];

    extraLua = ''
      vim.api.nvim_set_hl(0, "IblIndent", { fg = "#393b42" })
      require("ibl").setup({
        indent = { char = "│", highlight = { "IblIndent" } },
        scope = { show_start = false, show_end = false },
        exclude = { filetypes = { "lua", "help", "dashboard" } },
      })
    '';
  };
}
