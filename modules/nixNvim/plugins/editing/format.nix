{ config, ... }:
{
  flake.nixNvimModules.plugins.editing.format = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [
      "conform-nvim"
    ];

    extraPackageNames = [
      "stylua"
      "nixfmt"
    ];

    extraLua = ''
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          nix = { "nixfmt" },
          elixir = { "mix" },
          heex = { "mix" },
          eelixir = { "mix" },
        },

        format_on_save = {
          timeout_ms = 1000,
          lsp_format = "fallback",
        },
      })

      vim.keymap.set({ "n", "v" }, "<leader>f", function()
        require("conform").format({
          async = true,
          lsp_format = "fallback",
        })
      end)
    '';
  };
}
