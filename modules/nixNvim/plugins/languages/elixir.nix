# elixir-tools.nvim: Mix, test, and Elixir helpers.
# Uses expert LSP from lsp.nix; this plugin adds :Mix, run test, etc.
# Keybinds use <leader>m* for split-keyboard friendliness.
{ config, ... }:
{
  flake.nixNvimModules.plugins.elixir = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [
      "elixir-tools-nvim"
    ];

    extraLua = ''
      -- Use expert LSP from lsp.nix; only use elixir-tools for Mix/test/creates.
      -- Mix keybinds + which-key group "mix" are registered in plugins.autocmd (FileType elixir).
      require("elixir").setup({
        nextls = { enable = false },
        elixirls = { enable = false },
        credo = { enable = false },
        projectionist = { enable = true },
      })
    '';
  };
}
