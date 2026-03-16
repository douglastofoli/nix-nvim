{ config, ... }:
{
  flake.nixNvimModules.plugins.lsp.lsp = {
    imports = [ config.flake.nixNvimModules.plugin ];

    enable = true;

    pluginNames = [
      "nvim-lspconfig"
    ];

    extraPackageNames = [
      "lua-language-server"
      "nil"
    ];

    extraLua = ''
      vim.lsp.config("lua_ls", {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
      })

      vim.lsp.config("nil_ls", {
        cmd = { "nil" },
        filetypes = { "nix" },
        root_markers = { "flake.nix", ".git" },
      })

      vim.lsp.config('expert', {
        cmd = { 'expert', '--stdio' },
        root_markers = { 'mix.exs', '.git' },
        filetypes = { 'elixir', 'eelixir', 'heex' },
      })

      vim.lsp.enable("lua_ls")
      vim.lsp.enable("nil_ls")
      vim.lsp.enable("expert")

      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Definition" })
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Declaration" })
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Implementation" })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
    '';
  };
}
