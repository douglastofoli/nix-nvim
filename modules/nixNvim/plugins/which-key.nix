{ config, ... }:
{
  flake.nixNvimModules.plugins.which-key = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [ "which-key-nvim" ];

    extraLua = ''
      vim.opt.timeout = true
      vim.opt.timeoutlen = 300

      require("which-key").setup({
        delay = 200,
        icons = {
          group = "",
          separator = " ",
        },
        win = {
          border = "rounded",
          padding = { 1, 2 },
        },
        triggers = { "<leader>" },
      })
    '';
  };
}
